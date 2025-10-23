import textwrap
from pathlib import Path

from patch_ninja import patch_build_ninja_content


def test_patch_inserts_block_and_updates_libmain():
    # sample build.ninja excerpt
    build = textwrap.dedent(
        """
        build cmake_object_order_depends_target___idf_main: phony || cmake_object_order_depends_target___idf_app_trace

        build esp-idf/main/CMakeFiles/__idf_main.dir/src/main.c.obj: C_COMPILER____idf_main_ /home/wokwi/esp-project-esp32/main/src/main.c || cmake_object_order_depends_target___idf_main
          DEFINES = -DESP_PLATFORM
          DEP_FILE = esp-idf/main/CMakeFiles/__idf_main.dir/src/main.c.obj.d

        #############################################
        # Link the static library esp-idf/main/libmain.a

        build esp-idf/main/libmain.a: C_STATIC_LIBRARY_LINKER____idf_main_ esp-idf/main/CMakeFiles/__idf_main.dir/src/main.c.obj || esp-idf/app_trace/libapp_trace.a
    """
    )

    # Extra sources to add
    src_files = [
        Path("/home/wokwi/esp-project-esp32/main/src/main.c"),  # already exists
        Path("/home/wokwi/esp-project-esp32/main/src/footpad.c"),
    ]

    new = patch_build_ninja_content(build, src_files)

    # assert the new object stanza exists
    assert "build esp-idf/main/CMakeFiles/__idf_main.dir/src/footpad.c.obj:" in new

    # assert libmain.a line includes the existing and new object files
    assert (
        "build esp-idf/main/libmain.a: C_STATIC_LIBRARY_LINKER____idf_main_ esp-idf/main/CMakeFiles/__idf_main.dir/src/footpad.c.obj esp-idf/main/CMakeFiles/__idf_main.dir/src/main.c.obj"
        in new
    )

def test_error_on_relative_paths():
    # Extra sources to add (one is relative)
    src_files = [
        Path("/home/wokwi/esp-project-esp32/main/src/footpad.c"),
        Path("relative/path/to/file.c"),
    ]

    try:
        patch_build_ninja_content("", src_files)
    except ValueError as e:
        assert str(e) == "src_files must be a list of absolute Path objects"
    else:
        assert False, "Expected ValueError for relative paths"


def test_no_block_found_returns_same():
    build = "some unrelated content\n"
    new = patch_build_ninja_content(build, [Path("/home/wokwi/a.c")])
    assert new == build

#!/usr/bin/env python3
import sys
from pathlib import Path
import argparse


def parse_args(argv):
    p = argparse.ArgumentParser(
        prog="patch_ninja",
        description="Scaffold to parse arguments for patching build.ninja",
    )
    p.add_argument("src_dir", help="Path to source directory", type=Path)
    p.add_argument("build_ninja", help="Path to build.ninja file", type=Path)
    p.add_argument(
        "-v",
        "--verbose",
        help="Print parsed values",
        action="store_true",
    )
    return p.parse_args(argv)


def main(argv):
    args = parse_args(argv)

    if not args.src_dir.exists() or not args.src_dir.is_dir():
        print(
            f"error: src_dir does not exist or is not a directory: {args.src_dir}",
            file=sys.stderr,
        )
        return 2

    if not args.build_ninja.exists() or not args.build_ninja.is_file():
        print(
            f"error: build_ninja does not exist or is not a file: {args.build_ninja}",
            file=sys.stderr,
        )
        return 2

    if args.verbose:
        print(f"src_dir: {args.src_dir.resolve()}")
        print(f"build_ninja: {args.build_ninja.resolve()}")

    # Collect source files as absolute Path objects:
    source_files = [p.resolve() for p in args.src_dir.rglob("*.c") if p.is_file()]

    # Read build.ninja content
    build_text = args.build_ninja.read_text(encoding="utf-8")

    new_text = patch_build_ninja_content(build_text, source_files)

    if new_text != build_text:
        if args.verbose:
            print(f"Patching {args.build_ninja}")
        args.build_ninja.write_text(new_text, encoding="utf-8")

    return 0


def patch_build_ninja_content(build_text: str, src_files: list) -> str:
    """Return modified build.ninja content.

    @param build_text: Original build.ninja content
    @param src_files: List of Path objects representing extra source files to add, must be full paths

    - Find the compile block that starts with
      'build esp-idf/main/CMakeFiles/__idf_main.dir/src/' and is followed by indented lines.
    - Duplicate that block for each extra source file found and replace the source path and object names.
    - Update the 'build esp-idf/main/libmain.a:' line to include the new object files.
    """
    if not all(isinstance(p, Path) for p in src_files) or not all(
        p.is_absolute() for p in src_files
    ):
        raise ValueError("src_files must be a list of absolute Path objects")

    lines = build_text.splitlines()

    # Find the first compile block header for src/main.c.obj (or any src/*.c.obj)
    block_start_idx = None
    for i, l in enumerate(lines):
        if (
            l.startswith("build esp-idf/main/CMakeFiles/__idf_main.dir/src/")
            and ":" in l
        ):
            # this is a compile block start
            block_start_idx = i
            break

    if block_start_idx is None:
        return build_text

    # collect the whole block: header line and following indented lines
    block_end_idx = block_start_idx + 1
    while block_end_idx < len(lines) and (
        lines[block_end_idx].startswith("  ") or lines[block_end_idx].strip() == ""
    ):
        block_end_idx += 1

    base_block = lines[block_start_idx:block_end_idx]

    # Identify the original source path in the header
    header = base_block[0]
    # header format: build esp-idf/.../main.c.obj: C_COMPILER____idf_main_ /home/..../main.c || ...
    parts = header.split()
    if len(parts) < 3:
        return build_text

    orig_obj = parts[1].rstrip(":")
    # find source path in header (first token that starts with '/' or contains '/main/')
    orig_src = None
    for tok in parts:
        if tok.endswith(".c") or ("/" in tok and tok.endswith(".c")):
            orig_src = tok
            break
    if orig_src is None:
        # fallback: try to parse after the rule name
        if len(parts) >= 4:
            orig_src = parts[3]

    # Build list of object paths to add (for all src_files excluding main.c if already present)
    obj_paths = []
    for p in src_files:
        # normalize to posix path under project, but tests will supply Path-like strings
        fname = Path(p).name
        obj = (
            f"esp-idf/main/CMakeFiles/__idf_main.dir/src/{fname}.obj"
            if not fname.endswith(".c")
            else f"esp-idf/main/CMakeFiles/__idf_main.dir/src/{fname}.obj"
        )
        obj_paths.append(obj)

    # Deduplicate and keep original order
    obj_paths = list(dict.fromkeys(obj_paths))

    # Insert new blocks for each src file that doesn't already have a block
    # First, gather existing object basenames present in the file
    existing_objs = set()
    for i, l in enumerate(lines):
        if (
            l.startswith("build esp-idf/main/CMakeFiles/__idf_main.dir/src/")
            and ":" in l
        ):
            tok = l.split()[1].rstrip(":")
            existing_objs.add(Path(tok).name)

    # New blocks to insert (skip those already present)
    new_blocks = []
    for p in src_files:
        fname = Path(p).name
        objname = f"{fname}.obj"
        if objname in existing_objs:
            continue
        # create new header by replacing object and source path
        new_header = base_block[0].replace(Path(orig_obj).name, objname)
        # replace source path occurrence (the source file path appears after the rule token)
        if orig_src:
            new_header = new_header.replace(orig_src, str(p))
        # adjust DEP_FILE and other lines that contain the object name
        new_block = [new_header]
        for sub in base_block[1:]:
            new_block.append(
                sub.replace(Path(orig_obj).name, objname).replace(
                    Path(orig_src).name if orig_src else "", Path(p).name
                )
            )
        new_blocks.append("\n".join(new_block))

    # Insert new blocks before the original block_end_idx
    insert_at = block_end_idx
    if new_blocks:
        # place them just before the original compile block for main.c (so they appear nearby)
        lines[insert_at:insert_at] = [""] + [b for b in new_blocks]

    # Update the libmain.a line
    for i, l in enumerate(lines):
        if l.startswith("build esp-idf/main/libmain.a:"):
            assert "||" in l, "Expected '||' in libmain.a line"
            before, after = l.split("||", 1)
            # before contains 'build esp-idf/main/libmain.a: C_STATIC_LIBRARY_LINKER____idf_main_ <objs> '
            tokens = before.split()
            # tokens[0] == 'build', tokens[1] == 'esp-idf/main/libmain.a:', tokens[2] == rule
            # existing_objs_tokens = tokens[3:]
            new_tokens = tokens[:3]
            for obj in sorted(obj_paths):
                new_tokens.append(obj)
            new_before = " ".join(new_tokens) + " "
            lines[i] = new_before + "||" + after
            break

    return "\n".join(lines) + ("\n" if build_text.endswith("\n") else "")


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))

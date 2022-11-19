const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();

    const exe = b.addStaticLibrary("chip_zig", "src/lib.zig");
    exe.setTarget(.{ .cpu_arch = .wasm32, .os_tag = .freestanding });
    exe.setBuildMode(mode);
    exe.install();

    const exe_tests = b.addTest("src/lib.zig");
    exe_tests.setTarget(.{ .cpu_arch = .wasm32, .os_tag = .freestanding });
    exe_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}

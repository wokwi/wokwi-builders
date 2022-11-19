const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    b.prominent_compile_errors = true;
    const mode = b.standardReleaseOptions();
    const target: std.zig.CrossTarget = .{ .cpu_arch = .wasm32, .os_tag = .freestanding };

    const lib = b.addSharedLibrary("chip_zig", "src/lib.zig", .unversioned);
    lib.setTarget(target);
    lib.setBuildMode(mode);
    lib.addPackagePath("wokwi", "wokwi/wokwi_chip_ll.zig");
    lib.export_table = true;
    lib.install();
}

const std = @import("std");
const wokwi = @import("wokwi_chip_ii.zig");

// TODO
const Chip = extern struct {
    pin_in: wokwi.PinId,
    pin_out: wokwi.PinId,
};

pub export fn chipInit() callconv(.C) void {
    std.debug.print("Hello {s}!\n", .{"Zig"});
    //    const chip = Chip{
    //        .pin_in = wokwi.pinInit("IN", wokwi.INPUT),
    //        .pin_out = wokwi.pinInit("OUT", wokwi.OUTPUT),
    //    };
    //    _ = chip;
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

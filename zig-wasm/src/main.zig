const std = @import("std");

// TODO
const PinId = opaque {};
const Chip = extern struct {
    pin_in: PinId,
    pin_out: PinId,
};
// pub const INPUT = 0;
// pub const OUTPUT = 0;

pub extern fn pinInit(info: [*:0]const u8, io: u32) callconv(.C) PinId;

pub export fn chipInit() callconv(.C) void {
    std.debug.print("Hello {s}!\n", .{"Zig"});

    // const chip = Chip{
    //     .pin_in = pinInit("IN", INPUT),
    //     .pin_out = pinInit("OUT", OUTPUT),
    // };
    // _ = chip;
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

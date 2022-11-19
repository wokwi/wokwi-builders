const std = @import("std");
const wokwi = @import("wokwi_chip_ii.zig");

const Chip = extern struct {
    pin_in: wokwi.PinId,
    pin_out: wokwi.PinId,
};

fn on_pin_change(user_data: ?*anyopaque, _: wokwi.PinId, value: u32) void {
    const chip = @ptrCast(Chip, user_data.?);

    if (value == wokwi.HIGH) {
        wokwi.pinWrite(chip.pin_out, wokwi.LOW);
    } else {
        wokwi.pinWrite(chip.pin_out, wokwi.HIGH);
    }
}

pub export fn chipInit() callconv(.C) void {
    std.debug.print("Hello {s}!\n", .{"Zig"});
    const chip = Chip{
        .pin_in = wokwi.pinInit("IN", wokwi.INPUT),
        .pin_out = wokwi.pinInit("OUT", wokwi.OUTPUT),
    };

    const watch_config = wokwi.WatchConfig{
        .user_data = &chip,
        .edge = wokwi.BOTH,
        .pin_change = &on_pin_change,
    };
    wokwi.pinWatch(chip.pin_in, &watch_config);
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);

    // try commenting this out and see if zig detects the memory leak!
    defer list.deinit();

    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

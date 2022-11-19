const std = @import("std");
const wokwi = @import("wokwi");

const Chip = extern struct {
    pin_in: wokwi.PinId,
    pin_out: wokwi.PinId,
};

fn on_pin_change(user_data: ?*anyopaque, _: wokwi.PinId, value: u32) void {
    var data = user_data.?;
    const chip = @ptrCast(*Chip, @alignCast(4, data));

    if (value == wokwi.HIGH) {
        wokwi.pinWrite(chip.pin_out, wokwi.LOW);
    } else {
        wokwi.pinWrite(chip.pin_out, wokwi.HIGH);
    }
}

export fn chipInit() callconv(.C) void {
    wokwi.debugPrint("Hello Zig!\n");
    var chip = Chip{
        .pin_in = wokwi.pinInit("IN", wokwi.INPUT),
        .pin_out = wokwi.pinInit("OUT", wokwi.OUTPUT),
    };

    comptime var pin_c = on_pin_change;
    var pin_change: ?*anyopaque = @ptrCast(*anyopaque, &pin_c);

    var watch_config = wokwi.WatchConfig{
        .user_data = @as(?*anyopaque, &chip),
        .edge = wokwi.BOTH,
        .pin_change = pin_change,
    };
    _ = wokwi.pinWatch(chip.pin_in, &watch_config);
}

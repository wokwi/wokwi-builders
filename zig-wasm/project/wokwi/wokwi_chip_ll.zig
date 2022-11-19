pub const LOW: u32 = 0;
pub const HIGH: u32 = 1;
pub const INPUT: u32 = 0;
pub const OUTPUT: u32 = 1;
pub const INPUT_PULLUP: u32 = 2;
pub const INPUT_PULLDOWN: u32 = 3;
pub const ANALOG: u32 = 4;
pub const OUTPUT_LOW: u32 = 16;
pub const OUTPUT_HIGH: u32 = 16;
pub const RISING: u32 = 1;
pub const FALLING: u32 = 2;
pub const BOTH: u32 = 3;
pub const PinId = i32;
pub const WatchConfig = extern struct {
    user_data: ?*anyopaque,
    edge: u32,
    pin_change: ?*anyopaque,
};

pub const TimerId = u32;
pub const TimerConfig = extern struct {
    user_data: ?*anyopaque,
    callback: ?*anyopaque,
};

pub const UARTDevId = u32;
pub const UARTConfig = extern struct {
    user_data: ?*anyopaque,
    rx: PinId,
    tx: PinId,
    baud_rate: u32,
    rx_data: ?*anyopaque,
    write_done: ?*anyopaque,
};

pub const I2CDevId = u32;
pub const I2CConfig = extern struct {
    user_data: ?*anyopaque,
    address: u32,
    scl: PinId,
    sda: PinId,
    connect: ?*anyopaque,
    read: ?*anyopaque,
    write: ?*anyopaque,
    disconnect: ?*anyopaque,
};

pub const SPIDevId = u32;
pub const SPIConfig = extern struct {
    user_data: ?*anyopaque,
    sck: PinId,
    mosi: PinId,
    miso: PinId,
    mode: u32,
    done: ?*anyopaque,
};

pub const AttrId = u32;
pub const BufferId = u32;
pub const NO_PIN: PinId = -1;

/// # Safety
///
/// Just a stub to specify the Chip API version.
pub export fn __wokwi_api_version_1() u32 {
    return 1;
}
pub extern fn pinInit(name: [*:0]const u8, mode: u32) PinId;
pub extern fn pinMode(pin: PinId, mode: u32) callconv(.C) void;
pub extern fn pinRead(pin: PinId) u32;
pub extern fn pinWrite(pin: PinId, value: u32) callconv(.C) void;
pub extern fn pinWatch(pin: PinId, watch_config: ?*WatchConfig) bool;
pub extern fn pinWatchStop(pin: PinId) callconv(.C) void;
pub extern fn pinADCRead(pin: PinId) f32;
pub extern fn pinDACWrite(pin: PinId, value: f32) callconv(.C) void;
pub extern fn getSimNanos() f64;
pub extern fn timerInit(timer_config: ?*TimerConfig) TimerId;
pub extern fn timerStart(timer: TimerId, micros: u32, repeat: bool) callconv(.C) void;
pub extern fn timerStartNanos(timer: TimerId, nanos: f64, repeat: bool) callconv(.C) void;
pub extern fn timerStop(timer: TimerId) callconv(.C) void;
pub extern fn uartInit(config: UARTConfig) UARTDevId;
pub extern fn uartWrite(dev: UARTDevId, buffer: [*:0]const u8, count: u32) bool;
pub extern fn i2cInit(config: ?*I2CConfig) I2CDevId;
pub extern fn spiInit(config: ?*SPIConfig) SPIDevId;
pub extern fn spiStart(dev: SPIDevId, buffer: [*:0]const u8, count: u32) callconv(.C) void;
pub extern fn spiStop(dev: SPIDevId) callconv(.C) void;
pub extern fn attrInit(name: [*:0]const u8, default_value: f64) AttrId;
pub extern fn attrRead(attr: AttrId) u32;
pub extern fn attrReadFloat(attr: AttrId) f64;
pub extern fn framebufferInit(width: ?*u32, height: ?*u32) BufferId;
pub extern fn bufferRead(buffer: BufferId, offset: u32, data: [*:0]const u8, data_len: u32) u32;
pub extern fn bufferWrite(buffer: BufferId, offset: u32, data: [*:0]const u8, data_len: u32) u32;
pub extern fn debugPrint(message: [*:0]const u8) callconv(.C) void;

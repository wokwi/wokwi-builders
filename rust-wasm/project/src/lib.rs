use std::{ffi::{c_void, CString}, os::raw::c_char};

// --- API Declaration ---

type PinId = i32;

#[repr(C)]
pub struct WatchConfig {
    user_data: *const c_void,
    edge: u32,
    pin_change: *const c_void,
}

/* Just a stub to specify the Chip API version */
#[no_mangle]
pub unsafe extern "C" fn __wokwi_api_version_1() -> u32 { return 0; }

extern "C" {
    fn pinInit(name: *const c_char, mode: u32) -> PinId;
    fn pinRead(pin: PinId) -> u32;
    fn pinWrite(pin: PinId, value: u32);
    fn pinWatch(pin: PinId, watch_config: *const WatchConfig) -> bool;
    fn debugPrint(message: *const c_char);
}

/* Pin values */
const LOW: u32 = 0;
const HIGH: u32 = 1;

/* Pin modes */
const INPUT: u32 = 0;
const OUTPUT: u32 = 1;
const INPUT_PULLUP: u32 = 2;
const INPUT_PULLDOWN: u32 = 3;
const ANALOG: u32 = 4;
const OUTPUT_LOW: u32 = 16;
const OUTPUT_HIGH: u32 = 16;

/* Pin edges */
const RISING: u32 = 1; 
const FALLING: u32 = 2;
const BOTH: u32 = 3;

/// --- Implementation ---

struct Chip {
    pin_in: PinId,
    pin_out: PinId,
}

pub unsafe fn on_pin_change(user_data: *const c_void, _pin: PinId, value: u32) {
    let chip = &*(user_data as *const Chip); 
    if value == HIGH {
        pinWrite(chip.pin_out, LOW);
    } else {
        pinWrite(chip.pin_out, HIGH);
    }
}

#[no_mangle]
pub unsafe extern "C" fn chipInit() {
    debugPrint(CString::new("Hello rust!").unwrap().into_raw());

    let chip = Chip {
        pin_in: pinInit(CString::new("IN").unwrap().into_raw(), INPUT),
        pin_out: pinInit(CString::new("OUT").unwrap().into_raw(), OUTPUT),
    };

    let watch_config = WatchConfig {
        user_data: &chip as *const _ as *const c_void,
        edge: BOTH,
        pin_change: on_pin_change as *const c_void,
    };
    pinWatch(chip.pin_in, &watch_config);
}

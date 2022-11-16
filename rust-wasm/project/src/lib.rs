use std::ffi::{c_void, CString};

use wokwi_chip_ll::{
    debugPrint, pinInit, pinWatch, pinWrite, PinId, WatchConfig, BOTH, HIGH, INPUT, LOW, OUTPUT,
};

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
    debugPrint(CString::new("Hello rusty!").unwrap().into_raw());

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

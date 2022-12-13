#include <stdio.h>
#include "emscripten.h"
#include "src/wokwi_cxxrtl.h"

namespace wokwi {
#include "src/wokwi-api.h"
}

typedef struct chip_pin_t {
  struct chip_state_t *chip;
  wokwi::pin_t wokwi_pin;
  cxxrtl::debug_item verilog_pin;
  uint8_t bit_index;
  struct chip_pin_t *next;
} chip_pin_t;

typedef struct chip_state_t {
  cxxrtl_design::p_wokwi *design;
  struct chip_pin_t *first_pin;
} chip_state_t;

static void update_input_pin(cxxrtl::debug_item verilog_pin, wokwi::pin_t wokwi_pin, uint8_t bit_index, uint32_t value) {
  if (verilog_pin.width == 1) {
    verilog_pin.next[0] = value;
  } else {
    uint32_t v = verilog_pin.curr[0];
    if (value) {
      v |= (1 << bit_index);
    } else {
      v &= ~(1 << bit_index);
    }
    verilog_pin.next[0] = v;
  }
}

static void update_output_pin(cxxrtl::debug_item verilog_pin, wokwi::pin_t wokwi_pin) {
  if (verilog_pin.width == 1) {
    wokwi::pin_write(wokwi_pin, verilog_pin.curr[0] ? wokwi::HIGH : wokwi::LOW);
  } else {
    for (uint32_t i = 0; i < verilog_pin.width; i++) {
      wokwi::pin_write(wokwi_pin, verilog_pin.curr[i]);
    }
  }
}

static void inline update_output_pins(chip_state_t *chip) {
  for (auto pin = chip->first_pin; pin; pin = pin->next) {
    auto verilog_pin = pin->verilog_pin;
    wokwi::pin_t wokwi_pin = pin->wokwi_pin;
    if (verilog_pin.flags & cxxrtl::debug_item::OUTPUT) {
      update_output_pin(verilog_pin, wokwi_pin);
    }
  }
}

static void chip_input_pin_changed(void *state, wokwi::pin_t pin, uint32_t value) {
  chip_pin_t *ctx = (chip_pin_t *)state;

  update_input_pin(ctx->verilog_pin, pin, ctx->bit_index, value);

  auto design = ctx->chip->design;
  design->step();

  update_output_pins(ctx->chip);
}

static chip_pin_t *create_pin(chip_state_t *chip) {
  chip_pin_t *result = (chip_pin_t *)malloc(sizeof(chip_pin_t));
  result->next = chip->first_pin;
  result->chip = chip;
  chip->first_pin = result;
  return result;
}

extern "C" void chip_init(void) {
  chip_state_t *chip = (chip_state_t *)malloc(sizeof(chip_state_t));
  chip->design = new cxxrtl_design::p_wokwi();
  chip->first_pin = NULL;

  printf("Verilog chip started\n");

  cxxrtl::debug_items items;
  chip->design->debug_info(items);

  for(auto &it : items.table) {
    for(auto &part : it.second) {
      const char *name = it.first.c_str();
      if (part.flags & cxxrtl::debug_item::INPUT) {
        chip_pin_t *pin = create_pin(chip);
        pin->wokwi_pin = wokwi::pin_init(name, wokwi::INPUT);
        pin->verilog_pin = part;
        
        const wokwi::pin_watch_config_t config = {
          .user_data = pin,
          .edge = wokwi::BOTH,
          .pin_change = chip_input_pin_changed,
        };
        uint32_t value = wokwi::pin_read(pin->wokwi_pin);
        update_input_pin(part, pin->wokwi_pin, 0, value);
        wokwi::pin_watch(pin->wokwi_pin, &config);
      } else if (part.flags & cxxrtl::debug_item::OUTPUT) {
        chip_pin_t *pin = create_pin(chip);
        pin->wokwi_pin = wokwi::pin_init(name, wokwi::OUTPUT);
        pin->verilog_pin = part;
      } else if (part.flags & CXXRTL_DRIVEN_COMB && part.type == CXXRTL_VALUE ) { // Constant pin
        wokwi::pin_t pin = wokwi::pin_init(name, wokwi::OUTPUT);
        update_output_pin(part, pin);
      }
    }
  }

  chip->design->step();
  update_output_pins(chip);
}

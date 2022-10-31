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

static void chip_input_pin_changed(void *state, wokwi::pin_t pin, uint32_t value) {
  chip_pin_t *ctx = (chip_pin_t *)state;
  auto design = ctx->chip->design;
  if (ctx->verilog_pin.width == 1) {
    ctx->verilog_pin.next[0] = value;
  } else {
    uint32_t v = ctx->verilog_pin.curr[0];
    if (value) {
      v |= (1 << ctx->bit_index);
    } else {
      v &= ~(1 << ctx->bit_index);
    }
    ctx->verilog_pin.next[0] = v;
  }
  design->step();

  for (auto pin = ctx->chip->first_pin; pin; pin = pin->next) {
    auto verilog_pin = pin->verilog_pin;
    wokwi::pin_t wokwi_pin = pin->wokwi_pin;
    if (verilog_pin.flags & cxxrtl::debug_item::OUTPUT) {
      if (verilog_pin.width == 1) {
        wokwi::pin_write(wokwi_pin, verilog_pin.curr[0] ? wokwi::HIGH : wokwi::LOW);
      } else {
        for (uint32_t i = 0; i < verilog_pin.width; i++) {
          wokwi::pin_write(wokwi_pin, verilog_pin.curr[i]);
        }
      }
    }
  }
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

  setvbuf(stdout, NULL, _IOLBF, 1024); // Limit output buffering to a single line
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
        wokwi::pin_watch(pin->wokwi_pin, &config);
      } else if (part.flags & cxxrtl::debug_item::OUTPUT) {
        chip_pin_t *pin = create_pin(chip);
        pin->wokwi_pin = wokwi::pin_init(name, wokwi::OUTPUT);
        pin->verilog_pin = part;
      }
    }
  }
}

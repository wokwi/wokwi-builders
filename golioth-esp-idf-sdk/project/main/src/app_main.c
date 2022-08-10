#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include <stdio.h>

void app_main() {
  printf("I'm just a stub\n");
  while (1) {
    vTaskDelay(portMAX_DELAY);
  }
}
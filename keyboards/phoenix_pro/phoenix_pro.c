#include <hal.h>
#include "usb_main.h"
#include "phoenix_pro.h"
#include "print.h"

static inline void init_led(void) {
    palSetPadMode(GPIOB, 13, PAL_MODE_OUTPUT_PUSHPULL);
    palSetPadMode(GPIOB, 12, PAL_MODE_OUTPUT_PUSHPULL);
    palSetPadMode(GPIOB, 11, PAL_MODE_OUTPUT_PUSHPULL);
}

void bootloader_jump(void) {
    *(volatile uint32_t*)0x20004000 = BOOTLOADER_MAGIC;
    NVIC_SystemReset();
}

void bootmagic_lite(void) {
    matrix_scan();
    wait_ms(DEBOUNCE);
    matrix_scan();

    if ((matrix_get_row(0) & 1) || (matrix_get_row(5) & 1)) {
        bootloader_jump();
    }
}

bool is_keyboard_master(void) {
    palSetPadMode(GPIOC, 13, PAL_MODE_INPUT_PULLDOWN);
    return palReadPad(GPIOC, 13) == PAL_HIGH;
}

void keyboard_pre_init_kb(void) {
    init_led();
    led1_off();
    led2_off();

    keyboard_pre_init_user();
}

void keyboard_post_init_kb(void) {
    led1_on();
    wait_ms(50);
    led2_on();
    wait_ms(300);

    led1_off();
    wait_ms(50);
    led2_off();

    keyboard_post_init_user();
}

inline void manipulate_led(uint32_t led, bool on) {
    switch (led) {
        case 1:
            on ? led1_on() : led1_off();
        case 2:
            on ? led2_on() : led2_off();
    }
};

// TODO
__attribute__((weak)) layer_state_t layer_state_set_kb(layer_state_t state) {
    state = layer_state_set_user(state);

    uint8_t layer = get_highest_layer(state);
    manipulate_led(1, layer & 1);
    manipulate_led(2, layer >> 1 & 1);
    return state;
}

__attribute__((weak)) const keypos_t PROGMEM hand_swap_config[MATRIX_ROWS][MATRIX_COLS] = {
    { { 0, 5 }, { 1, 5 }, { 2, 5 }, { 3, 5 }, { 4, 5 }, { 5, 5 }, { 6, 5 } },
    { { 0, 6 }, { 1, 6 }, { 2, 6 }, { 3, 6 }, { 4, 6 }, { 5, 6 }, { 6, 6 } },
    { { 0, 7 }, { 1, 7 }, { 2, 7 }, { 3, 7 }, { 4, 7 }, { 5, 7 }, { 6, 7 } },
    { { 0, 8 }, { 1, 8 }, { 2, 8 }, { 3, 8 }, { 4, 8 }, { 5, 8 }, { 6, 8 } },
    { { 0, 9 }, { 1, 9 }, { 2, 9 }, { 3, 9 }, { 4, 9 }, { 5, 9 }, { 6, 9 } },
    { { 0, 0 }, { 1, 0 }, { 2, 0 }, { 3, 0 }, { 4, 0 }, { 5, 0 }, { 6, 0 } },
    { { 0, 1 }, { 1, 1 }, { 2, 1 }, { 3, 1 }, { 4, 1 }, { 5, 1 }, { 6, 1 } },
    { { 0, 2 }, { 1, 2 }, { 2, 2 }, { 3, 2 }, { 4, 2 }, { 5, 2 }, { 6, 2 } },
    { { 0, 3 }, { 1, 3 }, { 2, 3 }, { 3, 3 }, { 4, 3 }, { 5, 3 }, { 6, 3 } },
    { { 0, 4 }, { 1, 4 }, { 2, 4 }, { 3, 4 }, { 4, 4 }, { 5, 4 }, { 6, 4 } },
};

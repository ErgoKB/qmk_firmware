
/* Copyright 2019
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#pragma once

#include "config_common.h"

/* USB Device descriptor parameter */
#define VENDOR_ID       0x1209
#define PRODUCT_ID      0x2304
#define DEVICE_VER      0x0001
#define MANUFACTURER    ErgoKB
#define PRODUCT         Phoenix-v2

/* key matrix size */
#define MATRIX_ROWS 10
#define MATRIX_COLS 7

#define MOUSEKEY_INTERVAL    10
#define MOUSEKEY_DELAY       0
#define MOUSEKEY_TIME_TO_MAX 60
#define MOUSEKEY_MAX_SPEED   7
#define MOUSEKEY_WHEEL_DELAY 0

#define DIODE_DIRECTION ROW2COL

/* Locking resynchronize hack */
#define LOCKING_RESYNC_ENABLE

#define MATRIX_ROW_PINS { B14, B13, B12, B1, B0 }
#define MATRIX_COL_PINS { B15, C6, C7, C8, C9, A8, B9 }

#define HAL_USE_SERIAL TRUE
#define SPLIT_HAND_PIN A5
#define SOFT_SERIAL_PIN A9
#define SERIAL_USART_DRIVER SD1
#define SERIAL_USART_TX_PAL_MODE 7
#define SWAP_HANDS_ENABLE
#define IGNORE_MOD_TAP_INTERRUPT
#define PERMISSIVE_HOLD
#define GPIO_INPUT_PIN_DELAY (STM32_SYSCLK / 100000000L / 4)

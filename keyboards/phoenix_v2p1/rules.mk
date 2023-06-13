# MCU name
MCU = STM32F103

# Bootloader selection
BOOTLOADER = custom

BOARD = STM32_F103_STM32DUINO

# Linker script to use
# - it should exist either in <chibios>/os/common/ports/ARMCMx/compilers/GCC/ld/
#   or <this_dir>/ld/
MCU_LDSCRIPT = uf2boot

# Build Options
#   change yes to no to disable
#
BOOTMAGIC_ENABLE = yes     # Virtual DIP switch configuration
MOUSEKEY_ENABLE = yes       # Mouse keys
EXTRAKEY_ENABLE = yes       # Audio control and System control
CONSOLE_ENABLE = no         # Console for debug
SPLIT_KEYBOARD = yes
SERIAL_DRIVER = usart
DEBOUNCE_TYPE = sym_defer_pk

OPT_DEFS += -DCORTEX_ENABLE_WFI_IDLE=TRUE

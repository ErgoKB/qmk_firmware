#!/bin/bash
set -e

green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
cyan=$(tput setaf 6)
normal=$(tput sgr0)

function _run_deferred() {
  local _depth="$BASHPID.${#FUNCNAME[@]}"
  [[ "$_depth" != "$_deferred_depth" ]] && return
  local opt=$-
  set +e
  for (( i=${#_deferred[@]} - 1; i >= 0; i-- )); do
    eval "${_deferred[i]}"
  done
  [[ "$opt" == *e* ]] && set -e
}

function _defer() {
  _deferred_depth="$BASHPID.${#FUNCNAME[@]}"
  _deferred+=( "$(printf '%q ' "$@")" )
}

# This has to be an alias so that the `trap ... RETURN` runs appropriately.
shopt -s expand_aliases
alias defer='declare -a _deferred; declare _deferred_depth; trap _run_deferred EXIT RETURN; _defer'

function apply_date_patch() {
    printf "${cyan}patching date${normal}\n"
    cat <<EOF | git apply > /dev/null
diff --git a/lib/python/qmk/commands.py b/lib/python/qmk/commands.py
index 421453d837..b9a37170b8 100644
--- a/lib/python/qmk/commands.py
+++ b/lib/python/qmk/commands.py
@@ -136,7 +136,7 @@ def create_version_h(skip_git=False, skip_all=False):
     if skip_all:
         current_time = "1970-01-01-00:00:00"
     else:
-        current_time = strftime(time_fmt)
+        current_time = "2021-09-01-00:00:00"
 
     if skip_git:
         git_version = "NA"
EOF
}

function cleanup_date_patch() {
    printf "${cyan}cleaning date patch${normal}\n"
    git checkout -- lib/python/qmk/commands.py > /dev/null
}

function patch_phoenix_v1_led_init() {
    printf "${cyan}patching v1 led setting${normal}\n"
    cat <<EOF | git apply > /dev/null
diff --git a/platforms/chibios/boards/BLACKPILL_STM32_F401/configs/board.h b/platforms/chibios/boards/BLACKPILL_STM32_F401/configs/board.h
index 421453d837..b9a37170b8 100644
--- a/platforms/chibios/boards/BLACKPILL_STM32_F401/configs/board.h
+++ b/platforms/chibios/boards/BLACKPILL_STM32_F401/configs/board.h
@@ -18,3 +18,9 @@
 #include_next "board.h"
 
 #undef STM32_HSE_BYPASS
+#undef VAL_GPIOB_MODER
+#undef VAL_GPIOB_ODR
+
+#define VAL_GPIOB_MODER (PIN_MODE_OUTPUT(8U) | PIN_MODE_OUTPUT(5U) | PIN_MODE_OUTPUT(6U))
+
+#define VAL_GPIOB_ODR (PIN_ODR_LOW(8U) | PIN_ODR_LOW(5U) | PIN_ODR_LOW(6U))
EOF
}

function cleanup_phoenix_v1_led_init_patch() {
    printf "${cyan}cleaning v1 led setting patch${normal}\n"
    git checkout -- platforms/chibios/boards/BLACKPILL_STM32_F401/configs/board.h >> /dev/null
}

function build_phoenix_v1() {
    printf "${blue}build phoenix v1 firmware${normal}\n"
    defer echo ""
    patch_phoenix_v1_led_init
    defer cleanup_phoenix_v1_led_init_patch
    printf "\t${yellow}compiling phoenix v1 remap firmware...${normal}"
    make -j phoenix:remap > /dev/null
    mv phoenix_remap.bin firmware_releases
    printf " ${green}Done${normal}\n"
}

function patch_phoenix_v2_led_init() {
    printf "${cyan}patching v2 led setting${normal}\n"
    cat <<EOF | git apply > /dev/null
diff --git a/platforms/chibios/boards/BLACKPILL_STM32_F401/configs/board.h b/platforms/chibios/boards/BLACKPILL_STM32_F401/configs/board.h
index 421453d837..b9a37170b8 100644
--- a/platforms/chibios/boards/BLACKPILL_STM32_F401/configs/board.h
+++ b/platforms/chibios/boards/BLACKPILL_STM32_F401/configs/board.h
@@ -18,3 +18,9 @@
 #include_next "board.h"

 #undef STM32_HSE_BYPASS
+#undef VAL_GPIOA_MODER
+#undef VAL_GPIOA_ODR
+
+#define VAL_GPIOA_MODER (PIN_MODE_OUTPUT(GPIOA_BUTTON) | PIN_MODE_OUTPUT(GPIOA_PIN1) | PIN_MODE_OUTPUT(GPIOA_PIN2) | PIN_MODE_OUTPUT(GPIOA_CS43L22_LRCK) | PIN_MODE_ALTERNATE(GPIOA_OTG_FS_DM) | PIN_MODE_ALTERNATE(GPIOA_OTG_FS_DP))
+
+#define VAL_GPIOA_ODR (PIN_ODR_LOW(GPIOA_BUTTON) | PIN_ODR_LOW(GPIOA_PIN1) | PIN_ODR_LOW(GPIOA_PIN2) | PIN_ODR_LOW(GPIOA_CS43L22_LRCK) | PIN_ODR_HIGH(GPIOA_OTG_FS_DM) | PIN_ODR_HIGH(GPIOA_OTG_FS_DP))
EOF
}

function cleanup_phoenix_v2_led_init_patch() {
    printf "${cyan}cleaning v2 led setting${normal}\n"
    git checkout -- platforms/chibios/boards/BLACKPILL_STM32_F401/configs/board.h >> /dev/null
}

function build_phoenix_v2() {
    printf "${blue}build phoenix v2 firmwares${normal}\n"
    defer echo ""
    patch_phoenix_v2_led_init
    defer cleanup_phoenix_v2_led_init_patch
    printf "\t${yellow}compiling phoenix v2 basic firmware...${normal}"
    make -j phoenix_v2:basic > /dev/null
    mv phoenix_v2_basic.bin firmware_releases
    printf " ${green}Done${normal}\n"
    printf "\t${yellow}compiling phoenix v2 advanced firmware...${normal}"
    make -j phoenix_v2:advanced > /dev/null
    mv phoenix_v2_advanced.bin firmware_releases
    printf " ${green}Done${normal}\n"
}

function build() {
    mkdir -p firmware_releases
    apply_date_patch
    defer cleanup_date_patch
    build_phoenix_v1
    build_phoenix_v2
}

build

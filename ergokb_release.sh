#!/bin/bash
set -e

green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
cyan=$(tput setaf 6)
normal=$(tput sgr0)

RELEASE_PATH="firmware_releases"
function build_phoenix_v1() {
    printf "${blue}build phoenix v1 firmware${normal}\n"
    printf "\t${yellow}compiling phoenix v1 remap firmware...${normal}"
    make -j phoenix:remap > /dev/null
    mv phoenix_remap.bin firmware_releases
    printf " ${green}Done${normal}\n"
    echo ""
}

function build_phoenix_v2() {
    printf "${blue}build phoenix v2 firmwares${normal}\n"
    printf "\t${yellow}compiling phoenix v2 basic firmware...${normal}"
    make -j phoenix_v2:basic > /dev/null
    mv phoenix_v2_basic.bin firmware_releases
    printf " ${green}Done${normal}\n"
    printf "\t${yellow}compiling phoenix v2 advanced firmware...${normal}"
    make -j phoenix_v2:advanced > /dev/null
    mv phoenix_v2_advanced.bin firmware_releases
    printf " ${green}Done${normal}\n"
    echo ""
}

function build_phoenix_v2p1() {
    kb_prefix="phoenix_v2p1"

    printf "\t${yellow}compiling phoenix v2p1 basic firmware...${normal}"
    make -j ${kb_prefix}:basic > /dev/null
    util/uf2conv.py -b 0x800400  -c ${kb_prefix}_basic.bin -o ${RELEASE_PATH}/${kb_prefix}_basic.uf2 > /dev/null
    rm ${kb_prefix}_basic.bin
    printf " ${green}Done${normal}\n"

    printf "\t${yellow}compiling phoenix v2p1 advanced firmware...${normal}"
    make -j ${kb_prefix}:advanced > /dev/null
    util/uf2conv.py -b 0x800400  -c ${kb_prefix}_advanced.bin -o ${RELEASE_PATH}/${kb_prefix}_advanced.uf2 > /dev/null
    rm ${kb_prefix}_advanced.bin
    printf " ${green}Done${normal}\n"
}

function build() {
    mkdir -p "${RELEASE_PATH}"
    build_phoenix_v1
    build_phoenix_v2
    build_phoenix_v2p1
}

build

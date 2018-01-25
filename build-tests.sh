#! /bin/bash
#
# Script to build RISC-V tests

. build.common

build_project riscv-tests --prefix=$RISCV/riscv64-unknown-elf

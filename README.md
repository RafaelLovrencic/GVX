# GVX
A minimal x86_64 operating system written from scratch in C and Assembly, built to run on QEMU.

# Prerequisites

* the GNU Assembler
* qemu x86_64 emulator

## Bootloader

The GVX bootloader is written in x86 Assembly using the AT&T syntax and assembled using the GNU Assembler.

#### Building the bootloader:
1. ```cd ./bootloader/```
2. ```make```

#### Running the bootloader:
1. ```make run```

Alternatively, use the commands provided in the Makefile default target and then the run target.

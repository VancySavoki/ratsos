#!/bin/bash

NASM=nasm
mkdir build
$NASM -f bin -o build/ratsos.img boot/boot.asm


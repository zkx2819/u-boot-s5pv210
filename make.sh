#!/bin/sh
start=$(date)
make s5pv210_defconfig
make -j8
echo "$start---->`date`"

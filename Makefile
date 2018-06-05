osname := $(shell uname -s)

#use Android toolchain on OS X
#use linaro bare metal toolchain on linux
ifeq ($(osname), Darwin)
CROSS_PREFIX=aarch64-linux-android-
else
CROSS_PREFIX=aarch64-linux-gnu-
endif

all: test64.elf

serial.o: serial.c
	$(CROSS_PREFIX)gcc -c -g $< -o $@

test64.o: test64.c
	$(CROSS_PREFIX)gcc -c -g $< -o $@

startup64.o: startup64.s
	$(CROSS_PREFIX)as -c -g $< -o $@

test64.elf: test64.o startup64.o serial.o
	$(CROSS_PREFIX)ld -Ttest64.ld $^ -o $@

test64.bin: test64.elf
	$(CROSS_PREFIX)objcopy -O binary $< $@

clean:
	rm -f test65.bin test64.elf startup64.o test64.o serial.o

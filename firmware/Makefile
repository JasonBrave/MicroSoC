.PHONY: all
all:
	riscv32-elf-as fwboot.S -o fwboot.o -march=rv32im -mabi=ilp32
	riscv32-elf-gcc -c fwmain.c -o fwmain.o -O2 -U__STDC_HOSTED__ -march=rv32im -mabi=ilp32
	riscv32-elf-ld -T fw.ld fwboot.o fwmain.o -o fw.elf
	riscv32-elf-objcopy -O binary --only-section=.text fw.elf fw.bin
	../tools/romgen/romgen > bootrom.sv

.PHONY: clean
clean:
	rm bootrom.sv *.o *.elf *.bin

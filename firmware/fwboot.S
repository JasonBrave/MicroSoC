.global _start
.section .text.start, "ax", @progbits

.skip 0x80, 0x0

_start:
	li a1, 0x1000
	li a2, 0x2000
	lb a0, 0(a1)
_loop:
	sb a0, 4(a1)
	sw a0, 8(a2)
	addi a0,a0,1
	j _loop

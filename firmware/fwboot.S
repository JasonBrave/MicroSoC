.global _start
.section .text.start, "ax", @progbits

.skip 0x80, 0x0

_start:
	mv a0, x0
	li a1, 0x1000
	mv a2, x0
_loop:
	sb a0, 4(a1)
	addi a0,a0,1
	j _loop

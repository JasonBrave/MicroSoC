.global _start
.section .text.start, "ax", @progbits

.skip 0x80, 0x0

_start:
	mv a0,x0
	mv a1,x0
	li a2,1
	mv a3,x0
	li a4,100
_loop:
	add a1,a1,a2
	add a0,a0,a1
	addi a3,a3,1
	bgtu a4,a3,_loop
_csrtest:
	csrr a0,mvendorid
	csrr a1,marchid
	csrr a2,mimpid
	csrr a3,mhartid
	csrr a4,mconfigptr
_end:
	j _end

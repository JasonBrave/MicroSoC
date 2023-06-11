#include <stdint.h>

#define CYCLE_PER_US 50 // freq / 1E6

struct GPIORegs {
	volatile uint32_t gpio_in;
	volatile uint32_t gpio_out;
} *const gpio_regs = (struct GPIORegs *)0x20000;

struct Timer32Regs {
	volatile uint32_t counter;
	volatile uint32_t reset;
} *const timer32_regs = (struct Timer32Regs *)0x21000;

void wait(unsigned int us) {
	unsigned int target = us * CYCLE_PER_US;
	timer32_regs->reset = 1;
	for (;;) {
		if (timer32_regs->counter >= target) {
			return;
		}
	}
}

void fwmain(void) {
	unsigned int out = 0;
	for (;;) {
		wait(10);
		out++;
		gpio_regs->gpio_out = out;
	}
}

#include "Vmicrosoc_top.h"
#include "verilated.h"
#include <iomanip>
#include <iostream>
#include <ostream>

int main() {
	Verilated::traceEverOn(true);

	Vmicrosoc_top microsoc;
	microsoc.rst = 1;
	microsoc.clk = 0;
	microsoc.eval();
	Verilated::timeInc(1);
	microsoc.clk = 1;
	microsoc.eval();
	Verilated::timeInc(1);
	microsoc.rst = 0;
	for (int i = 0; i < 5; i++) {
		microsoc.clk = 0;
		microsoc.eval();
		Verilated::timeInc(1);
		microsoc.clk = 1;
		microsoc.eval();
		Verilated::timeInc(1);
	}
	microsoc.rst = 1;
	for (volatile unsigned long long t = 0; t < 2000; t++) {
		microsoc.clk = 0;
		microsoc.eval();
		Verilated::timeInc(1);
		microsoc.clk = 1;
		microsoc.eval();
		Verilated::timeInc(1);
		std::cout << std::hex << std::setfill('0') << std::setw(2)
				  << (int)microsoc.debugport << std::endl;
	}
}

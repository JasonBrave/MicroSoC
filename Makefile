SV_INC = -Ivendor/ibex/vendor/picorv32
SV_SRC = rtl/microsoc_top.sv rtl/processor_block/processor_block.sv rtl/processor_block/riscv_core_wrapper.sv firmware/bootrom.sv rtl/processor_block/debugport_controller.sv vendor/picorv32/picorv32.v
VERILATOR_ARGS = -Wno-UNUSEDPARAM -Wno-PINCONNECTEMPTY -Wno-PINMISSING -Wno-UNUSEDSIGNAL
TB_SRC = tb/verilator/main.cpp
VERILATOR = verilator

all: obj_dir/Vmicrosoc_top

obj_dir/Vmicrosoc_top:
	$(VERILATOR) -Wall -Wno-TIMESCALEMOD -Wno-DECLFILENAME --cc --exe --clk clk --top microsoc_top --trace --build $(VERILATOR_ARGS) $(TB_SRC) $(SV_INC) $(SV_SRC)

sim: obj_dir/Vmicrosoc_top
	./obj_dir/Vmicrosoc_top

clean:
	rm -rf obj_dir

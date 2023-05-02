SV_INC = -Ivendor/ibex/vendor/lowrisc_ip/ip/prim/rtl/ -Ivendor/ibex/vendor/lowrisc_ip/dv/sv/dv_utils/ -Ivendor/ibex/vendor/lowrisc_ip/ip/prim_generic/rtl/ -Ivendor/ibex/rtl -Ivendor/ibex/dv/uvm/core_ibex/common/prim/
SV_SRC = vendor/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_ram_1p_pkg.sv vendor/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_secded_pkg.sv vendor/ibex/rtl/ibex_pkg.sv vendor/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_util_pkg.sv vendor/ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_cipher_pkg.sv vendor/ibex/dv/uvm/core_ibex/common/prim/prim_pkg.sv rtl/microsoc_top.sv rtl/processor_block/processor_block.sv rtl/processor_block/riscv_core_wrapper.sv firmware/bootrom.sv
VERILATOR_ARGS = -Wno-UNUSEDPARAM -Wno-PINCONNECTEMPTY -Wno-PINMISSING -Wno-UNUSEDSIGNAL
TB_SRC = tb/verilator/main.cpp
VERILATOR = verilator

all: obj_dir/Vmicrosoc_top

obj_dir/Vmicrosoc_top:
	$(VERILATOR) -Wall --cc --exe --clk clk --top microsoc_top --trace --build $(VERILATOR_ARGS) $(TB_SRC) $(SV_INC) $(SV_SRC)

sim: obj_dir/Vmicrosoc_top
	./obj_dir/Vmicrosoc_top

clean:
	rm -rf obj_dir

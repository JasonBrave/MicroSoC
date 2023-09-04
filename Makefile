VERILATOR_ARGS = -Wno-UNUSEDPARAM -Wno-PINCONNECTEMPTY -Wno-PINMISSING -Wno-UNUSEDSIGNAL --trace-max-array 10000
TB_SRC = tb/verilator/main.cpp
VERILATOR = verilator

all: obj_dir/Vmicrosoc_top

obj_dir/Vmicrosoc_top:
	$(VERILATOR) -Wall -Wno-TIMESCALEMOD -Wno-DECLFILENAME --cc --exe --top microsoc_top --trace --build $(VERILATOR_ARGS) $(TB_SRC) -f source.f

sim: obj_dir/Vmicrosoc_top
	./obj_dir/Vmicrosoc_top

clean:
	rm -rf obj_dir

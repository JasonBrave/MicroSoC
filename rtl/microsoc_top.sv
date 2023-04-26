module microsoc_top(input logic		   clk,
					input logic		   rst,
					output logic	   debugport_en,
					output logic [7:0] debugport);

	logic                         instr_req;
	logic						  instr_gnt;
	logic						  instr_rvalid;
	logic [31:0]				  instr_addr;
	logic [31:0]				  instr_rdata;
	logic [6:0]					  instr_rdata_intg;
	logic						  instr_err;
	
	ibex_top #(
			   .PMPEnable        ( 0                                ),
			   .PMPGranularity   ( 0                                ),
			   .PMPNumRegions    ( 4                                ),
			   .MHPMCounterNum   ( 0                                ),
			   .MHPMCounterWidth ( 40                               ),
			   .RV32E            ( 0                                ),
			   .RV32M            ( ibex_pkg::RV32MFast              ),
			   .RV32B            ( ibex_pkg::RV32BNone              ),
			   .RegFile          ( ibex_pkg::RegFileFF              ),
			   .ICache           ( 0                                ),
			   .ICacheECC        ( 0                                ),
			   .ICacheScramble   ( 0                                ),
			   .BranchPredictor  ( 0                                ),
			   .SecureIbex       ( 0                                ),
			   .RndCnstLfsrSeed  ( ibex_pkg::RndCnstLfsrSeedDefault ),
			   .RndCnstLfsrPerm  ( ibex_pkg::RndCnstLfsrPermDefault ),
			   .DbgTriggerEn     ( 0                                ),
			   .DmHaltAddr       ( 32'h1A110800                     ),
			   .DmExceptionAddr  ( 32'h1A110808                     )
			   ) u_top (
						// Clock and reset
						.clk_i                  (clk),
						.rst_ni                 (rst),
						.test_en_i              (),
						.scan_rst_ni            (),
						.ram_cfg_i              (),

						// Configuration
						.hart_id_i              (),
						.boot_addr_i            (32'h00000000),

						// Instruction memory interface
						.instr_req_o            (instr_req),
						.instr_gnt_i            (instr_gnt),
						.instr_rvalid_i         (instr_rvalid),
						.instr_addr_o           (instr_addr),
						.instr_rdata_i          (instr_rdata),
						.instr_rdata_intg_i     (instr_rdata_intg),
						.instr_err_i            (instr_err),

						// Data memory interface
						.data_req_o             (),
						.data_gnt_i             (),
						.data_rvalid_i          (),
						.data_we_o              (),
						.data_be_o              (),
						.data_addr_o            (),
						.data_wdata_o           (),
						.data_wdata_intg_o      (),
						.data_rdata_i           (),
						.data_rdata_intg_i      (),
						.data_err_i             (),

						// Interrupt inputs
						.irq_software_i         (),
						.irq_timer_i            (),
						.irq_external_i         (),
						.irq_fast_i             (),
						.irq_nm_i               (),

						// Debug interface
						.debug_req_i            (),
						.crash_dump_o           (),

						// Special control signals
						.fetch_enable_i         (4'b0101),
						.alert_minor_o          (),
						.alert_major_internal_o (),
						.alert_major_bus_o      (),
						.core_sleep_o           ()
						);

	bootrom rom_inst(
					 .clk(clk),
					 .rst(rst),
					 .instr_req_i(instr_req),
					 .instr_gnt_o(instr_gnt),
					 .instr_rvalid_o(instr_rvalid),
					 .instr_addr_i(instr_addr),
					 .instr_rdata_o(instr_rdata),
					 .instr_rdata_intg_o(instr_rdata_intg),
					 .instr_err_o(instr_err)
					 );

	always_comb begin
		debugport_en = 1'b0;
		debugport = 8'h00;
	end
	
	initial begin
		$dumpfile("wave.vcd");
		$dumpvars(0,microsoc_top);
	end

endmodule // minisoc

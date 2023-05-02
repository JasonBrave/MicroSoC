module riscv_core_wrapper(input logic		  clk,
						  input logic		  rst,
						  output logic		  instr_req_o,
						  input logic		  instr_gnt_i,
						  input logic		  instr_rvalid_i,
						  output logic [31:0] instr_addr_o,
						  input logic [31:0]  instr_rdata_i,
						  input logic [6:0]	  instr_rdata_intg_i,
						  input logic		  instr_err_i);

	ibex_top u_ibex_top (
						 // Clock and reset
						 .clk_i                  (clk),
						 .rst_ni                 (rst),
						 .test_en_i              (1'b0),
						 .scan_rst_ni            (1'b0),
						 .ram_cfg_i              (),

						 // Configuration
						 .hart_id_i              (32'h00000001),
						 .boot_addr_i            (32'h00000000),

						 // Instruction memory interface
						 .instr_req_o            (instr_req_o),
						 .instr_gnt_i            (instr_gnt_i),
						 .instr_rvalid_i         (instr_rvalid_i),
						 .instr_addr_o           (instr_addr_o),
						 .instr_rdata_i          (instr_rdata_i),
						 .instr_rdata_intg_i     (instr_rdata_intg_i),
						 .instr_err_i            (instr_err_i),

						 // Data memory interface
						 .data_req_o             (),
						 .data_gnt_i             (1'b0),
						 .data_rvalid_i          (1'b0),
						 .data_we_o              (),
						 .data_be_o              (),
						 .data_addr_o            (),
						 .data_wdata_o           (),
						 .data_wdata_intg_o      (),
						 .data_rdata_i           (32'h00000000),
						 .data_rdata_intg_i      (7'b0000000),
						 .data_err_i             (1'b0),

						 // Interrupt inputs
						 .irq_software_i         (1'b0),
						 .irq_timer_i            (1'b0),
						 .irq_external_i         (1'b0),
						 .irq_fast_i             (15'b000000000000000),
						 .irq_nm_i               (1'b0),

						 // Debug interface
						 .debug_req_i            (1'b0),
						 .crash_dump_o           (),

						 // Special control signals
						 .fetch_enable_i         (4'b0101),
						 .alert_minor_o          (),
						 .alert_major_internal_o (),
						 .alert_major_bus_o      (),
						 .core_sleep_o           ()
						 );
	
endmodule // riscv_core_wrapper

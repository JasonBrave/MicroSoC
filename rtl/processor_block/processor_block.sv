module processor_block(input logic clk,
					   input logic rst
					   /*AUTOARG*/);

	logic                         instr_req;
	logic						  instr_gnt;
	logic						  instr_rvalid;
	logic [31:0]				  instr_addr;
	logic [31:0]				  instr_rdata;
	logic [6:0]					  instr_rdata_intg;
	logic						  instr_err;

	riscv_core_wrapper u_riscv_core_wrapper(/*AUTOINST*/
											// Outputs
											.instr_req_o		(instr_req),
											.instr_addr_o		(instr_addr[31:0]),
											// Inputs
											.clk				(clk),
											.rst				(rst),
											.instr_gnt_i		(instr_gnt),
											.instr_rvalid_i		(instr_rvalid),
											.instr_rdata_i		(instr_rdata[31:0]),
											.instr_rdata_intg_i	(instr_rdata_intg[6:0]),
											.instr_err_i		(instr_err));
	
	bootrom u_bootrom(/*AUTOINST*/
					  // Outputs
					  .instr_gnt_o		(instr_gnt),
					  .instr_rvalid_o	(instr_rvalid),
					  .instr_rdata_o	(instr_rdata[31:0]),
					  .instr_rdata_intg_o(instr_rdata_intg[6:0]),
					  .instr_err_o		(instr_err),
					  // Inputs
					  .clk				(clk),
					  .rst				(rst),
					  .instr_req_i		(instr_req),
					  .instr_addr_i		(instr_addr[31:0]));
	
endmodule // processor_block

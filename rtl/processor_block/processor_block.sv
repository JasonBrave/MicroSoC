module processor_block(input logic		   clk,
					   input logic		   rst,
					   // Data memory interface
					   output logic		   data_req_o,
					   input logic		   data_gnt_i,
					   input logic		   data_rvalid_i,
					   output logic		   data_we_o,
					   output logic [3:0]  data_be_o,
					   output logic [31:0] data_addr_o,
					   output logic [31:0] data_wdata_o,
					   input logic [31:0]  data_rdata_i,
					   input logic		   data_err_i);

	logic                         instr_req;
	logic						  instr_gnt;
	logic						  instr_rvalid;
	logic [31:0]				  instr_addr;
	logic [31:0]				  instr_rdata;
	logic						  instr_err;
	
	riscv_core_wrapper u_riscv_core_wrapper(/*AUTOINST*/
											// Outputs
											.instr_req_o		(instr_req),
											.instr_addr_o		(instr_addr[31:0]),
											.data_req_o			(data_req_o),
											.data_we_o			(data_we_o),
											.data_be_o			(data_be_o[3:0]),
											.data_addr_o		(data_addr_o[31:0]),
											.data_wdata_o		(data_wdata_o[31:0]),
											// Inputs
											.clk				(clk),
											.rst				(rst),
											.instr_gnt_i		(instr_gnt),
											.instr_rvalid_i		(instr_rvalid),
											.instr_rdata_i		(instr_rdata[31:0]),
											.instr_err_i		(instr_err),
											.data_gnt_i			(data_gnt_i),
											.data_rvalid_i		(data_rvalid_i),
											.data_rdata_i		(data_rdata_i[31:0]),
											.data_err_i			(data_err_i));
	
	bootrom u_bootrom(/*AUTOINST*/
					  // Outputs
					  .instr_gnt_o		(instr_gnt),
					  .instr_rvalid_o	(instr_rvalid),
					  .instr_rdata_o	(instr_rdata[31:0]),
					  .instr_err_o		(instr_err),
					  // Inputs
					  .clk				(clk),
					  .rst				(rst),
					  .instr_req_i		(instr_req),
					  .instr_addr_i		(instr_addr[31:0]));
	
endmodule // processor_block

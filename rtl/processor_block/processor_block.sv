module processor_block(input logic		  clk,
					   input logic		  rst,
					   output logic [7:0] debugport
					   /*AUTOARG*/);

	logic                         instr_req;
	logic						  instr_gnt;
	logic						  instr_rvalid;
	logic [31:0]				  instr_addr;
	logic [31:0]				  instr_rdata;
	logic						  instr_err;

	logic						  data_req;
	logic						  data_gnt;
	logic						  data_rvalid;
	logic						  data_we;
	logic [3:0]					  data_be;
	logic [31:0]				  data_addr;
	logic [31:0]				  data_wdata;
	logic [31:0]				  data_rdata;
	logic						  data_err;
	
	riscv_core_wrapper u_riscv_core_wrapper(/*AUTOINST*/
											// Outputs
											.instr_req_o		(instr_req),
											.instr_addr_o		(instr_addr[31:0]),
											.data_req_o			(data_req),
											.data_we_o			(data_we),
											.data_be_o			(data_be[3:0]),
											.data_addr_o		(data_addr[31:0]),
											.data_wdata_o		(data_wdata[31:0]),
											// Inputs
											.clk				(clk),
											.rst				(rst),
											.instr_gnt_i		(instr_gnt),
											.instr_rvalid_i		(instr_rvalid),
											.instr_rdata_i		(instr_rdata[31:0]),
											.instr_err_i		(instr_err),
											.data_gnt_i			(data_gnt),
											.data_rvalid_i		(data_rvalid),
											.data_rdata_i		(data_rdata[31:0]),
											.data_err_i			(data_err));
	
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

	debugport_controller u_debugport_controller(
												.clk (clk),
												.rst (rst),
												.data_req			(data_req),
												.data_we			(data_we),
												.data_be			(data_be[3:0]),
												.data_addr		(data_addr[31:0]),
												.data_wdata		(data_wdata[31:0]),
												.data_gnt			(data_gnt),
												.data_rvalid		(data_rvalid),
												.data_rdata		(data_rdata[31:0]),
												.data_err			(data_err),
												.debugport (debugport));
	
endmodule // processor_block

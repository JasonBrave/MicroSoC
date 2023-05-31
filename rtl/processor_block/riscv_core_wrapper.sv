/* verilator lint_off UNDRIVEN */

module riscv_core_wrapper(input logic		  clk,
						  input logic		  rst,
						  // Instruction memory interface
						  output logic		  instr_req_o,
						  input logic		  instr_gnt_i,
						  input logic		  instr_rvalid_i,
						  output logic [31:0] instr_addr_o,
						  input logic [31:0]  instr_rdata_i,
						  input logic		  instr_err_i,

						  // Data memory interface
						  output logic		  data_req_o,
						  input logic		  data_gnt_i,
						  input logic		  data_rvalid_i,
						  output logic		  data_we_o,
						  output logic [3:0]  data_be_o,
						  output logic [31:0] data_addr_o,
						  output logic [31:0] data_wdata_o,
						  input logic [31:0]  data_rdata_i,
						  input logic		  data_err_i);

	logic mem_valid, mem_instr, mem_ready;
	logic [31:0] mem_wdata, mem_addr, mem_rdata;
	logic [3:0]	 mem_wstrb;	 
	
	picorv32 #(
			   .TWO_CYCLE_COMPARE(1),
			   .TWO_CYCLE_ALU(1),
			   .ENABLE_MUL(1),
			   .ENABLE_DIV(1),
			   .PROGADDR_RESET(32'h00000080),
			   .PROGADDR_IRQ(32'h00000000)
			   ) u_picorv32 (
							 .clk         (clk),
							 .resetn      (rst),
							 .mem_valid   (mem_valid),
							 .mem_instr   (mem_instr),
							 .mem_ready   (mem_ready),
							 .mem_addr    (mem_addr),
							 .mem_wdata   (mem_wdata),
							 .mem_wstrb   (mem_wstrb),
							 .mem_rdata   (mem_rdata),
							 .irq         (32'h00000000)
							 );

	always_comb begin
		instr_req_o = 1'b0;
		instr_addr_o = 32'h00000000;
		data_req_o = 1'b0;
		data_addr_o = mem_addr;
		data_wdata_o = 32'h00000000;
		data_be_o = 4'b0000;
		data_we_o = 1'b0;
		mem_ready = 1'b0;
		mem_rdata = 32'h00000000;
		if(mem_valid == 1'b1) begin
			if(mem_wstrb == 4'b0000) begin
				if(mem_instr == 1'b1) begin
					instr_req_o = 1'b1;
					instr_addr_o = mem_addr;
					mem_ready = instr_rvalid_i;
					mem_rdata = instr_rdata_i;
				end else begin
					data_req_o = 1'b1;
					data_addr_o = mem_addr;
					mem_ready = data_rvalid_i;
					mem_rdata = data_rdata_i;
				end
			end else begin
				if(mem_instr == 1'b0) begin
					data_req_o = 1'b1;
					data_addr_o = mem_addr;
					data_wdata_o = mem_wdata;
					data_be_o = mem_wstrb;
					data_we_o = 1'b1;
					mem_ready = data_rvalid_i;
				end
			end // else: !if(mem_wstrb == 4'b0000)
		end
		
	end
	
endmodule // riscv_core_wrapper

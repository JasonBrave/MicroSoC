module bootrom(
			   input logic		   clk,
			   input logic		   rst,
			   input logic		   instr_req_i,
			   output logic		   instr_gnt_o,
			   output logic		   instr_rvalid_o,
			   input logic [31:0]  instr_addr_i,
			   output logic [31:0] instr_rdata_o,
			   output logic [6:0]  instr_rdata_intg_o,
			   output logic		   instr_err_o);
	logic [31:0] rdata_next;
	logic		 rvalid_next;
	always_ff @(posedge clk) begin
		if(rst == 1'b0) begin
			instr_rdata_o <= 32'h0000000;
			instr_rvalid_o <= 1'b0;
		end else begin
			instr_rdata_o <= rdata_next;
			instr_rvalid_o <= rvalid_next;
		end
	end
	always_comb begin
		unique case (instr_addr_i[15:2])
			14'h020: rdata_next = 32'h00018137;
			14'h021: rdata_next = 32'h0280006f;
			14'h022: rdata_next = 32'h03200793;
			14'h023: rdata_next = 32'h00100713;
			14'h024: rdata_next = 32'h02f50533;
			14'h025: rdata_next = 32'h000217b7;
			14'h026: rdata_next = 32'h00e7a223;
			14'h027: rdata_next = 32'h00021737;
			14'h028: rdata_next = 32'h00072783;
			14'h029: rdata_next = 32'hfea7eee3;
			14'h02a: rdata_next = 32'h00008067;
			14'h02b: rdata_next = 32'h00000613;
			14'h02c: rdata_next = 32'h00021737;
			14'h02d: rdata_next = 32'h00100513;
			14'h02e: rdata_next = 32'h1f300693;
			14'h02f: rdata_next = 32'h000205b7;
			14'h030: rdata_next = 32'h00a72223;
			14'h031: rdata_next = 32'h00072783;
			14'h032: rdata_next = 32'hfef6fee3;
			14'h033: rdata_next = 32'h00160613;
			14'h034: rdata_next = 32'h00c5a223;
			14'h035: rdata_next = 32'hfedff06f;
			14'h036: rdata_next = 32'h00021000;
			14'h037: rdata_next = 32'h00020000;
			14'h038: rdata_next = 32'h00020000;
			default: rdata_next = 32'h00000000;
		endcase // case (instr_addr_i)
		
		// address decoder
		instr_gnt_o  = instr_req_i && (instr_addr_i[31:16] == 16'h0000);

		// valid driving logic
		rvalid_next = instr_gnt_o;
		
		// misc output
		instr_rdata_intg_o = 7'b0000000;
		instr_err_o = 1'b0;
	end
	
endmodule

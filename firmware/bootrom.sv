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
	always_ff @(posedge clk, negedge rst) begin
		if(rst == 1'b0) begin
			instr_rdata_o <= 32'h0000000;
			instr_rvalid_o <= 1'b0;
		end else begin
			instr_rdata_o <= rdata_next;
			instr_rvalid_o <= rvalid_next;
		end
	end
	always_comb begin
		rdata_next = 32'h12345678;
		unique case (instr_addr_i)
			32'h00000000: rdata_next = 32'h00000000;
			32'h00000004: rdata_next = 32'h00000000;
			32'h00000008: rdata_next = 32'h00000000;
			32'h0000000c: rdata_next = 32'h00000000;
			32'h00000010: rdata_next = 32'h00000000;
			32'h00000014: rdata_next = 32'h00000000;
			32'h00000018: rdata_next = 32'h00000000;
			32'h0000001c: rdata_next = 32'h00000000;
			32'h00000020: rdata_next = 32'h00000000;
			32'h00000024: rdata_next = 32'h00000000;
			32'h00000028: rdata_next = 32'h00000000;
			32'h0000002c: rdata_next = 32'h00000000;
			32'h00000030: rdata_next = 32'h00000000;
			32'h00000034: rdata_next = 32'h00000000;
			32'h00000038: rdata_next = 32'h00000000;
			32'h0000003c: rdata_next = 32'h00000000;
			32'h00000040: rdata_next = 32'h00000000;
			32'h00000044: rdata_next = 32'h00000000;
			32'h00000048: rdata_next = 32'h00000000;
			32'h0000004c: rdata_next = 32'h00000000;
			32'h00000050: rdata_next = 32'h00000000;
			32'h00000054: rdata_next = 32'h00000000;
			32'h00000058: rdata_next = 32'h00000000;
			32'h0000005c: rdata_next = 32'h00000000;
			32'h00000060: rdata_next = 32'h00000000;
			32'h00000064: rdata_next = 32'h00000000;
			32'h00000068: rdata_next = 32'h00000000;
			32'h0000006c: rdata_next = 32'h00000000;
			32'h00000070: rdata_next = 32'h00000000;
			32'h00000074: rdata_next = 32'h00000000;
			32'h00000078: rdata_next = 32'h00000000;
			32'h0000007c: rdata_next = 32'h00000000;
			32'h00000080: rdata_next = 32'h00000513;
			32'h00000084: rdata_next = 32'h00000593;
			32'h00000088: rdata_next = 32'h00100613;
			32'h0000008c: rdata_next = 32'h00000693;
			32'h00000090: rdata_next = 32'h06400713;
			32'h00000094: rdata_next = 32'h00c585b3;
			32'h00000098: rdata_next = 32'h00b50533;
			32'h0000009c: rdata_next = 32'h00168693;
			32'h000000a0: rdata_next = 32'hfee6eae3;
			32'h000000a4: rdata_next = 32'hf1102573;
			32'h000000a8: rdata_next = 32'hf12025f3;
			32'h000000ac: rdata_next = 32'hf1302673;
			32'h000000b0: rdata_next = 32'hf14026f3;
			32'h000000b4: rdata_next = 32'hf1502773;
			32'h000000b8: rdata_next = 32'h0000006f;
			32'h000000bc: rdata_next = 32'h0000006f;
		endcase // case (instr_addr_i)
		
		// address decoder
		instr_gnt_o  = instr_req_i && (instr_addr_i[31:8] == 24'h00000);

		// valid driving logic
		rvalid_next = instr_gnt_o;
		
		// misc output
		instr_rdata_intg_o = 7'b0000000;
		instr_err_o = 1'b0;
	end
	
endmodule

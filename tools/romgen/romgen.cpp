#include <cstdint>
#include <cstdio>
#include <fstream>
#include <iomanip>
#include <ios>
#include <iostream>

int main() {
	FILE *bin = fopen("fw.bin", "rb");

	std::cout << R"(module bootrom(
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
		unique case (instr_addr_i[15:2]))"
			  << std::endl;
	uint32_t addr = 0;
	uint32_t data;
	while (!feof(bin)) {
		fread(&data, sizeof(uint32_t), 1, bin);
		if (data != 0) {
			std::cout << "			14'h";
			std::cout << std::setfill('0') << std::setw(3) << std::hex
					  << (addr >> 2);
			std::cout << ": rdata_next = 32'h";
			std::cout << std::setfill('0') << std::setw(8) << std::hex << data;
			std::cout << ';' << std::endl;
		}
		addr += 4;
	}
	std::cout << R"(			default: rdata_next = 32'h00000000;
		endcase // case (instr_addr_i)
		
		// address decoder
		instr_gnt_o  = instr_req_i && (instr_addr_i[31:16] == 16'h0000);

		// valid driving logic
		rvalid_next = instr_gnt_o;
		
		// misc output
		instr_rdata_intg_o = 7'b0000000;
		instr_err_o = 1'b0;
	end
	
endmodule)" << std::endl;
	fclose(bin);
}

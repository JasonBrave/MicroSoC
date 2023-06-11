module ram(input logic		   clk,
		   input logic		   rst,
		   output logic		   rvalid,
		   input logic [31:0]  addr,
		   input logic		   we,
		   input logic [3:0]   be,
		   input logic [31:0]  wdata,
		   output logic [31:0] rdata,
		   input logic		   req,
		   output logic		   gnt);

	logic [3:0][7:0]   memory [0:8191];
	
	logic			   decode;
	
	always_comb begin
		decode = (addr[31:16] == 16'h0001);
	end

	always @(posedge clk) begin	
		if(rst == 1'b0) begin
			rdata <= 32'h00000000;
			gnt <= 1'b0;
			rvalid <= 1'b0;
		end else begin	
			gnt <= req && ~gnt && decode;
			rvalid <= gnt;

			if(req && decode) begin
				if(we) begin
					if(be[0]) memory[addr[14:2]][0] <= wdata[7:0];
					if(be[1]) memory[addr[14:2]][1] <= wdata[15:8];
					if(be[2]) memory[addr[14:2]][2] <= wdata[23:16];
					if(be[3]) memory[addr[14:2]][3] <= wdata[31:24];
				end
			end
		end // else: !if(rst == 1'b0)

		rdata <= memory[addr[14:2]];
	end // always @ (posedge clk)
	
endmodule // ram

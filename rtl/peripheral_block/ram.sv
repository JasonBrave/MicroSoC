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

	logic [31:0]   memory [0:1023];
	
	logic		   gnt_next;
	logic		   decode;
	logic		   rvalid_next;
	
	always_comb begin
		decode = (addr[31:12] == 20'h00002);
		gnt_next = req && ~gnt && decode;
		rvalid_next = gnt;
	end

	always @(posedge clk) begin	
		if(rst == 1'b0) begin
			rdata <= 32'h00000000;
			gnt <= 1'b0;
			rvalid <= 1'b0;
		end else begin	
			gnt <= gnt_next;
			rvalid <= rvalid_next;

			if(req && decode) begin
				if(we) begin
					if(be[0]) begin
						memory[addr[11:2]][7:0] <= wdata[7:0];
					end
					if(be[1]) begin
						memory[addr[11:2]][15:8] <= wdata[15:8];
					end
					if(be[2]) begin
						memory[addr[11:2]][23:16] <= wdata[23:16];
					end
					if(be[3]) begin
						memory[addr[11:2]][31:24] <= wdata[31:24];
					end
				end else begin // if (we)
					rdata <= memory[addr[11:2]];
				end // else: !if(we)
			end
			
		end // else: !if(rst == 1'b0)
	end // always @ (posedge clk)
	
endmodule // ram

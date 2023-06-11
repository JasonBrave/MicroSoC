module timer32(input logic		   clk,
			   input logic		   rst,
			   input logic		   data_req,
			   input logic		   data_we,
			   input logic [3:0]   data_be,
			   input logic [31:0]  data_addr,
			   input logic [31:0]  data_wdata,
			   output logic		   data_gnt,
			   output logic		   data_rvalid,
			   output logic [31:0] data_rdata);

	logic		 gnt_next;
	logic		 decode;
	logic		 rvalid_next;

	logic [31:0] counter;
	logic		 counter_need_reset;

	always_ff @(posedge clk) begin
		if((rst == 1'b0) || (counter_need_reset == 1'b1)) begin
			counter <= 32'h00000000;
		end else begin
			counter <= counter + 'd1;
		end
	end
	
	always_comb begin
		decode = (data_addr[31:12] == 20'h00021);
		gnt_next = data_req && ~data_gnt && decode;
		rvalid_next = data_gnt;
	end

	always @(posedge clk) begin
		counter_need_reset <= 1'b0;
		
		if(rst == 1'b0) begin
			data_rdata <= 32'h00000000;
			data_gnt <= 1'b0;
			data_rvalid <= 1'b0;
		end else begin		
			data_gnt <= gnt_next;
			data_rvalid <= rvalid_next;

			if(data_req && decode) begin
				if(data_we && (data_addr[11:0] == 12'h004)) begin
					if(data_be[0]) begin
						counter_need_reset <= 1'b1;
					end
				end else begin // if (data_we)
					case(data_addr[11:2])
						0: begin
							data_rdata <= counter;
						end
						default: begin
							data_rdata <= 32'h00000000;
						end
					endcase
				end // else: !if(data_we)
			end
		end
	end
	
endmodule // debugport_controller

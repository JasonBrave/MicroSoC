module gpio_controller(input logic		   clk,
					   input logic		   rst,
					   input logic		   data_req,
					   input logic		   data_we,
					   input logic [3:0]   data_be,
					   input logic [31:0]  data_addr,
					   input logic [31:0]  data_wdata,
					   output logic		   data_gnt,
					   output logic		   data_rvalid,
					   output logic [31:0] data_rdata,
					   output logic [17:0] gpio_out,
					   input logic [11:0]  gpio_in);

	logic		 gnt_next;
	logic		 decode;
	logic		 rvalid_next;

	always_comb begin
		decode = (data_addr[31:12] == 20'h00001);
		gnt_next = data_req && ~data_gnt && decode;
		rvalid_next = data_gnt;
	end

	always @(posedge clk) begin
		if(rst == 1'b0) begin
			data_rdata <= 32'h00000000;
			data_gnt <= 1'b0;
			data_rvalid <= 1'b0;
			gpio_out <= 18'h00000;
		end else begin		
			data_gnt <= gnt_next;
			data_rvalid <= rvalid_next;

			if(data_req && decode) begin
				if(data_we && (data_addr[11:0] == 12'h004)) begin
					if(data_be[0]) begin
						gpio_out[7:0] <= data_wdata[7:0];
					end
					if(data_be[1]) begin
						gpio_out[15:8] <= data_wdata[15:8];
					end
					if(data_be[2]) begin
						gpio_out[17:16] <= data_wdata[17:16];
					end
				end else begin // if (data_we)
					case(data_addr[11:2])
						0: begin
							data_rdata <= {20'h00000, gpio_in};
						end
						1: begin
							data_rdata <= {14'h0000, gpio_out};
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

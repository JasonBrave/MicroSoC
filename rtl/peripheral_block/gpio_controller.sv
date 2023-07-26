module gpio_controller #(
						 INPUT_BITS = 12,
						 OUTPUT_BITS = 18)
	(
	 input logic					  clk,
	 input logic					  rst,
	 input logic					  data_req,
	 input logic					  data_we,
	 input logic [3:0]				  data_be,
	 input logic [31:0]				  data_addr,
	 input logic [31:0]				  data_wdata,
	 output logic					  data_gnt,
	 output logic					  data_rvalid,
	 output logic [31:0]			  data_rdata,
	 output logic [OUTPUT_BITS-1 : 0] gpio_out,
	 input logic [INPUT_BITS-1 : 0]	  gpio_in,
	 output logic					  irq);

	logic		 gnt_next;
	logic		 decode;
	logic		 rvalid_next;

	logic [INPUT_BITS-1 : 0] intr_status, prev_in, intr_enable, intr_clear;
	
	always_comb begin
		decode = (data_addr[31:12] == 20'h00020);
		gnt_next = data_req && ~data_gnt && decode;
		rvalid_next = data_gnt;
	end
	
	// edge detector
	always_ff @(posedge clk) begin
		prev_in <= gpio_in;
		
		if(rst == 1'b0) begin
			intr_status <= 12'h000;
		end else begin
			intr_status <= intr_enable & ((intr_status & ~intr_clear) | (~prev_in & gpio_in));
		end
	end

	// registers
	always_ff @(posedge clk) begin
		intr_clear <= 12'h000;

		if(rst == 1'b0) begin
			data_rdata <= 32'h00000000;
			data_gnt <= 1'b0;
			data_rvalid <= 1'b0;
			gpio_out <= 18'h00000;
			intr_enable <= 12'h000;
		end else begin		
			data_gnt <= gnt_next;
			data_rvalid <= rvalid_next;

			if(data_req && decode) begin
				if(data_we) begin
					case(data_addr[11:2])
						1: begin
							if(data_be[0]) begin
								gpio_out[7:0] <= data_wdata[7:0];
							end
							if(data_be[1]) begin
								gpio_out[15:8] <= data_wdata[15:8];
							end
							if(data_be[2]) begin
								gpio_out[17:16] <= data_wdata[17:16];
							end
						end // case: 1
						2: begin
							if(data_be[0]) begin
								intr_enable[7:0] <= data_wdata[7:0];
							end
							if(data_be[1]) begin
								intr_enable[11:8] <= data_wdata[11:8];
							end
						end
						3: begin
							if(data_be[0]) begin
								intr_clear[7:0] <= data_wdata[7:0];
							end
							if(data_be[1]) begin
								intr_clear[11:8] <= data_wdata[11:8];
							end
						end
					endcase // case (data_addr[11:2])
				end else begin // if (data_we)
					case(data_addr[11:2])
						0: begin
							data_rdata <= {20'h00000, gpio_in};
						end
						1: begin
							data_rdata <= {14'h0000, gpio_out};
						end
						2: begin
							data_rdata <= {20'h00000, intr_enable};
						end
						3: begin
							data_rdata <= {20'h00000, intr_status};
						end
						default: begin
							data_rdata <= 32'h00000000;
						end
					endcase
				end // else: !if(data_we)
			end
		end
	end

	assign irq = |intr_status;
	
endmodule // debugport_controller

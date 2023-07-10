module intr_controller(input logic		   clk,
					   input logic		   rst,
					   input logic		   data_req,
					   input logic		   data_we,
					   input logic [3:0]   data_be,
					   input logic [31:0]  data_addr,
					   input logic [31:0]  data_wdata,
					   output logic		   data_gnt,
					   output logic		   data_rvalid,
					   output logic [31:0] data_rdata,
					   input logic [255:0] irq_source,
					   output logic [15:0] intr_id,
					   output logic		   intr_signal);

	logic		 gnt_next;
	logic		 decode;
	logic		 rvalid_next;

	logic [255:0]	  irq_enable;

	initial irq_enable = 256'h0;
	
	always_comb begin
		decode = (data_addr[31:12] == 20'h00022);
		gnt_next = data_req && ~data_gnt && decode;
		rvalid_next = data_gnt;
	end

	// interrupt
	always_comb begin
		intr_signal = &(irq_source & irq_enable);
		intr_id = 16'h0;
	end
	
	// register interface
	always_ff @(posedge clk) begin

		if(rst == 1'b0) begin
			data_rdata <= 32'h00000000;
			data_gnt <= 1'b0;
			data_rvalid <= 1'b0;

		end else begin		
			data_gnt <= gnt_next;
			data_rvalid <= rvalid_next;

			if(data_req && decode) begin
				if(data_we) begin
					case(data_addr[11:2])
						0: begin
							if(data_be[0]) begin
								irq_enable[7:0] <= data_wdata[7:0];
							end
						end
					endcase // case (data_addr[11:2])
				end else begin // if (data_we)
					case(data_addr[11:2])
						0: begin
							data_rdata <= irq_enable[31:0];
						end
						default: begin
							data_rdata <= 32'h00000000;
						end
					endcase
				end // else: !if(data_we)
			end
		end
	end
	
endmodule // intr_controller


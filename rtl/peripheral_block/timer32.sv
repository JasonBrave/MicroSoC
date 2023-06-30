/*
 Register Map:
 0x0 RO Current count
 0x4 WO Reset counter
 - Bit 0 reset
 0x8 RW Timeout threshold
 0xC RW Timeout control/status
 - Bit 0 enable
 - Bit 1 timeout occured
 */

module timer32(input logic		   clk,
			   input logic		   rst,
			   input logic		   data_req,
			   input logic		   data_we,
			   input logic [3:0]   data_be,
			   input logic [31:0]  data_addr,
			   input logic [31:0]  data_wdata,
			   output logic		   data_gnt,
			   output logic		   data_rvalid,
			   output logic [31:0] data_rdata,
			   output logic		   irq);

	logic		 gnt_next;
	logic		 decode;
	logic		 rvalid_next;

	logic [31:0] counter;
	logic		 counter_need_reset;

	logic		 timeout_enabled;
	logic		 timeout_attempt_enable;
	logic [31:0] timeout_threshold;
	logic		 timeout_occured;
	logic		 timeout_clear_occur;
	
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
		timeout_attempt_enable <= 1'b0;
		timeout_clear_occur <= 1'b0;
		
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
						1: begin
							if(data_be[0]) begin
								counter_need_reset <= data_wdata[0];
							end
						end
						2: begin
							if(data_be[0]) timeout_threshold[7:0] <= data_wdata[7:0];
							if(data_be[1]) timeout_threshold[15:8] <= data_wdata[15:8];
							if(data_be[2]) timeout_threshold[23:16] <= data_wdata[23:16];
							if(data_be[3]) timeout_threshold[31:24] <= data_wdata[31:24];
						end
						3: begin
							if(data_be[0]) begin
								timeout_attempt_enable <= data_wdata[0];
								timeout_clear_occur <= data_wdata[1];
							end
						end
						
					endcase // case (data_addr[11:2])
				end else begin // if (data_we)
					case(data_addr[11:2])
						0: begin
							data_rdata <= counter;
						end
						2: begin
							data_rdata <= timeout_threshold;
						end
						3: begin
							data_rdata <= {{30{1'b0}}, timeout_occured, timeout_enabled};
						end
						default: begin
							data_rdata <= 32'h00000000;
						end
					endcase
				end // else: !if(data_we)
			end
		end
	end

	always_ff @(posedge clk) begin
		if(rst == 1'b0) begin
			timeout_enabled <= 1'b0;
			timeout_occured <= 1'b0;
		end else begin
			if(timeout_attempt_enable == 1'b1) begin
				timeout_enabled <= 1'b1;
			end

			if(timeout_clear_occur == 1'b1) begin
				timeout_occured <= 1'b0;
			end
			
			if(timeout_enabled == 1'b1) begin
				if(counter >= timeout_threshold) begin
					timeout_occured <= 1'b1;
					timeout_enabled <= 1'b0;
				end
			end
		end
		
	end

	assign irq = timeout_occured;
	
endmodule // debugport_controller

module gpio_controller (
						input logic			clk,
						input logic			rst,
						input logic			data_req,
						input logic			data_we,
						input logic [3:0]	data_be,
						input logic [31:0]	data_addr,
						input logic [31:0]	data_wdata,
						output logic		data_gnt,
						output logic		data_rvalid,
						output logic [31:0]	data_rdata,
						output logic [63:0]	gpio_out,
						input logic [63:0]	gpio_in,
						output logic		irq);

	logic		 gnt_next;
	logic		 decode;
	logic		 rvalid_next;

	logic [63:0] out_enable;
	logic [63:0] prev_in;
	logic [63:0] posedge_det_enable, negedge_det_enable;
	logic [63:0] posedge_det_status, negedge_det_status;
	logic [63:0] posedge_status_clear, negedge_status_clear;
	
	always_comb begin
		decode = (data_addr[31:12] == 20'h00020);
		gnt_next = data_req && ~data_gnt && decode;
		rvalid_next = data_gnt;
	end
	
	// edge detector
	always_ff @(posedge clk) begin
		prev_in <= gpio_in;
		
		if(rst == 1'b0) begin
			posedge_det_status <= 64'h0;
			negedge_det_status <= 64'h0;
		end else begin
			posedge_det_status <= posedge_det_enable & ((posedge_det_status & ~posedge_status_clear) | (~prev_in & gpio_in));
			negedge_det_status <= negedge_det_enable & ((negedge_det_status & ~negedge_status_clear) | (prev_in & ~gpio_in));
		end
	end

	// registers
	always_ff @(posedge clk) begin
		posedge_status_clear <= 64'h0;
		negedge_status_clear <= 64'h0;

		if(rst == 1'b0) begin
			data_rdata <= 32'h00000000;
			data_gnt <= 1'b0;
			data_rvalid <= 1'b0;
			gpio_out <= 64'h0;
			out_enable <= 64'h0;
			posedge_det_enable <= 64'h0;
			negedge_det_enable <= 64'h0;
		end else begin		
			data_gnt <= gnt_next;
			data_rvalid <= rvalid_next;

			if(data_req && decode) begin
				if(data_we) begin
					case(data_addr[11:2])
						2: begin
							if(data_be[0]) begin
								out_enable[7:0] <= data_wdata[7:0];
							end
							if(data_be[1]) begin
								out_enable[15:8] <= data_wdata[15:8];
							end
							if(data_be[2]) begin
								out_enable[23:16] <= data_wdata[23:16];
							end
							if(data_be[3]) begin
								out_enable[31:24] <= data_wdata[31:24];
							end
						end
						3: begin
							if(data_be[0]) begin
								out_enable[39:32] <= data_wdata[7:0];
							end
							if(data_be[1]) begin
								out_enable[47:40] <= data_wdata[15:8];
							end
							if(data_be[2]) begin
								out_enable[55:48] <= data_wdata[23:16];
							end
							if(data_be[3]) begin
								out_enable[63:56] <= data_wdata[31:24];
							end
						end
						4: begin
							if(data_be[0]) begin
								gpio_out[7:0] <= data_wdata[7:0];
							end
							if(data_be[1]) begin
								gpio_out[15:8] <= data_wdata[15:8];
							end
							if(data_be[2]) begin
								gpio_out[23:16] <= data_wdata[23:16];
							end
							if(data_be[3]) begin
								gpio_out[31:24] <= data_wdata[31:24];
							end
						end
						5: begin
							if(data_be[0]) begin
								gpio_out[39:32] <= data_wdata[7:0];
							end
							if(data_be[1]) begin
								gpio_out[47:40] <= data_wdata[15:8];
							end
							if(data_be[2]) begin
								gpio_out[55:48] <= data_wdata[23:16];
							end
							if(data_be[3]) begin
								gpio_out[63:56] <= data_wdata[31:24];
							end
						end
						6: begin
							if(data_be[0]) begin
								posedge_det_enable[7:0] <= data_wdata[7:0];
							end
							if(data_be[1]) begin
								posedge_det_enable[15:8] <= data_wdata[15:8];
							end
							if(data_be[2]) begin
								posedge_det_enable[23:16] <= data_wdata[23:16];
							end
							if(data_be[3]) begin
								posedge_det_enable[31:24] <= data_wdata[31:24];
							end
						end
						7: begin
							if(data_be[0]) begin
								posedge_det_enable[39:32] <= data_wdata[7:0];
							end
							if(data_be[1]) begin
								posedge_det_enable[47:40] <= data_wdata[15:8];
							end
							if(data_be[2]) begin
								posedge_det_enable[55:48] <= data_wdata[23:16];
							end
							if(data_be[3]) begin
								posedge_det_enable[63:56] <= data_wdata[31:24];
							end
						end
						8: begin
							if(data_be[0]) begin
								negedge_det_enable[7:0] <= data_wdata[7:0];
							end
							if(data_be[1]) begin
								negedge_det_enable[15:8] <= data_wdata[15:8];
							end
							if(data_be[2]) begin
								negedge_det_enable[23:16] <= data_wdata[23:16];
							end
							if(data_be[3]) begin
								negedge_det_enable[31:24] <= data_wdata[31:24];
							end
						end
						9: begin
							if(data_be[0]) begin
								negedge_det_enable[39:32] <= data_wdata[7:0];
							end
							if(data_be[1]) begin
								negedge_det_enable[47:40] <= data_wdata[15:8];
							end
							if(data_be[2]) begin
								negedge_det_enable[55:48] <= data_wdata[23:16];
							end
							if(data_be[3]) begin
								negedge_det_enable[63:56] <= data_wdata[31:24];
							end
						end
						10: begin
							if(data_be[0]) begin
								posedge_status_clear[7:0] <= data_wdata[7:0];
							end
							if(data_be[1]) begin
								posedge_status_clear[15:8] <= data_wdata[15:8];
							end
							if(data_be[2]) begin
								posedge_status_clear[23:16] <= data_wdata[23:16];
							end
							if(data_be[3]) begin
								posedge_status_clear[31:24] <= data_wdata[31:24];
							end
						end
						11: begin
							if(data_be[0]) begin
								posedge_status_clear[39:32] <= data_wdata[7:0];
							end
							if(data_be[1]) begin
								posedge_status_clear[47:40] <= data_wdata[15:8];
							end
							if(data_be[2]) begin
								posedge_status_clear[55:48] <= data_wdata[23:16];
							end
							if(data_be[3]) begin
								posedge_status_clear[63:56] <= data_wdata[31:24];
							end
						end
						12: begin
							if(data_be[0]) begin
								negedge_status_clear[7:0] <= data_wdata[7:0];
							end
							if(data_be[1]) begin
								negedge_status_clear[15:8] <= data_wdata[15:8];
							end
							if(data_be[2]) begin
								negedge_status_clear[23:16] <= data_wdata[23:16];
							end
							if(data_be[3]) begin
								negedge_status_clear[31:24] <= data_wdata[31:24];
							end
						end
						13: begin
							if(data_be[0]) begin
								negedge_status_clear[39:32] <= data_wdata[7:0];
							end
							if(data_be[1]) begin
								negedge_status_clear[47:40] <= data_wdata[15:8];
							end
							if(data_be[2]) begin
								negedge_status_clear[55:48] <= data_wdata[23:16];
							end
							if(data_be[3]) begin
								negedge_status_clear[63:56] <= data_wdata[31:24];
							end
						end
					endcase // case (data_addr[11:2])
				end else begin // if (data_we)
					case(data_addr[11:2])
						0: begin
							data_rdata <= gpio_in[31:0];
						end
						1: begin
							data_rdata <= gpio_in[63:32];
						end
						2: begin
							data_rdata <= out_enable[31:0];
						end
						3: begin
							data_rdata <= out_enable[63:32];
						end
						4: begin
							data_rdata <= gpio_out[31:0];
						end
						5: begin
							data_rdata <= gpio_out[63:32];
						end
						6: begin
							data_rdata <= posedge_det_enable[31:0];
						end
						7: begin
							data_rdata <= posedge_det_enable[63:32];
						end
						8: begin
							data_rdata <= negedge_det_enable[31:0];
						end
						9: begin
							data_rdata <= negedge_det_enable[63:32];
						end
						10: begin
							data_rdata <=posedge_det_status[31:0];
						end
						11: begin
							data_rdata <= posedge_det_status[63:32];
						end
						12: begin
							data_rdata <= negedge_det_status[31:0];
						end
						13: begin
							data_rdata <= negedge_det_status[63:32];
						end
						default: begin
							data_rdata <= 32'h00000000;
						end
					endcase
				end // else: !if(data_we)
			end
		end
	end

	assign irq = |{posedge_det_status, negedge_det_status};
	
endmodule // debugport_controller

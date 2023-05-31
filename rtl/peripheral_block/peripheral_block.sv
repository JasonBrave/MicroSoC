module peripheral_block(input logic			clk,
						input logic			rst,
						input logic			data_req,
						input logic			data_we,
						input logic [3:0]	data_be,
						input logic [31:0]	data_addr,
						input logic [31:0]	data_wdata,
						output logic		data_gnt,
						output logic		data_rvalid,
						output logic [31:0]	data_rdata,
						output logic		data_err,
						output logic [17:0]	gpio_out,
						input logic [11:0]	gpio_in);

	gpio_controller u_gpio_controller(/*AUTOINST*/
									  // Outputs
									  .data_gnt			(data_gnt),
									  .data_rvalid		(data_rvalid),
									  .data_rdata		(data_rdata[31:0]),
									  .data_err			(data_err),
									  .gpio_out			(gpio_out[17:0]),
									  // Inputs
									  .clk				(clk),
									  .rst				(rst),
									  .data_req			(data_req),
									  .data_we			(data_we),
									  .data_be			(data_be[3:0]),
									  .data_addr		(data_addr[31:0]),
									  .data_wdata		(data_wdata[31:0]),
									  .gpio_in			(gpio_in[11:0]));
	
endmodule // peripheral_block

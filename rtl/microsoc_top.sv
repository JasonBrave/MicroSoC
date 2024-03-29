module microsoc_top(input logic			clk,
					input logic			rst,
					output logic [63:0]	gpio_out,
					input logic [63:0]	gpio_in,
					input logic			uart_clk,
					input logic			uart_rx,
					output logic		uart_tx
					/*AUTOARG*/);

	logic						  data_req;
	logic						  data_gnt;
	logic						  data_rvalid;
	logic						  data_we;
	logic [3:0]					  data_be;
	logic [31:0]				  data_addr;
	logic [31:0]				  data_wdata;
	logic [31:0]				  data_rdata;
	logic						  data_err;
	
	processor_block u_processor_block(
									  /*AUTOINST*/
									  // Outputs
									  .data_req_o		(data_req),
									  .data_we_o		(data_we),
									  .data_be_o		(data_be[3:0]),
									  .data_addr_o		(data_addr[31:0]),
									  .data_wdata_o		(data_wdata[31:0]),
									  // Inputs
									  .clk				(clk),
									  .rst				(rst),
									  .data_gnt_i		(data_gnt),
									  .data_rvalid_i	(data_rvalid),
									  .data_rdata_i		(data_rdata[31:0]),
									  .data_err_i		(data_err));

	peripheral_block u_peripheral_block(/*AUTOINST*/
										// Outputs
										.data_gnt		(data_gnt),
										.data_rvalid	(data_rvalid),
										.data_rdata		(data_rdata[31:0]),
										.data_err		(data_err),
										.gpio_out		(gpio_out[63:0]),
										.uart_tx (uart_tx),
										// Inputs
										.clk			(clk),
										.rst			(rst),
										.data_req		(data_req),
										.data_we		(data_we),
										.data_be		(data_be[3:0]),
										.data_addr		(data_addr[31:0]),
										.data_wdata		(data_wdata[31:0]),
										.gpio_in		(gpio_in[63:0]),
										.uart_clk(uart_clk),
										.uart_rx(uart_rx));
	
	initial begin
		$dumpfile("wave.vcd");
		$dumpvars(0,microsoc_top);
	end

endmodule // minisoc

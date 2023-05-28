module microsoc_top(input logic		   clk,
					input logic		   rst,
					output logic [7:0] debugport
					/*AUTOARG*/);

	processor_block u_processor_block(
									  /*AUTOINST*/
									  // Outputs
									  .debugport		(debugport[7:0]),
									  // Inputs
									  .clk				(clk),
									  .rst				(rst));
	
	initial begin
		$dumpfile("wave.vcd");
		$dumpvars(0,microsoc_top);
	end

endmodule // minisoc

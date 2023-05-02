module microsoc_top(input logic		   clk,
					input logic		   rst,
					output logic	   debugport_en,
					output logic [7:0] debugport
					/*AUTOARG*/);

	processor_block u_processor_block(
									  /*AUTOINST*/
									  // Inputs
									  .clk				(clk),
									  .rst				(rst));

	always_comb begin
		debugport_en = 1'b0;
		debugport = 8'h00;
	end
	
	initial begin
		$dumpfile("wave.vcd");
		$dumpvars(0,microsoc_top);
	end

endmodule // minisoc

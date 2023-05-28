module debugport_controller(input logic			clk,
							input logic			rst,
							input logic			data_req,
							input logic			data_we,
							input logic [3:0]	data_be,
							input logic [31:0]	data_addr,
							input logic [31:0]	data_wdata,
							input logic [6:0]	data_wdata_intg,
							output logic		data_gnt,
							output logic		data_rvalid,
							output logic [31:0]	data_rdata,
							output logic [6:0]	data_rdata_intg,
							output logic		data_err,
							output logic [7:0]	debugport);

	logic [31:0] read_next;
	logic		 gnt_next;
	logic		 rvalid_next;

	always_comb begin
		read_next = 32'h00000000;
		rvalid_next = data_gnt;
		gnt_next = data_req && ~data_gnt;
	end

	always @(posedge clk) begin
		data_rdata <= read_next;		
		data_gnt <= gnt_next;
		data_rvalid <= rvalid_next;
		
		if(data_req && data_we) begin
			if(data_be[0]) begin
				debugport <= data_wdata[7:0];
			end
		end
		
	end

	assign data_rdata_intg = 7'b0000000;
	assign data_err = 1'b0;
	
endmodule // debugport_controller

module debugport_controller(input logic			clk,
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
		if(rst == 1'b0) begin
			data_rdata <= 32'h00000000;
			data_gnt <= 1'b0;
			data_rvalid <= 1'b0;
			debugport <= 8'h00;
		end else begin
			data_rdata <= read_next;		
			data_gnt <= gnt_next;
			data_rvalid <= rvalid_next;
			
			if(data_req && data_we) begin
				if(data_be[0]) begin
					debugport <= data_wdata[7:0];
				end
			end
		end
	end

	assign data_err = 1'b0;
	
endmodule // debugport_controller

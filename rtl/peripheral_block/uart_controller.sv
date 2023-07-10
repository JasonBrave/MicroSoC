module uart_controller(
					   input logic		   clk,
					   input logic		   uart_clk,
					   input logic		   rst,
					   input logic		   data_req,
					   input logic		   data_we,
					   input logic [3:0]   data_be,
					   input logic [31:0]  data_addr,
					   input logic [31:0]  data_wdata,
					   output logic		   data_gnt,
					   output logic		   data_rvalid,
					   output logic [31:0] data_rdata,
					   output logic		   irq,
					   output logic		   tx,
					   input logic		   rx
					   );

	// clocks
	logic		tx_clk, rx_sample_clk;
	
	// control registers
	logic		tx_parity_enable, tx_start;
	logic [7:0]	tx_buf;
	// future baud rate control register
	
	// status registers
	logic		tx_busy;
	
	// internal
	logic		tx_parity;
	logic		gnt_next;
	logic		decode;
	logic		rvalid_next;

	assign tx_clk = uart_clk;
	assign rx_sample_clk = uart_clk;
	
	typedef enum logic [3:0] 
	  {
	   TX_IDLE,
	   TX_START,
	   TX_D1,
	   TX_D2,
	   TX_D3,
	   TX_D4,
	   TX_D5,
	   TX_D6,
	   TX_D7,
	   TX_D8,
	   TX_PARITY,
	   TX_STOP
	   } tx_state_t;
	
	tx_state_t tx_state, tx_next_state;

	always_ff @(posedge tx_clk) begin
		if(rst == 1'b0) begin
			tx_state <= TX_IDLE;
			tx_parity <= 1'b0;
		end else begin
			tx_state <= tx_next_state;
		end
	end

	always_comb begin
		tx_busy = 1'b1;
		case(tx_state)
			TX_IDLE: begin
				tx = 1'b1;
				tx_busy = 1'b0;
			end
			TX_START: begin
				tx = 1'b0;
			end
			TX_D1: begin
				tx = tx_buf[0];
			end
			TX_D2: begin
				tx = tx_buf[1];
			end
			TX_D3: begin
				tx = tx_buf[2];
			end
			TX_D4: begin
				tx = tx_buf[3];
			end
			TX_D5: begin
				tx = tx_buf[4];
			end
			TX_D6: begin
				tx = tx_buf[5];
			end
			TX_D7: begin
				tx = tx_buf[6];
			end
			TX_D8: begin
				tx = tx_buf[7];
			end
			TX_PARITY: begin
				tx = tx_parity;
			end
			TX_STOP: begin
				tx = 1'b1;
			end
			default: begin // should not happen
				tx = 1'b1;
			end	
		endcase
	end

	always_comb begin
		tx_next_state = TX_IDLE;
		case(tx_state)
			TX_IDLE: begin
				if(tx_start == 1'b1) begin
					tx_next_state = TX_START;
				end else begin
					tx_next_state = TX_IDLE;
				end
			end
			TX_START: begin
				tx_next_state = TX_D1;
			end
			TX_D1: begin
				tx_next_state = TX_D2;
			end
			TX_D2: begin
				tx_next_state = TX_D3;
			end
			TX_D3: begin
				tx_next_state = TX_D4;
			end
			TX_D4: begin
				tx_next_state = TX_D5;
			end
			TX_D5: begin
				tx_next_state = TX_D6;
			end
			TX_D6: begin
				tx_next_state = TX_D7;
			end
			TX_D7: begin
				tx_next_state = TX_D8;
			end
			TX_D8: begin
				if(tx_parity_enable == 1'b1) begin
					tx_next_state = TX_PARITY;
				end else begin
					tx_next_state = TX_STOP;
				end
			end
			TX_PARITY: begin
				tx_next_state = TX_STOP;
			end
			TX_STOP: begin
				tx_next_state = TX_IDLE;
			end
			default: begin // should not happen
				tx_next_state = TX_IDLE;
			end	
		endcase // case (tx_state)
		
	end

	// address decoder
	always_comb begin
		decode = (data_addr[31:12] == 20'h00023);
		gnt_next = data_req && ~data_gnt && decode;
		rvalid_next = data_gnt;
	end
	
	// registers
	always_ff @(posedge clk) begin
		tx_start <= 1'b0;
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
								tx_buf <= data_wdata[7:0];
							end
						end
						1: begin
							if(data_be[0]) begin
								tx_parity_enable <= data_wdata[1];
								tx_start <= data_wdata[0];
							end
						end
						// 2 for baud rate control
						// 3 read only status
					endcase // case (data_addr[11:2])
				end else begin // if (data_we)
					case(data_addr[11:2])
						0: begin
							data_rdata <= {24'h000000, tx_buf};
						end
						1: begin
							data_rdata <= {30'h0, tx_parity_enable, 1'b0};
						end
						2: begin // baud rate
							data_rdata <= 32'h0;
						end
						3: begin
							data_rdata <= {31'h0, tx_busy};
						end
					endcase // case (data_addr[11:2])
				end // else: !if(data_we)
			end // if (data_req && decode)
		end
	end
	
	assign irq = 1'b0;
	
endmodule // uart_controller

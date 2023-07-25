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
	logic		tx_clk, rx_clk;

	// TX register block
	// control registers
	logic		tx_parity_enable, tx_start;
	logic [7:0]	tx_buf;
	// future baud rate control register
	
	// status registers
	logic		tx_busy;

	// RX register block
	logic		rx_parity_enable;
	logic [7:0]	rx_buf;
	logic		rx_received, rx_received_clear;
	logic		rx_invalid_parity_detected, rx_invalid_parity_clear;
	logic		rx_discard_policy;
	
	// internal
	logic		tx_parity, rx_parity;
	logic		gnt_next;
	logic		decode;
	logic		rvalid_next;

	assign tx_clk = uart_clk;
	assign rx_clk = uart_clk;
	
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

	typedef enum logic [3:0]
	  {
	   RX_IDLE,
	   RX_D1,
	   RX_D2,
	   RX_D3,
	   RX_D4,
	   RX_D5,
	   RX_D6,
	   RX_D7,
	   RX_D8,
	   RX_PARITY,
	   RX_STOP,
	   RX_PARITY_INVALID
	   } rx_state_t;
	rx_state_t rx_state, rx_next_state;

	// TX State Register
	always_ff @(posedge tx_clk) begin
		if(rst == 1'b0) begin
			tx_state <= TX_IDLE;
		end else begin
			tx_state <= tx_next_state;
		end
	end

	// TX Output Decoder
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

	// TX State Transition
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

	// RX state register
	always_ff @(posedge rx_clk) begin
		if(rst == 1'b0) begin
			rx_state <= RX_IDLE;
		end else begin
			rx_state <= rx_next_state;
		end
	end

	// RX state transition
	always_comb begin
		case(rx_state)
			RX_IDLE: begin
				if(rx == 1'b0) begin
					rx_next_state = RX_D1;
				end else begin
					rx_next_state = RX_IDLE;
				end
			end
			RX_D1: rx_next_state = RX_D2;
			RX_D2: rx_next_state = RX_D3;
			RX_D3: rx_next_state = RX_D4;
			RX_D4: rx_next_state = RX_D5;
			RX_D5: rx_next_state = RX_D6;
			RX_D6: rx_next_state = RX_D7;
			RX_D7: rx_next_state = RX_D8;
			RX_D8: begin
				if(rx_parity_enable == 1'b1) begin
					rx_next_state = RX_PARITY;
				end else begin
					rx_next_state = RX_STOP;
				end
			end
			RX_PARITY: begin
				if(rx == rx_parity) begin
					rx_next_state = RX_STOP;
				end else begin
					rx_next_state = RX_PARITY_INVALID;
				end
			end
			RX_PARITY_INVALID: begin
				rx_next_state = RX_STOP;
			end
			default: rx_next_state = RX_IDLE;
		endcase // case (rx_state)
	end
	
	// RX buffer register
	always_ff @(posedge rx_clk) begin
		if(rst == 1'b0) begin
			rx_buf <= 8'h00;
		end else begin
			if((rx_state == RX_D1) || (rx_state == RX_D2) || (rx_state == RX_D3) || (rx_state == RX_D4) || (rx_state == RX_D5) || (rx_state == RX_D6) || (rx_state == RX_D7) || (rx_state == RX_D8)) begin
				rx_buf <= {rx, rx_buf[7:1]};
			end
		end
	end

	// RX received and invalid parity register
	always_ff @(posedge rx_clk) begin
		if((rst == 1'b0) || (rx_received_clear == 1'b1)) begin
			rx_received <= 1'b0;
		end else if(rx_state == RX_STOP) begin
			rx_received <= 1'b1;
		end

		if((rst == 1'b0) || (rx_invalid_parity_clear == 1'b1)) begin
			rx_invalid_parity_detected <= 1'b0;
		end else if(rx_state == RX_STOP) begin
			rx_invalid_parity_detected <= 1'b1;
		end
	end

	// parity generation
	always_comb begin
		tx_parity = ^tx_buf;
		rx_parity = ^rx_buf;
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
		rx_received_clear <= 1'b0;
		rx_invalid_parity_clear <= 1'b0;
		
		if(rst == 1'b0) begin
			data_rdata <= 32'h00000000;
			data_gnt <= 1'b0;
			data_rvalid <= 1'b0;
			tx_parity_enable <= 1'b0;
			rx_discard_policy <= 1'b0;
		end else begin
			data_gnt <= gnt_next;
			data_rvalid <= rvalid_next;

			if(data_req && decode) begin
				if(data_we) begin
					case(data_addr[11:2])
						0: begin // TX buffer
							if(data_be[0]) begin
								tx_buf <= data_wdata[7:0];
							end
						end
						1: begin // TX control
							if(data_be[0]) begin
								tx_parity_enable <= data_wdata[1];
								tx_start <= data_wdata[0];
							end
						end
						// 2 for baud rate control
						// 3 read only status
						4: begin // RX control & status
							if(data_be[0]) begin
								rx_received_clear <= data_wdata[0];
								rx_discard_policy <= data_wdata[1];
								rx_parity_enable <= data_wdata[2];
								rx_invalid_parity_clear <= data_wdata[3];
							end
						end
						// 5 read only RX buffer
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
						4: begin
							data_rdata <= {28'h0, rx_invalid_parity_detected, rx_parity_enable, rx_discard_policy, rx_received};
						end
						5: begin
							data_rdata <= {24'h0, rx_buf};
						end
					endcase // case (data_addr[11:2])
				end // else: !if(data_we)
			end // if (data_req && decode)
		end
	end
	
	assign irq = 1'b0;
	
endmodule // uart_controller

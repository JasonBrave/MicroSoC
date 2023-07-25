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
						input logic [11:0]	gpio_in,
						output logic [15:0]	intr_id,
						output logic		intr_signal,
						input logic			uart_rx,
						output logic		uart_tx);

	logic gpio_gnt, ram_gnt, timer32_gnt, intr_ctrl_gnt, uart_gnt;
	logic gpio_rvalid, ram_rvalid, timer32_rvalid, intr_ctrl_rvalid, uart_rvalid;
	logic [31:0] gpio_rdata, ram_rdata, timer32_rdata, intr_ctrl_rdata, uart_rdata;

	logic [255:0] irq_source;
	
	typedef enum logic [2:0] {
							  DEV_NONE,
							  DEV_GPIO,
							  DEV_RAM,
							  DEV_TIMER32,
							  DEV_INTR_CTRL,
							  DEV_UART_CTRL
							  } peripheral_t;
	
	peripheral_t	 arb_ctrl;

	always_ff @(posedge clk) begin
		if(rst == 1'b0) begin
			arb_ctrl <= DEV_NONE;
		end else begin
			if(gpio_gnt == 1'b1) begin
				arb_ctrl <= DEV_GPIO;
			end else if(ram_gnt == 1'b1) begin
				arb_ctrl <= DEV_RAM;
			end else if(timer32_gnt == 1'b1) begin
				arb_ctrl <= DEV_TIMER32;
			end else if(intr_ctrl_gnt == 1'b1) begin
				arb_ctrl <= DEV_INTR_CTRL;
			end else if(uart_gnt == 1'b1) begin
				arb_ctrl <= DEV_UART_CTRL;
			end
		end
	end	

	always_comb begin
		data_gnt = gpio_gnt | ram_gnt | timer32_gnt | intr_ctrl_gnt | uart_gnt;
		
		if(arb_ctrl == DEV_GPIO) begin
			data_rvalid = gpio_rvalid;
			data_rdata = gpio_rdata;
		end else if(arb_ctrl == DEV_RAM) begin
			data_rvalid = ram_rvalid;
			data_rdata = ram_rdata;
		end else if(arb_ctrl == DEV_TIMER32) begin
			data_rvalid = timer32_rvalid;
			data_rdata = timer32_rdata;
		end else if(arb_ctrl == DEV_INTR_CTRL) begin
			data_rvalid = intr_ctrl_rvalid;
			data_rdata = intr_ctrl_rdata;
		end else if(arb_ctrl == DEV_UART_CTRL) begin
			data_rvalid = uart_rvalid;
			data_rdata = uart_rdata;
		end else begin
			data_rvalid = 1'b0;
			data_rdata = 32'h00000000;
		end
		
	end
	
	gpio_controller u_gpio_controller(/*AUTOINST*/
									  // Outputs
									  .data_gnt			(gpio_gnt),
									  .data_rvalid		(gpio_rvalid),
									  .data_rdata		(gpio_rdata[31:0]),
									  .gpio_out			(gpio_out[17:0]),
									  .irq (irq_source[1]),
									  // Inputs
									  .clk				(clk),
									  .rst				(rst),
									  .data_req			(data_req),
									  .data_we			(data_we),
									  .data_be			(data_be[3:0]),
									  .data_addr		(data_addr[31:0]),
									  .data_wdata		(data_wdata[31:0]),
									  .gpio_in			(gpio_in[11:0]));
	
	ram u_ram(/*AUTOINST*/
			  // Outputs
			  .rvalid					(ram_rvalid),
			  .rdata					(ram_rdata[31:0]),
			  .gnt						(ram_gnt),
			  // Inputs
			  .clk						(clk),
			  .rst						(rst),
			  .addr						(data_addr[31:0]),
			  .we						(data_we),
			  .be						(data_be[3:0]),
			  .wdata					(data_wdata[31:0]),
			  .req						(data_req));

	timer32 u_timer32(/*AUTOINST*/
					  // Outputs
					  .data_gnt			(timer32_gnt),
					  .data_rvalid		(timer32_rvalid),
					  .data_rdata		(timer32_rdata[31:0]),
					  .irq (irq_source[0]),
					  // Inputs
					  .clk				(clk),
					  .rst				(rst),
					  .data_req			(data_req),
					  .data_we			(data_we),
					  .data_be			(data_be[3:0]),
					  .data_addr		(data_addr[31:0]),
					  .data_wdata		(data_wdata[31:0]));

	intr_controller u_intr_ctrl(/*AUTOINST*/
								// Outputs
								.data_gnt			(intr_ctrl_gnt),
								.data_rvalid		(intr_ctrl_rvalid),
								.data_rdata		(intr_ctrl_rdata[31:0]),
								// Inputs
								.clk				(clk),
								.rst				(rst),
								.data_req			(data_req),
								.data_we			(data_we),
								.data_be			(data_be[3:0]),
								.data_addr		(data_addr[31:0]),
								.data_wdata		(data_wdata[31:0]),
								.irq_source (irq_source),
								.intr_id (intr_id),
								.intr_signal (intr_signal));

	uart_controller u_uart_controller(/*AUTOINST*/
									  // Outputs
									  .data_gnt			(uart_gnt),
									  .data_rvalid		(uart_rvalid),
									  .data_rdata		(uart_rdata[31:0]),
									  .tx			(uart_tx),
									  .irq (irq_source[2]),
									  // Inputs
									  .clk				(clk),
									  .uart_clk (clk),
									  .rst				(rst),
									  .data_req			(data_req),
									  .data_we			(data_we),
									  .data_be			(data_be[3:0]),
									  .data_addr		(data_addr[31:0]),
									  .data_wdata		(data_wdata[31:0]),
									  .rx			(uart_rx));
	
	assign data_err = 1'b0;
	assign irq_source[255:3] = {253{1'b0}};
	
endmodule // peripheral_block

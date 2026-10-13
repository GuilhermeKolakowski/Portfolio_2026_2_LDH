`define STATE_CLOSED 	2'b00
`define STATE_CLOSING 	2'b01
`define STATE_OPEN 		2'b10
`define STATE_OPENING 	2'b11

module fsm_gate_ctrl(
	input rst,
	input clk,
	//Sinais de controle
	input user_button,
	input start_stop,
	input end_stop
	//Saídas
	output motor_power,
	output motor_direction
);

	reg [1:0] state;
	reg [1:0] nextState;

	//Motor de estados
	always @(posedge clk) begin
		if(rst) begin //reset síncrono
			state <= `STATE_CLOSED;
		end else begin
			state <= nextState;
		end
	end
	
	//Lógica de transição
	always @(*) begin
		case(state)
			`STATE_CLOSED: begin
				if (user_button = 1'b0) begin
					nextState = `STATE_CLOSED;
				end else begin
					nextState = `STATE_OPENING;
				end
			end
			`STATE_OPENING: begin
				if (end_stop = 1'b0) begin
					nextState = `STATE_OPENING;
				end else begin
					nextState = `STATE_OPEN;
				end
			end
			`STATE_OPEN: begin
				if (user_button = 1'b0) begin
					nextState = `STATE_OPEN;
				end else begin
					nextState = `STATE_CLOSING;
				end
			end
			`STATE_CLOSING: begin
				if (start_stop = 1'b0) begin
					nextState = `STATE_CLOSING;
				end else begin
					nextState = `STATE_CLOSED;
				end
			end
		endcase
	end
	
	//Lógica de saída
	//Método 1: dataflow
//	assign motor_power = (state==`STATE_CLOSING || state==`STATE_OPENING) ? 1'b1 : 1'b0;
//	assign motor_direction = (state==`STATE_OPENING) ? 1'b1 : 1'b0;
	//Método 2:
//	always @(*) begin
//		if(state==`STATE_CLOSING || state==`STATE_OPENING)
//			motor_power = 1;
//		else
//			motor_power = 0;
//		
//		if(state==`STATE_OPENING)
//			motor_direction = 1;
//		else
//			motor_direction = 0;
//	end
	//Método 3:
	always @(*) begin
		case(state)
			`STATE_OPENING: begin
				motor_power = 1;	
				motor_direction = 1;
			end
			`STATE_CLOSING: begin
				motor_power = 1;	
				motor_direction = 0;
			end
			default: begin
				motor_power = 0;
				motor_direction = 0;
			end
		endcase
	end
	
endmodule

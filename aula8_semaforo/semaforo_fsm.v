`define STATE_RED_LOAD			3'd0
`define STATE_RED 				3'd1
`define STATE_YELLOW_LOAD 		3'd2
`define STATE_YELLOW 			3'd3
`define STATE_GREEN_LOAD 		3'd4
`define STATE_GREEN 				3'd5


module semaforo_fsm(
	input rst,
	input clk,
	//Sinais de controle indo para o datapath
	output reg clear,
	output reg [1:0] sel,
	
	//Sinais de estado do datapath
	input top,
	//Saidas de controle para o dispositivo
	output	reg [2:0] lights
);

	reg [2:0] state;
	reg [2:0] nextState;
	
	//Motor de estados
	always @(posedge clk) begin
		if(rst)
			state <= `STATE_RED_LOAD;
		else
			state <= nextState;
	end
	//Logica do proximo estado
	always @(*) begin
		case (state)
			`STATE_RED_LOAD: nextState = `STATE_RED;
			`STATE_RED: begin
				if(top)
					nextState = `STATE_GREEN_LOAD;
				else
					nextState = `STATE_RED;
			 end
			`STATE_YELLOW_LOAD: nextState = `STATE_YELLOW;
			`STATE_YELLOW: begin
				if(top)
					nextState = `STATE_RED_LOAD;
				else
					nextState = `STATE_YELLOW;
			 end
			`STATE_GREEN_LOAD: nextState = `STATE_GREEN;
			`STATE_GREEN: begin
				if(top)
					nextState = `STATE_YELLOW_LOAD;
				else
					nextState = `STATE_GREEN;
			 end
		endcase
	end
	//Logica da saida
	always @(*) begin
		clear = 0;
		case(state)
			`STATE_RED_LOAD: begin
				clear = 1;
				lights = 3'b100;
				sel = 2'd0;
			end
			`STATE_RED: begin
				lights = 3'b100;
				sel = 2'd0;
			end
			`STATE_YELLOW_LOAD: begin
				clear = 1;
				lights = 3'b010;
				sel = 2'd1;
			end
			`STATE_YELLOW: begin
				lights = 3'b010;
				sel = 2'd1;
			end
			`STATE_GREEN_LOAD: begin
				clear = 1;
				lights = 3'b001;
				sel = 2'd2;
			end
			`STATE_GREEN: begin
				lights = 3'b001;
				sel = 2'd2;
			end
			
		endcase
	end


endmodule
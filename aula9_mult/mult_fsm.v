`define STATE_IDLE	2'b00
`define STATE_OP 		2'b01
`define STATE_DONE	2'b10

module mult_fsm (
	input rst,
	input clk,
	//Sinais de estado (vindo do datapath)
	input zero,
	//Sinais de entrada (do usuário)
	input start,
	//Sinais de controle (indo para o datapath)
	output reg load,
	output reg clear,
	//Sinais de saída (para o usuário)
	output reg done
);

	reg [1:0] state;
	reg [1:0] nextState;

	//Motor de estados
	always @(posedge clk) begin
		if(rst)
			state <= `STATE_IDLE;
		else
			state <= nextState;
	end

	//Lógica do próximo estado
	always @(*) begin
		case(state)
			`STATE_IDLE: begin		// espera o start
				if(start)
					nextState = `STATE_OP;
				else
					nextState = `STATE_IDLE;
			end
			`STATE_OP: begin		// soma e desloca ate o datapath avisar zero
				if(zero)
					nextState = `STATE_DONE;
				else
					nextState = `STATE_OP;
			end
			`STATE_DONE: begin		// resultado pronto, espera um novo start
				if(start)
					nextState = `STATE_OP;
				else
					nextState = `STATE_DONE;
			end
			default: nextState = `STATE_IDLE;
		endcase
	end

	//Sinais de saída
	always @(*) begin
		case(state)
			`STATE_IDLE: begin
				load  = start;	// no start: carrega a e b
				clear = start;	// no start: zera o acumulador
				done  = 0;
			end
			`STATE_OP: begin
				load  = 0;		// so desloca
				clear = 0;
				done  = 0;
			end
			`STATE_DONE: begin
				load  = start;	// novo start: carrega de novo
				clear = start;
				done  = 1;
			end
			default: begin
				load  = 0;
				clear = 0;
				done  = 0;
			end
		endcase
	end

endmodule

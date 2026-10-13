// Estados: cada um lembra quanto da sequencia "1101" ja foi recebido
`define STATE_S0		3'b000	// nada recebido ainda
`define STATE_S1		3'b001	// recebeu "1"
`define STATE_S11		3'b010	// recebeu "11"
`define STATE_S110	3'b011	// recebeu "110"
`define STATE_S1101	3'b100	// recebeu "1101" -> padrao encontrado

// Detecta a sequencia 1101 chegando bit a bit pela entrada data
module fsm_pattern_detector(
	input		rst,	// volta ao estado inicial
	input		clk,	// a cada borda de subida le um novo bit
	input		data,	// bit de entrada
	output	match	// 1 quando a sequencia foi detectada
);

	reg [2:0] state;		// estado atual (memoria da FSM)
	reg [2:0] nextState;	// proximo estado (calculado pela logica)

	// Registrador de estado: no clock, avanca para o proximo estado
	always @(posedge clk) begin
		if(rst)
			state <= `STATE_S0;
		else
			state <= nextState;
	end

	// Logica de transicao: decide o proximo estado conforme o bit recebido
	always @(*) begin
		case(state)
			`STATE_S0:		nextState = data ? `STATE_S1  	: `STATE_S0;		// 1 inicia a sequencia
			`STATE_S1:		nextState = data ? `STATE_S11 	: `STATE_S0;		// 1 continua, 0 recomeca
			`STATE_S11:		nextState = data ? `STATE_S11 	: `STATE_S110;	// 1 extra mantem "11"
			`STATE_S110:		nextState = data ? `STATE_S1101  : `STATE_S0; 	// 1 completa o padrao
			`STATE_S1101:	nextState = `STATE_S1101;//Trava no estado final, até um rst
			default: 		nextState = `STATE_S0;
		endcase
	end

	// Saida: acende so no estado final
	assign match = (state==`STATE_S1101);

endmodule

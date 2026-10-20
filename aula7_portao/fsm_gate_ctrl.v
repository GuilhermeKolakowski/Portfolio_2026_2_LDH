// Estados do portao
`define STATE_CLOSED 		3'b000	// fechado, motor parado
`define STATE_OPENING 		3'b001	// abrindo, motor ligado
`define STATE_HALF_OPEN 	3'b010	// parou no meio enquanto abria
`define STATE_OPEN 			3'b011	// aberto, motor parado
`define STATE_CLOSING 		3'b100	// fechando, motor ligado
`define STATE_HALF_CLOSING 	3'b101	// parou no meio enquanto fechava


module fsm_gate_ctrl(
	input rst,
	input clk,
	//Sinais de controle
	input user_button,	// botao do usuario: pede para abrir/fechar
	input start_stop,		// sensor: portao chegou ao fim (fechado)
	input end_stop,		// sensor: portao chegou ao fim (aberto)
	input timeout,		// contador: passaram 5 s com o portao aberto
	//Saídas
	output reg motor_power,		// 1 = motor ligado
	output reg motor_direction,	// 1 = abrindo, 0 = fechando
	output reg gate_open		// 1 = portao aberto (libera o contador de 5 s)
);

	reg [2:0] state;		// estado atual
	reg [2:0] nextState;	// proximo estado

	//Atualiza o estado a cada clock
	always @(posedge clk) begin
		if(rst) begin //reset síncrono
			state <= `STATE_CLOSED;
		end else begin
			state <= nextState;
		end
	end

	//Lógica de transição: quando trocar de estado
	always @(*) begin
		case(state)
			// Fechado e espera o botao para comecar a abrir
			`STATE_CLOSED: begin
				if (user_button == 1'b1) begin
					nextState = `STATE_OPENING;
				end else begin
					nextState = `STATE_CLOSED;
				end
			end
			// Continua ate o sensor de aberto, ou para no meio se apertar o botao
			`STATE_OPENING: begin
				if (end_stop == 1'b1) begin
					nextState = `STATE_OPEN;
				end else if (user_button == 1'b1) begin
					nextState = `STATE_HALF_OPEN;
				end else begin
					nextState = `STATE_OPENING;
				end
			end
			// Parado no meio e apertou de novo, volta fechando
			`STATE_HALF_OPEN: begin
				if (user_button == 1'b1) begin
					nextState = `STATE_CLOSING;
				end else begin
					nextState = `STATE_HALF_OPEN;
				end
			end
			// Aberto e fecha quando apertar o botao ou quando passarem 5 s
			`STATE_OPEN: begin
				if (user_button == 1'b1) begin
					nextState = `STATE_CLOSING;
				end else if (timeout == 1'b1) begin
					nextState = `STATE_CLOSING;
				end else begin
					nextState = `STATE_OPEN;
				end
			end
			// Continua fechando ate o sensor de fechado, ou para no meio se apertar o botao
			`STATE_CLOSING: begin
				if (start_stop == 1'b1) begin
					nextState = `STATE_CLOSED;
				end else if (user_button == 1'b1) begin
					nextState = `STATE_HALF_CLOSING;
				end else begin
					nextState = `STATE_CLOSING;
				end
			end
			// Parado no meio e se apertou de novo volta abrindo
			`STATE_HALF_CLOSING: begin
				if (user_button == 1'b1) begin
					nextState = `STATE_OPENING;
				end else begin
					nextState = `STATE_HALF_CLOSING;
				end
			end
			default: nextState = `STATE_CLOSED;
		endcase
	end

	always @(*) begin
		case(state)
			`STATE_OPENING: begin	// liga motor para abrir
				motor_power = 1;
				motor_direction = 1;
				gate_open = 0;
			end
			`STATE_CLOSING: begin	// liga motor para fechar
				motor_power = 1;
				motor_direction = 0;
				gate_open = 0;
			end
			`STATE_OPEN: begin		// parado e aberto: conta os 5 s
				motor_power = 0;
				motor_direction = 0;
				gate_open = 1;
			end
			default: begin			// parado (fechado ou no meio)
				motor_power = 0;
				motor_direction = 0;
				gate_open = 0;
			end
		endcase
	end

endmodule

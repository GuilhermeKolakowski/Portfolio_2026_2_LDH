// Conta quantos segundos o portao esta aberto e avisa a FSM quando chega em 5
module timer_5s(
	input rst,
	input clk,			// clock de 1s
	input gate_open,	// 1 enquanto o portao esta ABERTO
	output reg timeout	// 1 quando passaram 5 s
);

	reg [2:0] count;	// segundos contados (0 a 5)

	always @(posedge clk or posedge rst) begin
		if(rst)
			count <= 0;
		else if(gate_open == 0)
			count <= 0;				// portao saiu de ABERTO: zera a contagem
		else if(count < 5)
			count <= count + 1;		// aberto: conta mais um segundo
	end

	always @(*) begin
		if(count == 5)
			timeout = 1;
		else
			timeout = 0;
	end

endmodule

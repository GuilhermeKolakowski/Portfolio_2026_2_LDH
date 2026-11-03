module mult_datapath (
	input clk,
	input [3:0] a,
	input [3:0] b,
	output [7:0] m,
	//Sinais de controle
	input load,
	input clear,
	//Sinais de estado
	output zero
);

	reg [7:0] acc;
	reg [7:0] reg_a;	// 8 bits: o a e deslocado para a esquerda
	reg [3:0] reg_b;

	wire [7:0] shift_a;
	wire [3:0] shift_b;

	wire [7:0] sel_a;
	wire [3:0] sel_b;

	wire [7:0] s_out;
	wire acc_enable;

	//Caminho do a: carrega a entrada ou desloca para a esquerda
	assign shift_a = reg_a << 1;
	assign sel_a = load ? {4'd0, a} : shift_a;	// mux: load=1 entrada, load=0 deslocado

	always @(posedge clk) begin
		reg_a <= sel_a;
	end

	//Caminho do b: carrega a entrada ou desloca para a direita
	assign shift_b = reg_b >> 1;
	assign sel_b = load ? b : shift_b;	// mux: load=1 entrada, load=0 deslocado

	always @(posedge clk) begin
		reg_b <= sel_b;
	end

	//LSB do b: quando for 1, soma o a no acumulador
	assign acc_enable = reg_b[0];

	//zero: acabou quando o a ou o b chegou a zero
	assign zero = (reg_a == 0) | (reg_b == 0);

	//Somador: acc + a (7 bits bastam, o resultado de 8 bits sai em s_out)
	ripple_carry_adder #(.BITS(7)) adder (
		.a(reg_a[6:0]),
		.b(acc[6:0]),
		.s(s_out)
	);

	//Acumulador
	always @(posedge clk) begin
		if(clear) begin
			acc <= 0;
		end else begin
			if(acc_enable) begin
				acc <= s_out;
			end
		end
	end

	assign m = acc;

endmodule

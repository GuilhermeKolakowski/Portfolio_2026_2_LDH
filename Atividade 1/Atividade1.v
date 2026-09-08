module Atividade1(
	input  wire [9:0] SW,
	output wire [7:0] HEX0,
	output wire [7:0] HEX3,
	output wire [7:0] HEX5
);

	wire [4:0] soma;

	//SW[3:0] -> HEX0
	bin7seg u1(
		.bin(SW[3:0]),
		.hex(HEX0)
	);

	//SW[7:4] -> HEX3
	bin7seg u2(
		.bin(SW[7:4]),
		.hex(HEX3)
	);

	//Soma dos dois numeros (SW[3:0] + SW[7:4])
	adder_4b u3(
		.a(SW[3:0]),
		.b(SW[7:4]),
		.s(soma)
	);

	//Resultado da soma -> HEX5
	bin7seg u4(
		.bin(soma[3:0]),
		.hex(HEX5)
	);

endmodule

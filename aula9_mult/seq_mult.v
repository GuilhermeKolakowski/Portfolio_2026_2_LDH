module seq_mult (
	input rst,
	input clk,

	input		[3:0] a,
	input		[3:0] b,
	input		start,
	output 	[7:0] m,
	output	done
);

	wire load, clear, zero;

	mult_fsm fsm (
		.rst(rst),
		.clk(clk),
		.zero(zero),
		.start(start),
		//Sinais de controle
		.load(load),
		.clear(clear),
		.done(done)
	);

	mult_datapath dp (
		.clk(clk),
		//Dados
		.a(a),
		.b(b),
		.m(m),
		//Sinais de controle
		.load(load),
		.clear(clear),
		.zero(zero)
	);

endmodule

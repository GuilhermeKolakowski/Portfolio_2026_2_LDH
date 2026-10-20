module semaforo(
	input rst,
	input clk_50M,
	output [2:0] lights
);

	wire clear;
	wire top;
	wire [1:0] sel;
	wire clk_1s;

	clk_1s u0(
		.rst(rst),
		.clk_50M(clk_50M),
		.clk_out(clk_1s)
	);

	semaforo_fsm u1(
		.rst(rst),
		.clk(clk_1s),
		.clear(clear),
		.sel(sel),
		.top(top),
		.lights(lights)

	);

	semaforo_datapath u2(
		.clk(clk_1s),
		.clear(clear),
		.sel(sel),
		.top(top)
	);



endmodule

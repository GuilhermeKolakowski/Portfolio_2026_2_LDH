`timescale 10ns/10ns

module tb_clk_1s;

	reg rst;
	reg clk_50M;
	wire clk_out;

	clk_1s dut (
		.rst(rst),
		.clk_50M(clk_50M),
		.clk_out(clk_out)
	);

	always #1 clk_50M = ~clk_50M; //cria clock de 50MHz
	
	initial begin
		clk_50M = 0;
		rst = 1;
		#2
		rst = 0;
		#100000000
		$finish;
	end
	
endmodule

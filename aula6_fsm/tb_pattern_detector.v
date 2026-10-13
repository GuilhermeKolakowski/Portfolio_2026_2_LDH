`timescale 1ps/1ps

// Testbench: injeta uma sequencia de bits no detector e observa match
module tb_pattern_detector;

	reg	rst;
	reg	clk;
	reg	data;
	wire	match;

	// Instancia o circuito sendo testado (DUT)
	fsm_pattern_detector dut (
		.rst(rst), .clk(clk), .data(data), .match(match)
	);

	// Gera o clock: inverte a cada 1 unidade de tempo
	always #1 clk=~clk;

	// Estimulos: um bit novo a cada periodo de clock (2 unidades)
	initial begin
		clk = 0;
		rst = 1;
		data = 0;
		#2
		rst = 0;
		#2 data=0;
		#2 data=0;
		#2 data=1;	// inicio de "1101"
		#2 data=0;
		#2 data=1;
		#2 data=1;
		#2 data=0;
		#2 data=1;	// aqui completa "1101" -> match deve ir a 1
		#2 data=0;
		#2 data=0;
		$finish;		// encerra a simulacao
	end

endmodule

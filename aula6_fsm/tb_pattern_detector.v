`timescale 1ps/1ps

module tb_pattern_detector;

	reg	rst;
	reg	clk;
	reg	data;
	wire	match;

	fsm_pattern_detector dut (
		.rst(rst), .clk(clk), .data(data), .match(match)
	);
	
	always #1 clk=~clk;
	
	initial begin
		#1
		#2 data=0;
		#2 data=0;
		#2 data=1;
		#2 data=0;
		#2 data=1;
		#2 data=1;
		#2 data=0;
		#2 data=1;
		#2 data=0;
		#2 data=0;
		#finish
	end
	
endmodule

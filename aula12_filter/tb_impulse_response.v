`timescale 100ns/100ns

module tb_impulse_responde;
	
	reg rst, clk;
	reg [11:0] x;
	wire [11:0] y;	//saida do DUT: tem que ser wire
	
	always #5 clk = ~clk; //clock 1MHz
	
	movavg_filter duty(
		.rst(rst), .clk(clk), .x(x), .y(y)
	);
	
	//Stimuli
	initial begin
		clk = 0;
		rst = 1;
		#10; //1 clock cycle
		rst=0;
		x = 12'b100000000000;
		#10 
		x = 12'd0;
		#100
		$finish;
	end
	
endmodule
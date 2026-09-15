//comportamental

//mux padrao inicial
module mux2(
	input a,
	input b,
	input sel,
	output reg y


);
	always @(*) begin
		if(sel) y = b;
		else	  y = a;
	end


endmodule

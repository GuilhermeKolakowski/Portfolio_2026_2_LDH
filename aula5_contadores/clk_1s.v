module clk_1s (
	input rst,
	input clk_50M,
	output reg clk_out
);

	reg [24:0] count; //33554431 > 25M

	always @(posedge clk_50M) begin
		if(rst) begin
			count   <= 0;
			clk_out <= 0;
		end else begin
			count <= count + 1;
			if(count == 25'd25000000) begin
				clk_out <= ~clk_out;  //Alterna clock_out
			end
		end
	end
	
endmodule

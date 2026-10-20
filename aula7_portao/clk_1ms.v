// Divisor de clock: 50 MHz -> 1 kHz (periodo de 1 ms)
module clk_1ms (
	input rst,
	input clk_50M,
	output reg clk_out
);

	reg [14:0] count; //32767 > 25000

	always @(posedge clk_50M) begin
		if(rst) begin
			count   <= 0;
			clk_out <= 0;
		end else if(count == 15'd24999) begin	// meio milissegundo
			count   <= 0;				// zera a contagem
			clk_out <= ~clk_out;		// alterna clk_out
		end else begin
			count <= count + 1;
		end
	end

endmodule

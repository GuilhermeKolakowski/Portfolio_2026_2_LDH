module counter(
	input rst,
	input clk,
	output [4:0] cnt_out
);

	
	reg [4:0] cnt;
	
	always @(posedge clk) begin
		if(rst)
			cnt<= 0;
		else
			cnt <= cnt+1;
	end

	assign cnt_out = cnt;
	
endmodule
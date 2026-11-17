module bw2_filter (
	input rst,
	input clk,
	input signed [11:0] x,
	output reg signed [11:0] y
	
);
	
	localparam signed [15:0] B0 = 16'sd1372, 
									 B1 = 16'sd2744,
									 B2 = 16'sd1372,
									 A1 = -16'sd16899,
									 A2 = 16'sd6002;

	reg [11:0] x1, x2;
	reg [11:0] y1, y2;
	
	always @(posedge clk) begin
		if(rst) begin
			x1 <= 0;
			x2 <= 0;
			y1 <= 0;
			y2 <= 0;
		end else begin
			x1 <= x;
			x2 <= x1;
			y1 <= y;
			y2 <= y1;
			y <= (B0 * x + B1 * x1 + B2 * x2 - A1 * y1 - A2 * y2) >> 14;
		end
	end

endmodule
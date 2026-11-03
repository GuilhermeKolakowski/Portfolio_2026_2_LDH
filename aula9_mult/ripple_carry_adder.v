module ripple_carry_adder 
#(
	parameter BITS=7
)
(
	input 	[BITS-1:0] a,
	input 	[BITS-1:0]	b,
	output 	[BITS:0] s
);

	wire [BITS:0] c;

	genvar i;
	generate
		for(i=0; i<BITS; i=i+1) begin : fa
			full_adder a1 (
				.a(a[i]), .b(b[i]), .ci(c[i]), .s(s[i]), .co(c[i+1])
			);
		end
	endgenerate

	assign c[0] = 1'b0;
	assign s[BITS] = c[BITS];

endmodule

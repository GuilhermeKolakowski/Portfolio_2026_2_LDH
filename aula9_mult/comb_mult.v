module comb_mult(
	input  [3:0] a,
	input  [3:0] b,
	output [7:0] m
);

	wire [3:0] aw1;
	wire [4:0] aw2;
	wire [5:0] aw3;
	wire [6:0] aw4;
	wire [5:0] sw1;
	wire [6:0] sw2;
	wire [7:0] sw3;

	ripple_carry_adder #(.BITS(5)) s1 (
		.a({1'd0, aw1}),
		.b(aw2),
		.s(sw1)
	);
	
	ripple_carry_adder #(.BITS(6)) s2 (
		.a(sw1),
		.b(aw3),
		.s(sw2)
	);

	ripple_carry_adder #(.BITS(7)) s3(
		.a(sw2),
		.b(aw4),
		.s(sw3)
	);

	assign aw1 = b[0] ? a : 4'd0;
	assign aw2 = b[1] ? {a[3:0],1'd0} : 5'd0;
	assign aw3 = b[2] ? {a[3:0],2'd0} : 6'd0;
	assign aw4 = b[3] ? {a[3:0],3'd0} : 7'd0;
	
	assign m = sw3;
	
endmodule

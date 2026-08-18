module somador(
	input a,
	input b,
	input ci,
	output co
);

wire w1, w2, w3;

porta_and U1(
	.a(ci),
	.b(a),
	.y(w1)
);

porta_and U2(
	.a(a),
	.b(b),
	.y(w2)
);
porta_and U3(
	.a(b),
	.b(ci),
	.y(w3)
);

porta_or U4(
	.a(w1),
	.b(w2),
	.c(w3),
	.y(co)
);
endmodule

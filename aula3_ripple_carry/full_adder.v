module full_adder (
	input		a,
	input		b,
	input		ci,
	output	s,
	output	co
);

	//Modelagem dataflow
	assign s = (a & b & ci) | (~a & b & ~ci) | (~a & ~b & ci) | (a & ~b & ~ci);
	assign co = (a & b) | (ci & b) | (ci & a);

endmodule

`timescale 1ns/1ns
module full_adder (
	input		a,
	input		b,
	input		ci,
	output	s,
	output	co
);

	//Modelagem dataflow
	//assign s = (a & b & ci) | (~a & b & ~ci) | (~a & ~b & ci) | (a & ~b & ~ci);
	//assign co = (a & b) | (ci & b) | (ci & a);
	
	//Modelagem estrutural
	//Saida de carry out
	wire w1, w2, w3;
	and #20 u1(w1, a, b);
	and #20 u2(w2, ci, a);
	and #20 u3(w3, ci, b);
	or #30 u4(co, w1, w2, w3);
	
	//Saida de soma
	wire na, nb, nci;
	not #10 u5(na, a);
	not #10 u6(nb, b);
	not #10 u7(nci, ci);
	
	wire w4, w5, w6, w7;
	and #30 u8 (w4, a, b, ci);
	and #30 u9 (w5, na, b, nci);
	and #30 u10(w6, na, nb, ci);
	and #30 u11 (w7, a, nb, nci);
	or #40 u12 (s, w4, w5, w6, w7);
	
endmodule

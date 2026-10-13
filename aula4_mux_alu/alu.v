//Definições de constantes no Verilog
`define ALU_OP_OR		2'b00
`define ALU_OP_AND	2'b01
`define ALU_OP_XOR	2'b10

module alu( // Unidade Lógica e Aritmética
	input a,
	input b,
	input [1:0] op_sel,
	output reg y
);

	always @(*) begin
		case(op_sel)
			`ALU_OP_OR:		y = a | b;
			`ALU_OP_AND:	y = a & b;
			`ALU_OP_XOR: 	y = a ^ b;
			default: 		y = 0;
		endcase
	end

endmodule
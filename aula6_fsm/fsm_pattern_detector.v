`define STATE_S0		3'b000
`define STATE_S1		3'b001
`define STATE_S11		3'b010
`define STATE_S110	3'b011
`define STATE_S1101	3'b100

module fsm_pattern_detector(
	input		rst,
	input		clk,
	input		data,
	output	match
);

	reg [2:0] state;
	reg [2:0] nextState;
	
	always @(posedge clk) begin
		if(rst)
			state <= `STATE_S0;
		else
			state <= nextState;
	end

	always @(*) begin
		case(state)
			STATE_S0:		nextState = data ? `STATE_S1  	: `STATE_S0;
			STATE_S1:		nextState = data ? `STATE_S11 	: `STATE_S0;
			STATE_S11:		nextState = data ? `STATE_S11 	: `STATE_S110;
			STATE_S110:		nextState = data ? `STATE_S1101  : `STATE_S0; 
			STATE_S1101:	nextState = `STATE_S1101;//Trava no estado final, até um rst
			default: 		nextState = `STATE_S0;
		endcase
	end
	
	assign match = (state==STATE_S1101);
	
endmodule

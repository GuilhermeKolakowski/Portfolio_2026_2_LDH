module gate_counter(
	input rst,
	input clk,			// clock de 1s
	input enable,		// motor ligado
	input dir,			// 1 abrindo e 0 fechando
	output reg start_stop,	// portao fechado
	output reg end_stop,	// portao aberto
	output reg [9:0] led_bar
);

	reg [3:0] count;		
	reg [3:0] nextCount;	


	always @(posedge clk or posedge rst) begin
		if(rst)
			count <= 0;
		else
			count <= nextCount;
	end

	//Lógica do próximo estado
	always @(*) begin
		nextCount = count;		// se nada mudar, fica onde esta
		if(enable) begin
			if(dir == 1 && count < 10)
				nextCount = count + 1;	// abrindo
			else if(dir == 0 && count > 0)
				nextCount = count - 1;	// fechando
		end
	end

	//Lógica de saída
	always @(*) begin
		start_stop = (count == 0);
		end_stop   = (count == 10);

		case(count)
			0:  led_bar = 10'b0000000000;
			1:  led_bar = 10'b0000000001;
			2:  led_bar = 10'b0000000011;
			3:  led_bar = 10'b0000000111;
			4:  led_bar = 10'b0000001111;
			5:  led_bar = 10'b0000011111;
			6:  led_bar = 10'b0000111111;
			7:  led_bar = 10'b0001111111;
			8:  led_bar = 10'b0011111111;
			9:  led_bar = 10'b0111111111;
			10: led_bar = 10'b1111111111;
			default: led_bar = 10'b0000000000;
		endcase
	end

endmodule

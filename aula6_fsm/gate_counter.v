module gate_counter(
	input rst,
	input clk,			// clock de 1s
	input enable,		// motor ligado
	input dir,			// 1 abrindo e 0 fechando
	output start_stop,	// portao fechado
	output end_stop,	// portao aberto
	output reg [9:0] led_bar
);

	// A cada 1 segundo o portao anda uma posicao
	// (reset assincrono porque o clock de 1s fica parado durante o reset)
	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			led_bar <= 0;
		end
		else if(enable)
		begin
			if(dir)
			begin	// abrindo: acende mais um LED
				case(led_bar)
					10'b0000000000: led_bar <= 10'b0000000001;
					10'b0000000001: led_bar <= 10'b0000000011;
					10'b0000000011: led_bar <= 10'b0000000111;
					10'b0000000111: led_bar <= 10'b0000001111;
					10'b0000001111: led_bar <= 10'b0000011111;
					10'b0000011111: led_bar <= 10'b0000111111;
					10'b0000111111: led_bar <= 10'b0001111111;
					10'b0001111111: led_bar <= 10'b0011111111;
					10'b0011111111: led_bar <= 10'b0111111111;
					10'b0111111111: led_bar <= 10'b1111111111;
				endcase
			end
			else
			begin	// fechando: apaga um LED
				case(led_bar)
					10'b1111111111: led_bar <= 10'b0111111111;
					10'b0111111111: led_bar <= 10'b0011111111;
					10'b0011111111: led_bar <= 10'b0001111111;
					10'b0001111111: led_bar <= 10'b0000111111;
					10'b0000111111: led_bar <= 10'b0000011111;
					10'b0000011111: led_bar <= 10'b0000001111;
					10'b0000001111: led_bar <= 10'b0000000111;
					10'b0000000111: led_bar <= 10'b0000000011;
					10'b0000000011: led_bar <= 10'b0000000001;
					10'b0000000001: led_bar <= 10'b0000000000;
				endcase
			end		
		end		
	end		

	assign start_stop = (led_bar == 10'b0000000000);
	assign end_stop   = (led_bar == 10'b1111111111);

endmodule

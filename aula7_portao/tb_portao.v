`timescale 1us/1us

// Testbench: portao abre, fica aberto e fecha sozinho depois de 5 s
module tb_portao;

	reg	rst;
	reg	clk_1ms;
	reg	clk_1s;
	reg	button;

	wire press, power, dir, start_stop, end_stop;
	wire gate_open, timeout;
	wire [9:0] led_bar;

	// Mesmas ligacoes do DE10_LITE_Golden_Top, sem os divisores
	edge_detector botao (
		.clk(clk_1ms), .rst(rst), .button(button),
		.but_press(press), .but_release()
	);

	fsm_gate_ctrl fsm (
		.rst(rst), .clk(clk_1ms), .user_button(press),
		.start_stop(start_stop), .end_stop(end_stop), .timeout(timeout),
		.motor_power(power), .motor_direction(dir), .gate_open(gate_open)
	);

	gate_counter portao (
		.rst(rst), .clk(clk_1s), .enable(power), .dir(dir),
		.start_stop(start_stop), .end_stop(end_stop), .led_bar(led_bar)
	);

	timer_5s tempo (
		.rst(rst), .clk(clk_1s), .gate_open(gate_open), .timeout(timeout)
	);

	// Gera os clocks: 1 ms (inverte a cada 500 us) e 1 s (inverte a cada 500000 us)
	always #500 clk_1ms = ~clk_1ms;
	always #500000 clk_1s = ~clk_1s;

	// Mostra no console cada vez que o estado da FSM muda
	always @(fsm.state)
		$display("t = %5.2f s  estado = %0d  leds = %b  timeout = %b", $realtime/1000000, fsm.state, led_bar, timeout);

	// Estimulos
	initial begin
		clk_1ms = 0;
		clk_1s = 0;
		rst = 1;
		button = 0;
		#2000
		rst = 0;
		#2000
		button = 1;		// aperta o botao: comeca a abrir
		#100000
		button = 0;		// solta o botao (segurou 100 ms)
		#30000000		// espera 30 s: abre (10 s), fica aberto (5 s) e fecha sozinho (10 s)
		$finish;		// encerra a simulacao
	end

endmodule

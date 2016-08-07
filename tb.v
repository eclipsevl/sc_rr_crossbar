`include "timing_inc.vh"

module tb;

reg r_clk 	= 1'b0;
reg r_resb 	= 1'b0;

initial forever #(`CLK_PERIOD/2) r_clk <= ~r_clk;

initial begin
	r_clk 	<= 1'b0;
	r_resb	<= 1'b0;
	
	#(10*`CLK_PERIOD)
	r_resb	<= 1'b0;
	#(10*`CLK_PERIOD)
	r_resb	<= 1'b1;
	$display("%t: reset released. Waiting for finish time.", $time);
	
	#(1000*`CLK_PERIOD)
	$display("%t: end of test", $time);
	$finish;
end	

sc_sys_core xi_sys_core
	(
		// general io
		.i_clk				(r_clk),
		.i_resetb			(r_resb)
	);

endmodule
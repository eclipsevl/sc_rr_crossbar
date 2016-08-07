`include "timing_inc.vh"

module sc_rr_crossbar_arbiter_atom
(
	// general io
	input 			i_clk,
	input 			i_resetb,
		
	// master's request 
	input	[1:0]   i_ms_req,
		
	// slave's response
	input 			i_sl_ack,
		
	// arbiter outputs
	output 	[1:0] 	o_ms_en
);

reg	[1:0]	r_ms_en;
reg			r_sl_busy;
reg	[1:0]	r_grant_hist;


always @(posedge i_clk or negedge i_resetb) begin
	if(~i_resetb) begin
		r_ms_en			<= 2'b00;
		
		r_sl_busy		<= 1'b0;
		
		r_grant_hist	<= 2'b00;
	end
	else
	begin
		// slave 0 access
		if(|i_ms_req) begin
			if(~r_sl_busy) begin
				// access arbitration
				if(i_ms_req[0] & ~r_grant_hist[0]) begin // m0 priority, m1->wait
					r_grant_hist[1:0] 		<= 2'b01;
					r_sl_busy				<= 1'b1;
					r_ms_en[1:0]			<= 2'b01;
				end else if(i_ms_req[1] & r_grant_hist[0]) begin // m1 priority, m0->wait
					r_grant_hist[1:0] 		<= 2'b10;
					r_sl_busy				<= 1'b1;
					r_ms_en[1:0]			<= 2'b10;					
				end else if(i_ms_req[0]) begin // regular access m0->s
					r_grant_hist[1:0] 		<= 2'b01;
					r_sl_busy				<= 1'b1;
					r_ms_en	[1:0]			<= 2'b01;
				end else if(i_ms_req[1]) begin // regular access m1->s
					r_grant_hist[1:0] 		<= 2'b10;
					r_sl_busy				<= 1'b1;
					r_ms_en[1:0]			<= 2'b10;			
				end
			end begin
				// transaction terminating
				if(i_sl_ack) begin
					r_sl_busy 				<= 1'b0;
					r_ms_en					<= 2'b00;						
				end
			end
		end
		// transaction abort
		else begin 
			r_sl_busy 				<= 1'b0;
			r_ms_en					<= 2'b00;		
		end
	end 
end

assign o_ms_en = r_ms_en;

endmodule
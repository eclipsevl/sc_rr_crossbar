// round-robin cross bar
// Vladislav Knyazkov, Aug 2016
// contact@eclipsevl.org

`include "timing_inc.vh"

module sc_rr_crossbar_arbiter_atom
(
    // general io
    input           i_clk,
    input           i_resetb,
        
    // master's request 
    input   [1:0]   i_ms_req,
        
    // slave's response
    input           i_sl_ack,
        
    // arbiter outputs
    output  [1:0]   o_ms_en
);

reg [1:0]   r_grant_hist;

always @(posedge i_clk or negedge i_resetb) begin
    if(~i_resetb) begin
        r_grant_hist    <= 2'b01;
    end
    else
    begin
		if(i_ms_req&r_grant_hist == 2'b00)
			r_grant_hist <= o_ms_en;			
	end 
end

assign o_ms_en = &i_ms_req ? ~r_grant_hist : i_ms_req;

endmodule
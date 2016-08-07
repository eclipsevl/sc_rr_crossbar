// round-robin cross bar
// Vladislav Knyazkov, Aug 2016
// contact@eclipsevl.org

`include "timing_inc.vh"

module sc_rr_crossbar_arbiter
(
    // general io
    input           i_clk,
    input           i_resetb,
        
    // master's request 
    input   [31:0]  i_ms0_addr,
    input           i_ms0_req,
        
    input   [31:0]  i_ms1_addr,
    input           i_ms1_req,
        
    // slave's response
    input           i_sl0_ack,
    input           i_sl1_ack,
        
    // arbiter outputs
    output          o_m0s0_en,
    output          o_m0s1_en,
    output          o_m1s0_en,
    output          o_m1s1_en,
        
    // status
    output          o_m0_wait,
    output          o_m1_wait
);

wire    [1:0]   w_ms_2_sl0_en;
wire    [1:0]   w_ms_2_sl1_en;

reg             r_m0_wait;
reg             r_m1_wait;

// slave 0 arbiter
sc_rr_crossbar_arbiter_atom 
    xi_sl0_arb_atom
    (
        // general io
        .i_clk              (i_clk),
        .i_resetb           (i_resetb),
            
        // master's request    ms1                                  ms0
        .i_ms_req           ({i_ms1_req & i_ms1_addr[31] == 1'b0, i_ms0_req & i_ms0_addr[31] == 1'b0}),
            
        // slave's response
        .i_sl_ack           (i_sl0_ack),
            
        // arbiter outputs
        .o_ms_en            (w_ms_2_sl0_en)
    );

// slave 1 arbiter  
sc_rr_crossbar_arbiter_atom 
    xi_sl1_arb_atom
    (
        // general io
        .i_clk              (i_clk),
        .i_resetb           (i_resetb),
            
        // master's request    ms1                                  ms0
        .i_ms_req           ({i_ms1_req & i_ms1_addr[31] == 1'b1, i_ms0_req & i_ms0_addr[31] == 1'b1}),
            
        // slave's response
        .i_sl_ack           (i_sl1_ack),
            
        // arbiter outputs
        .o_ms_en            (w_ms_2_sl1_en)
    );
    
always @(posedge i_clk or negedge i_resetb) begin
    if(~i_resetb) begin
        r_m0_wait           <= 1'b0;
        r_m1_wait           <= 1'b0;
    end
    else
    begin
        r_m0_wait <= ~(o_m0s0_en | o_m0s1_en) & i_ms0_req;
        r_m1_wait <= ~(o_m1s0_en | o_m1s1_en) & i_ms1_req;
    end 
end

assign o_m0s0_en = w_ms_2_sl0_en[0];
assign o_m1s0_en = w_ms_2_sl0_en[1];
assign o_m0s1_en = w_ms_2_sl1_en[0];
assign o_m1s1_en = w_ms_2_sl1_en[1];

assign o_m0_wait = r_m0_wait; 
assign o_m1_wait = r_m1_wait; 

endmodule

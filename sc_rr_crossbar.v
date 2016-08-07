// round-robin cross bar testbench
// Vladislav Knyazkov, Aug 2016
// contact@eclipsevl.org

`include "timing_inc.vh"

module sc_rr_crossbar
(
    // general io
    input           i_clk,
    input           i_resetb,
    
    // master 0 interface
    input           i_master_0_req,
    input  [31:0]   i_master_0_addr,
    input           i_master_0_cmd,
    input  [31:0]   i_master_0_wdata,
    output          o_master_0_ack,
    output [31:0]   o_master_0_rdata,
    
    // master 1 interface
    input           i_master_1_req,
    input  [31:0]   i_master_1_addr,
    input           i_master_1_cmd,
    input  [31:0]   i_master_1_wdata,
    output          o_master_1_ack,
    output [31:0]   o_master_1_rdata,
    
    // slave 0 interface
    output          o_slave_0_req,
    output  [31:0]  o_slave_0_addr,
    output          o_slave_0_cmd,
    output  [31:0]  o_slave_0_wdata,
    input           i_slave_0_ack,
    input   [31:0]  i_slave_0_rdata,
    
    // slave 1 interface
    output          o_slave_1_req,
    output  [31:0]  o_slave_1_addr,
    output          o_slave_1_cmd,
    output  [31:0]  o_slave_1_wdata,
    input           i_slave_1_ack,
    input   [31:0]  i_slave_1_rdata
);

wire w_m0s0_enable;
wire w_m0s1_enable;
wire w_m1s0_enable;
wire w_m1s1_enable;

// crossbar arbiter
sc_rr_crossbar_arbiter xi_arbiter
    (
        // general io
        .i_clk      (i_clk),
        .i_resetb   (i_resetb),
        
        // master's request 
        .i_ms0_addr (i_master_0_addr),
        .i_ms0_req  (i_master_0_req),
        
        .i_ms1_addr (i_master_1_addr),
        .i_ms1_req  (i_master_1_req),
        
        // slave's response
        .i_sl0_ack  (i_slave_0_ack),
        .i_sl1_ack  (i_slave_1_ack),
        
        // arbiter outputs
        .o_m0s0_en  (w_m0s0_enable),
        .o_m0s1_en  (w_m0s1_enable),
        .o_m1s0_en  (w_m1s0_enable),
        .o_m1s1_en  (w_m1s1_enable),
        
        // status
        .o_m0_wait  (),
        .o_m1_wait  ()
    );

// crossbar matrix
sc_rr_crossbar_tristate_buffer xi_m0s0_buf
    (
        .i_enable   (w_m0s0_enable),
        
        .o_req      (o_slave_0_req),
        .o_addr     (o_slave_0_addr),
        .o_cmd      (o_slave_0_cmd),
        .o_wdata    (o_slave_0_wdata),
        .i_ack      (i_slave_0_ack),
        .i_rdata    (i_slave_0_rdata),
        
        .i_req      (i_master_0_req),
        .i_addr     (i_master_0_addr),
        .i_cmd      (i_master_0_cmd),
        .i_wdata    (i_master_0_wdata),
        .o_ack      (o_master_0_ack),
        .o_rdata    (o_master_0_rdata)
    );
    
sc_rr_crossbar_tristate_buffer xi_m0s1_buf
    (
        .i_enable   (w_m0s1_enable),
        
        .o_req      (o_slave_1_req),
        .o_addr     (o_slave_1_addr),
        .o_cmd      (o_slave_1_cmd),
        .o_wdata    (o_slave_1_wdata),
        .i_ack      (i_slave_1_ack),
        .i_rdata    (i_slave_1_rdata),
        
        .i_req      (i_master_0_req),
        .i_addr     (i_master_0_addr),
        .i_cmd      (i_master_0_cmd),
        .i_wdata    (i_master_0_wdata),
        .o_ack      (o_master_0_ack),
        .o_rdata    (o_master_0_rdata)
    );

sc_rr_crossbar_tristate_buffer xi_m1s0_buf
    (
        .i_enable   (w_m1s0_enable),
        
        .o_req      (o_slave_0_req),
        .o_addr     (o_slave_0_addr),
        .o_cmd      (o_slave_0_cmd),
        .o_wdata    (o_slave_0_wdata),
        .i_ack      (i_slave_0_ack),
        .i_rdata    (i_slave_0_rdata),
        
        .i_req      (i_master_1_req),
        .i_addr     (i_master_1_addr),
        .i_cmd      (i_master_1_cmd),
        .i_wdata    (i_master_1_wdata),
        .o_ack      (o_master_1_ack),
        .o_rdata    (o_master_1_rdata)
    );
    
sc_rr_crossbar_tristate_buffer xi_m1s1_buf
    (
        .i_enable   (w_m1s1_enable),
        
        .o_req      (o_slave_1_req),
        .o_addr     (o_slave_1_addr),
        .o_cmd      (o_slave_1_cmd),
        .o_wdata    (o_slave_1_wdata),
        .i_ack      (i_slave_1_ack),
        .i_rdata    (i_slave_1_rdata),
        
        .i_req      (i_master_1_req),
        .i_addr     (i_master_1_addr),
        .i_cmd      (i_master_1_cmd),
        .i_wdata    (i_master_1_wdata),
        .o_ack      (o_master_1_ack),
        .o_rdata    (o_master_1_rdata)
    );
    
endmodule

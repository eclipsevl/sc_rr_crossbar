`include "timing_inc.vh"

module sc_rr_crossbar_tristate_buffer
(
    input           i_enable,

    // slave side
    output          o_req,
    output [31:0]   o_addr,
    output          o_cmd,
    output [31:0]   o_wdata,
    input           i_ack,
    input  [31:0]   i_rdata,
    
    // master side
    input           i_req,
    input  [31:0]   i_addr,
    input           i_cmd,
    input  [31:0]   i_wdata,
    output          o_ack,
    output [31:0]   o_rdata
);

// master -> slave
assign  o_req   = i_enable ? i_req      : 1'bz;
assign  o_addr  = i_enable ? i_addr     : 32'hzzzzzzzz;
assign  o_cmd   = i_enable ? i_cmd      : 1'bz;
assign  o_wdata = i_enable ? i_wdata    : 32'hzzzzzzzz;

// slave -> master
assign  o_ack   = i_enable ? i_ack      : 1'bz;
assign  o_rdata = i_enable ? i_rdata    : 32'hzzzzzzzz;

endmodule

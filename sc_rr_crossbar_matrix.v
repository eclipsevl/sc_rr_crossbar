// round-robin cross bar
// Vladislav Knyazkov, Aug 2016
// contact@eclipsevl.org

`include "timing_inc.vh"

module sc_rr_crossbar_matrix
(
    input           i_cross_connect,
	input			i_sl_0_connect,
	input			i_sl_1_connect,

    // slave 0 side
    output          o_req_sl_0,
    output [31:0]   o_addr_sl_0,
    output          o_cmd_sl_0,
    output [31:0]   o_wdata_sl_0,
    input           i_ack_sl_0,
    input  [31:0]   i_rdata_sl_0,
 
    // slave 1 side
    output          o_req_sl_1,
    output [31:0]   o_addr_sl_1,
    output          o_cmd_sl_1,
    output [31:0]   o_wdata_sl_1,
    input           i_ack_sl_1,
    input  [31:0]   i_rdata_sl_1,
	
    // master 0 side
    input           i_req_ms_0,
    input  [31:0]   i_addr_ms_0,
    input           i_cmd_ms_0,
    input  [31:0]   i_wdata_ms_0,
    output          o_ack_ms_0,
    output [31:0]   o_rdata_ms_0,
	
    // master 1 side
    input           i_req_ms_1,
    input  [31:0]   i_addr_ms_1,
    input           i_cmd_ms_1,
    input  [31:0]   i_wdata_ms_1,
    output          o_ack_ms_1,
    output [31:0]   o_rdata_ms_1
);

// master -> slave
assign  o_req_sl_0   = ~i_cross_connect ? i_req_ms_0 & i_sl_0_connect : i_req_ms_1 & i_sl_0_connect;
assign  o_addr_sl_0  = ~i_cross_connect ? i_addr_ms_0	  : i_addr_ms_1;
assign  o_cmd_sl_0   = ~i_cross_connect ? i_cmd_ms_0 & i_sl_0_connect : i_cmd_ms_1 & i_sl_0_connect;
assign  o_wdata_sl_0 = ~i_cross_connect ? i_wdata_ms_0    : i_wdata_ms_1;

assign  o_req_sl_1   = ~i_cross_connect ? i_req_ms_1 & i_sl_1_connect : i_req_ms_0 & i_sl_1_connect;
assign  o_addr_sl_1  = ~i_cross_connect ? i_addr_ms_1     : i_addr_ms_0;
assign  o_cmd_sl_1   = ~i_cross_connect ? i_cmd_ms_1 & i_sl_1_connect : i_cmd_ms_0 & i_sl_1_connect;
assign  o_wdata_sl_1 = ~i_cross_connect ? i_wdata_ms_1    : i_wdata_ms_0;

// slave -> master
assign  o_ack_ms_0   = ~i_cross_connect ? i_ack_sl_0      : i_ack_sl_1;
assign  o_rdata_ms_0 = ~i_cross_connect ? i_rdata_sl_0    : i_rdata_sl_1;

assign  o_ack_ms_1   = ~i_cross_connect ? i_ack_sl_1      : i_ack_sl_0;
assign  o_rdata_ms_1 = ~i_cross_connect ? i_rdata_sl_1    : i_rdata_sl_0;

endmodule

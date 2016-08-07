`include "timing_inc.vh"

module sc_sys_core
(
    // general io
    input           i_clk,
    input           i_resetb
);

// master 0 interface
wire                w_master_0_req; 
wire    [31:0]      w_master_0_addr;
wire                w_master_0_cmd; 
wire    [31:0]      w_master_0_wdata;
wire                w_master_0_ack; 
wire    [31:0]      w_master_0_rdata;
     
// master 1 interface
wire                w_master_1_req; 
wire    [31:0]      w_master_1_addr;
wire                w_master_1_cmd; 
wire    [31:0]      w_master_1_wdata;
wire                w_master_1_ack; 
wire    [31:0]      w_master_1_rdata;
     
// slave 0 interface
wire                w_slave_0_req;  
wire    [31:0]      w_slave_0_addr; 
wire                w_slave_0_cmd;  
wire    [31:0]      w_slave_0_wdata;
wire                w_slave_0_ack;  
wire    [31:0]      w_slave_0_rdata;
     
// slave 1 interface
wire                w_slave_1_req;  
wire    [31:0]      w_slave_1_addr; 
wire                w_slave_1_cmd;  
wire    [31:0]      w_slave_1_wdata;
wire                w_slave_1_ack;  
wire    [31:0]      w_slave_1_rdata;

sc_rr_crossbar xi_rr_xbar
    (
        .i_clk                          (i_clk),
        .i_resetb                       (i_resetb),
    
        // master 0 interface
        .i_master_0_req                 (w_master_0_req),
        .i_master_0_addr                (w_master_0_addr),
        .i_master_0_cmd                 (w_master_0_cmd),
        .i_master_0_wdata               (w_master_0_wdata),
        .o_master_0_ack                 (w_master_0_ack),
        .o_master_0_rdata               (w_master_0_rdata),
        
        // master 1 interface
        .i_master_1_req                 (w_master_1_req),
        .i_master_1_addr                (w_master_1_addr),
        .i_master_1_cmd                 (w_master_1_cmd),
        .i_master_1_wdata               (w_master_1_wdata),
        .o_master_1_ack                 (w_master_1_ack),
        .o_master_1_rdata               (w_master_1_rdata),
        
        // slave 0 interface
        .o_slave_0_req                  (w_slave_0_req),
        .o_slave_0_addr                 (w_slave_0_addr),
        .o_slave_0_cmd                  (w_slave_0_cmd),
        .o_slave_0_wdata                (w_slave_0_wdata),
        .i_slave_0_ack                  (w_slave_0_ack),
        .i_slave_0_rdata                (w_slave_0_rdata),
        
        // slave 1 interface
        .o_slave_1_req                  (w_slave_1_req),
        .o_slave_1_addr                 (w_slave_1_addr),
        .o_slave_1_cmd                  (w_slave_1_cmd),
        .o_slave_1_wdata                (w_slave_1_wdata),
        .i_slave_1_ack                  (w_slave_1_ack),
        .i_slave_1_rdata                (w_slave_1_rdata)
    );
    
// masters
sc_master_dev #("master0.txt") xi_ms_dev_0
    (
        .i_clk                          (i_clk),
        .i_resetb                       (i_resetb),
        
        .o_req                          (w_master_0_req),
        .o_addr                         (w_master_0_addr),
        .o_cmd                          (w_master_0_cmd),
        .o_wdata                        (w_master_0_wdata),
        .i_ack                          (w_master_0_ack),
        .i_rdata                        (w_master_0_rdata)
    );
    
sc_master_dev #("master1.txt") xi_ms_dev_1
    (
        .i_clk                          (i_clk),
        .i_resetb                       (i_resetb),
        
        .o_req                          (w_master_1_req),
        .o_addr                         (w_master_1_addr),
        .o_cmd                          (w_master_1_cmd),
        .o_wdata                        (w_master_1_wdata),
        .i_ack                          (w_master_1_ack),
        .i_rdata                        (w_master_1_rdata)
    );  
    
// slaves
sc_slave_dev #("slave0.txt") xi_sl_dev_0
    (
        .i_clk                          (i_clk),
        .i_resetb                       (i_resetb),
        
        .i_req                          (w_slave_0_req),
        .i_addr                         ({1'b0, w_slave_0_addr[30:0]}),
        .i_cmd                          (w_slave_0_cmd),
        .i_wdata                        (w_slave_0_wdata),
        .o_ack                          (w_slave_0_ack),
        .o_rdata                        (w_slave_0_rdata)
    );
    
sc_slave_dev #("slave1.txt") xi_sl_dev_1
    (
        .i_clk                          (i_clk),
        .i_resetb                       (i_resetb),
        
        .i_req                          (w_slave_1_req),
        .i_addr                         ({1'b0, w_slave_1_addr[30:0]}),
        .i_cmd                          (w_slave_1_cmd),
        .i_wdata                        (w_slave_1_wdata),
        .o_ack                          (w_slave_1_ack),
        .o_rdata                        (w_slave_1_rdata)
    );  
    
endmodule

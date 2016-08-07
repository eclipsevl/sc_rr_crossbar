`include "timing_inc.vh"

`define FSM_IDLE            4'b0000
`define FSM_READ            4'b0001
`define FSM_NOP             4'b0010
`define FSM_REQ_READ        4'b0011
`define FSM_REQ_WRITE       4'b0100
`define FSM_END             4'b0101

module sc_master_dev
#(parameter SOURCE="master.txt")
(
    // general io
    input           i_clk,
    input           i_resetb,
    
    // master interface
    output          o_req,
    output [31:0]   o_addr,
    output          o_cmd,
    output [31:0]   o_wdata,
    input           i_ack,
    input  [31:0]   i_rdata
);
    
// interface registers
reg             r_req;
reg [31:0]      r_addr;
reg             r_cmd;
reg [31:0]      r_wdata;

integer in;
integer stat;

reg [7:0]       command;
reg [31:0]      arg;
reg [8*32-1:0]  buff;
reg [31:0]      addr;
reg [31:0]      data;

reg [3:0]   fsm_state = 4'b0000;

always @(posedge i_clk or negedge i_resetb) begin
    if(~i_resetb) begin
        fsm_state = `FSM_IDLE;
    end else begin
        case (fsm_state)
            // open file with test description
            `FSM_IDLE:
                begin
                    in = $fopen(SOURCE, "r");
                    if(in) fsm_state <= `FSM_READ;
                end
                
            // file reading and decoding
            `FSM_READ:
                begin
                    
                    if( !$feof(in) ) begin
                        stat = $fgets(buff, in);
                        stat = $sscanf(buff ,"%s %h %h;", command, addr, data);
                        
                        // decode command
                        if(stat > 1) begin
                            //$display("%t, command; %s", $time, command);
                            case (command)
                                "r": 
                                    begin
                                        $display("%s: %t, read command, addr: 0x%x, expected data: 0x%x", SOURCE, $time, addr, data);
                                        r_req       <=  #1  1'b1;
                                        r_cmd       <=  #1  1'b0;
                                        r_addr      <=  #1  addr;
                                        r_wdata     <=  #1  32'h00000000;
                                        
                                        fsm_state   <=      `FSM_REQ_READ;
                                    end
                                "w":
                                    begin
                                        if(stat < 2) data = 32'h00000000;
                                        $display("%s: %t, write command, addr: 0x%x, data: 0x%x", SOURCE,  $time, addr, data);
                                        r_req       <=  #1  1'b1;
                                        r_cmd       <=  #1  1'b1;
                                        r_addr      <=  #1  addr;   
                                        r_wdata     <=  #1  data;
                                                        
                                        fsm_state   <=      `FSM_REQ_WRITE;
                                    end
                                    
                                "n":
                                    begin
                                        $display("%s: %t, nop %d cycles", SOURCE,  $time, addr);
                                        r_req       <=  #1  1'b0;
                                        r_cmd       <=  #1  1'b0;
                                        r_addr      <=  #1  32'h00000000;   
                                        r_wdata     <=  #1  32'h00000000;
                                                        
                                        fsm_state   <=      `FSM_NOP;
                                    end
                                default:
                                    begin
                                        $display("%s: %t, unknown command \"%s\"", SOURCE,  $time, command);
                                        r_req       <=  #1  1'b0;
                                        r_cmd       <=  #1  1'b0;
                                        r_addr      <=  #1  32'h00000000;   
                                        r_wdata     <=  #1  32'h00000000;
                                                        
                                        fsm_state   <=      `FSM_READ;
                                    end
                            endcase                     
                        end
                    end // eof
                    else
                    begin
                        $display("%s: %t, end of file", SOURCE,  $time);
                        fsm_state   <=      `FSM_END;
                    end
                end
            
            `FSM_NOP: 
                begin
                    if(addr > 0) begin
                        addr = addr-1;
                        fsm_state   <= `FSM_NOP;
                    end else begin
                        fsm_state   <= `FSM_READ;
                    end
                end
            
            // waiting for ack from slave
            `FSM_REQ_READ:
                begin
                    if(i_ack) begin                     
                        fsm_state   <= `FSM_READ;
                        r_req       <=  #1  1'b0;
                        $display("%s: %t, readback: addr: 0x%x, data: 0x%x, expected: 0x%x", SOURCE,  $time, addr, i_rdata, data);
                    end else begin
                        fsm_state   <= `FSM_REQ_READ;
                    end
                end     
                
            // waiting for ack from slave
            `FSM_REQ_WRITE:
                begin
                    if(i_ack) begin                     
                        fsm_state   <= `FSM_READ;
                        r_req       <=  #1  1'b0;
                    end else begin
                        fsm_state   <= `FSM_REQ_WRITE;                      
                    end
                end         
            
            `FSM_END: 
                begin
                    if(in) $fclose(in);
                    fsm_state <= `FSM_END;
                end
            default: fsm_state <= `FSM_END;
        endcase
    end
end

assign o_req    = r_req;
assign o_addr   = r_addr;
assign o_cmd    = r_cmd;
assign o_wdata  = r_wdata;
    
endmodule
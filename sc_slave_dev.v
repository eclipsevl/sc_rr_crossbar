// round-robin cross bar testbench
// Vladislav Knyazkov, Aug 2016
// contact@eclipsevl.org

`include "timing_inc.vh"

module sc_slave_dev
#(parameter SOURCE="slave.txt")
(
    // general io
    input           i_clk,
    input           i_resetb,
    
    // slave interface
    input           i_req,
    input  [31:0]   i_addr,
    input           i_cmd,
    input  [31:0]   i_wdata,
    output          o_ack,
    output [31:0]   o_rdata
);

    reg             r_req;
    reg             r_ack;
    reg             r_cmd;
    reg [31:0]      r_addr;
    reg [31:0]      r_rdata;    
    reg [31:0]      r_wdata;    
    
    // Declare the RAM variable
    reg [31:0]      ram[2**31-1:0];

    initial
    begin
      $readmemh(SOURCE, ram);
    end

    always @(posedge i_clk or negedge i_resetb)
    begin
        if(~i_resetb) begin
            r_req       <= 1'b0;
            r_ack       <= 1'b0;
            r_cmd       <= 1'b0;
            r_addr      <= 'b0;
            r_rdata     <= 'b0;
            r_wdata     <= 'b0;         
        end     
        else
        begin
            r_req   <= i_req; 
            
            // capture request
            if(i_req) begin
                r_addr  <= i_addr;
                r_wdata <= i_wdata;
                r_cmd   <= i_cmd;
            end
            
            // proceed request
            if(r_req) begin
                // write
                if(r_cmd) begin
                    ram[r_addr] <= r_wdata;
                    r_ack       <= #1 1'b1;
                end 
                else
                // read
                begin
                    r_rdata     <= #1 ram[r_addr];
                    r_ack       <= #1 1'b1;
                end
            end
            else
            // no active request
            begin
                r_ack <= #1 1'b0;
            end
        end
    end
    
    assign o_ack    = r_ack;
    assign o_rdata  = r_rdata;
    
endmodule

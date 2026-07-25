`timescale 1ns / 1ps
module testuart;
    reg clk = 0, rst = 1, wr_en = 0, rdy_clr = 0;
    reg [7:0] data_in = 0;
    wire rdy, busy;
    wire [7:0] data_out;

    // Top module connect kiya
    topuart uut (clk, rst, wr_en, rdy_clr, data_in, rdy, busy, data_out);

    // Clock generate
    always #10 clk = ~clk;

    initial begin
        $dumpfile("uart.vcd"); $dumpvars(0, testuart);
        
        #100 rst = 0; 
        
        #100 data_in = 8'hA5; wr_en = 1; 
        #20 wr_en = 0;
        
        wait(rdy == 1'b1); 
        
        if (data_out == 8'hA5) $display("SUCCESS!");
        else $display("FAIL!");
        
        #60 $finish;
    end
endmodule

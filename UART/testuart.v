// `timescale 1ns / 1ps

// module tb_uart;

//     // Inputs
//     reg clk;
//     reg rst;
//     reg wr_en;
//     reg rdy_clr;
//     reg [7:0] data_in;

//     // Outputs
//     wire rdy;
//     wire busy;
//     wire [7:0] data_out;

//     // Top module instantiation
//     topuart uut (
//         .clk(clk), 
//         .rst(rst), 
//         .wr_en(wr_en), 
//         .rdy_clr(rdy_clr), 
//         .data_in(data_in), 
//         .rdy(rdy), 
//         .busy(busy), 
//         .data_out(data_out)
//     );

//     // 50 MHz Clock Generation
//     always #10 clk = ~clk;

//     // ----------------------------------------------------
//     // FAILSAFE TIMEOUT: Agar system atak gaya toh ye 
//     // block simulation ko 3 milliseconds baad force close kar dega
//     // taaki tu GTKWave me error check kar sake.
//     // ----------------------------------------------------
//     initial begin
//         #3000000; // 3 ms max simulation time (UART takes ~1ms for 1 byte)
//         $display("\n========================================");
//         $display("ERROR: TIMEOUT! Simulation atak gaya hai.");
//         $display("Reason: 'rdy' signal kabhi 1 nahi hua.");
//         $display("========================================\n");
//         $finish;
//     end

//     initial begin
//         $dumpfile("uart_dump.vcd");
//         $dumpvars(0, tb_uart);

//         // 1. Initial State
//         clk = 0; 
//         rst = 1; 
//         wr_en = 0; 
//         rdy_clr = 0; 
//         data_in = 8'h00;
        
//         // 2. Apply Reset synchronously
//         #100;
//         @(posedge clk);
//         rst = 0;
        
//         #100;
        
//         // 3. Send Data (Synchronized precisely with clock edges)
//         @(posedge clk);
//         data_in = 8'hA5;
//         wr_en = 1;
        
//         @(posedge clk); // Hold wr_en for exactly 1 clock cycle
//         wr_en = 0;

//         // 4. Wait for receiver to catch the data
//         wait(rdy == 1'b1);
        
//         // 5. Check Output
//         @(posedge clk);
//         if (data_out == 8'hA5) begin
//             $display("\n========================================");
//             $display("SUCCESS: Data Match! Sent: %h, Received: %h", data_in, data_out);
//             $display("========================================\n");
//         end else begin
//             $display("\n========================================");
//             $display("ERROR: Data Mismatch! Sent: %h, Received: %h", data_in, data_out);
//             $display("========================================\n");
//         end

//         // 6. Send Acknowledge (rdy_clr)
//         @(posedge clk);
//         rdy_clr = 1;
//         @(posedge clk);
//         rdy_clr = 0;

//         // Finish cleanly
//         #1000;
//         $finish;
//     end

// endmodule
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
        
        #100 rst = 0; // Reset hataya
        
        #100 data_in = 8'hA5; wr_en = 1; // Data bheja
        #20 wr_en = 0;
        
        wait(rdy == 1'b1); // RX ka wait kiya
        
        if (data_out == 8'hA5) $display("SUCCESS!");
        else $display("FAIL!");
        
        #60 $finish;
    end
endmodule
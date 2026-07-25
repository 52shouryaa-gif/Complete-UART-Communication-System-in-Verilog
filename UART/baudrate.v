module baud_rate(
    input clk,
    input rst, 
    output tx_enb,
    output rx_enb
);
    reg [12:0] tx_count;
    reg [9:0] rx_count;

    always @(posedge clk) begin
        if (rst) begin
            tx_count <= 13'd0;
        end 
        else if (tx_count == 13'd63) begin // 64 cycles (0 to 63)
            tx_count <= 13'd0;
        end 
        else begin
            tx_count <= tx_count + 1'b1; 
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            rx_count <= 10'd0;
        end 
        else if (rx_count == 10'd3) begin // 4 cycles (0 to 3)
            rx_count <= 10'd0;
        end 
        else begin
            rx_count <= rx_count + 1'b1; 
        end
    end

    assign rx_enb = (rx_count == 0);
    assign tx_enb = (tx_count == 0);
endmodule
// we take 64 and 4 cycles for easily verify it in waveform 
// we can replace 64 by 5208 and 325 in place of 4

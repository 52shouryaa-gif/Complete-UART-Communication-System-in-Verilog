module topuart (
    input clk , rst , wr_en , rdy_clr , input[7:0] data_in,
    output rdy , busy , output [7:0] data_out
);
    wire rx_en_baud;
    wire tx_en_baud;
    wire tx_temp;

    rx r (
        .clk(clk),
        .rst(rst) ,
        .rx(tx_temp) , 
        .data_out(data_out),
        .rdy(rdy),
        .clk_en(rx_en_baud) ,
        .rdy_clr(rdy_clr)
    );

    t transmitter(
        .clk(clk),
        .rst(rst),
        .enb(tx_en_baud),
        .data_in(data_in),
        .busy(busy),
        .tx(tx_temp),
        .wr_en(wr_en)
    );

    baud_rate b(
        .clk(clk),
        .tx_enb(tx_en_baud),
        .rx_enb(rx_en_baud),
        .rst(rst)
    );

endmodule

module topfina (
    input clk,
    input reset,

    // RX
    input rx,
    output rdy,
    output [7:0] data_out,

    // TX
    input wr,
    input [7:0] data_in,
    output busy,
    output tx,

    // baud rate enables
    output tx_enb,
    output rx_enb
);

    baudrate bu (
        .clk(clk),
        .tx_enb(tx_enb),
        .rx_enb(rx_enb)
    );

    rx_enaa rxi (
        .clk(clk),
        .reset(reset),
        .rx_enb(rx_enb),
        .rx(rx),
        .rdy(rdy),
        .data_out(data_out)
    );

    tx_enaa txi (
        .clk(clk),
        .reset(reset),
        .tx_enb(tx_enb),
        .wr(wr),
        .data_in(data_in),
        .busy(busy),
        .tx(tx)
    );

endmodule

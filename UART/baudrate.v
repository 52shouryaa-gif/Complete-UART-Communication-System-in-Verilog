module baudrate (
    input clk , output tx_enb , output rx_enb
);
reg [15:0] counter;
parameter freq = 5000000 ;
parameter baudy = 9600;
parameter txdiv = freq/(baudy);
parameter rxdiv = freq/(baudy*16);

reg [$clog2 (txdiv)-1 : 0 ] tx_en;
reg [$clog2 (rxdiv)-1 : 0 ] rx_en;
always @(posedge clk) begin
    if(tx_en == txdiv - 1) tx_en <=0;
    else tx_en <= tx_en + 1;
end
always @(posedge clk) begin
    if(rx_en == rxdiv - 1) rx_en <=0;
    else rx_en <= rx_en + 1;
end
assign tx_enb = (tx_en == 0);
assign rx_enb = (rx_en == 0);

endmodule
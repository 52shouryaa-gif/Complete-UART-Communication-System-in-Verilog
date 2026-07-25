module t (
    input clk, 
    input rst, 
    input enb, 
    input wr_en,
    input [7:0] data_in, 
    output reg tx, 
    output busy
);
    localparam idle_state  = 2'b00;
    localparam start_state = 2'b01;
    localparam data_state  = 2'b10;
    localparam stop_state  = 2'b11;
    
    reg [1:0] state;
    reg [7:0] data;       
    reg [2:0] bit_cnt;    

    always @(posedge clk) begin
        if (rst) begin
            tx      <= 1'b1;
            state   <= idle_state;
            data    <= 8'd0;
            bit_cnt <= 3'd0;
        end
        else begin
            case (state)
                idle_state: begin
                    tx <= 1'b1; 
                    if (wr_en) begin
                        state   <= start_state;
                        data    <= data_in;
                        bit_cnt <= 3'd0;
                    end
                
            end
                
                start_state: begin
                    if (enb) begin
                        tx    <= 1'b0;
                        state <= data_state;
                    end
                         
                end
                
                data_state: begin
                    if (enb) begin
                        
                        tx   <= data[0]; 
                        data <= {1'b0, data[7:1]}; 
                        
                        // 4. Check if we've sent all 8 bits
                        if (bit_cnt == 3'h7) begin
                            state <= stop_state;
                        end
                        else begin
                            bit_cnt <= bit_cnt + 3'h1; 
                        end
                    end
                end
                
                stop_state: begin
                    if (enb) begin
                        tx    <= 1'b1;
                        state <= idle_state;
                    end
                end
                
                default: begin
                    tx    <= 1'b1;
                    state <= idle_state;
                end
            endcase
        end
    end

    assign busy = (state != idle_state);

endmodule

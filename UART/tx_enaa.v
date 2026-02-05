module tx_enaa (
    input wr, input tx_enb, input clk, input reset, 
    input [7:0] data_in, 
    output  reg busy, output  reg tx 
);
    parameter idle = 0, start = 1, steady = 2, stop = 3;
    reg [1:0] state, next_state;
    reg [7:0] data;
    reg [2:0] index;

    
    always @(posedge clk) begin
        if (reset) begin
            state <= idle;
        end else begin
            state <= next_state;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            busy  <= 1'b0;
            tx    <= 1'b1;
            index <= 3'd0;
            data  <= 8'd0;
        end else begin
            case (state)
                idle: begin
                    busy <= 1'b0;
                    tx   <= 1'b1;
                    if (wr) begin
                        next_state <= start;
                        busy       <= 1'b1;
                        data       <= data_in;
                    end else begin
                        next_state <= idle;
                    end
                end

                start: begin
                    if (tx_enb) begin
                        next_state <= steady;
                        tx         <= 1'b0;
                        index      <= 3'd0;
                    end
                end

                steady: begin
                    if (tx_enb) begin
                        tx <= data[index];
                        if (index == 3'd7) begin 
                            next_state <= stop;
                        end else begin
                            index <= index + 1'b1;
                        end
                    end
                end

                stop: begin
                    if (tx_enb) begin
                        next_state <= idle;
                        tx         <= 1'b1; 
                        busy       <= 1'b0;
                    end
                end
                
                default: next_state <= idle;
            endcase
        end
    end
endmodule
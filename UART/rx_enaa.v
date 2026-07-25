module rx (
    input clk,
    input rst,
    input rdy_clr,
    input clk_en,
    input rx,
    output reg rdy,
    output reg [7:0] data_out
);
    localparam idle_state  = 2'b00;
    localparam start_state = 2'b01;
    localparam data_state  = 2'b10;
    localparam stop_state  = 2'b11;

    reg [1:0] state;
    reg [3:0] sample;
    reg [2:0] index;
    reg [7:0] temp_register;

    always @(posedge clk) begin
        if (rst) begin
            sample        <= 4'd0;
            index         <= 3'd0;
            state         <= idle_state;
            rdy           <= 1'b0;
            data_out      <= 8'd0;
            temp_register <= 8'd0;
        end
        else begin
            if (rdy_clr)
                rdy <= 1'b0;

            if (clk_en) begin
                case (state)
                    idle_state: begin
                        sample <= 4'd0;
                        index  <= 3'd0;
                        if (rx == 1'b0)
                            state <= start_state;
                    end

                    start_state: begin
                        sample <= sample + 4'd1;
                        if (sample == 4'h7) begin
                            if (rx == 1'b1) begin   // glitch filter
                                state  <= idle_state;
                                sample <= 4'd0;
                            end
                        end
                        else if (sample == 4'hF) begin
                            sample <= 4'd0;
                            index  <= 3'd0;
                            state  <= data_state;
                        end
                    end

                    data_state: begin
                        sample <= sample + 4'd1;
                        if (sample == 4'h7)
                            temp_register <= {rx, temp_register[7:1]};
                        if (sample == 4'hF) begin
                            sample <= 4'd0;
                            if (index == 3'd7)
                                state <= stop_state;
                            else
                                index <= index + 3'd1;
                        end
                    end

                    stop_state: begin
                        sample <= sample + 4'd1;
                        if (sample == 4'hF) begin
                            sample   <= 4'd0;
                            state    <= idle_state;
                            data_out <= temp_register;
                            rdy      <= 1'b1;
                        end
                    end

                    default: state <= idle_state;
                endcase
            end
        end
    end
endmodule

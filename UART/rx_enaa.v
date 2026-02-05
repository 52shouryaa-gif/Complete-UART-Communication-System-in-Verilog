module rx_enaa (
    input rx , input rx_enb , input clk , input reset , output reg rdy , output reg [7:0] data_out
);
    parameter idle = 2'd0 , start = 2'd1 , data = 2'd2 , stop = 2'd3;
reg [1:0] state = idle;
reg [3:0] sample_count = 0;
reg [2:0] bit_index = 0;
reg [7:0] temp_data = 0;
 always @(posedge clk) begin
    if(reset) begin
            state <= idle;
            rdy<= 0;
            data_out <= 0;
            sample_count <= 0;
            bit_index <= 0;
            temp_data <= 0;
    end
    else if(rx_enb) begin
    case (state)
        idle: begin
            rdy <= 0;
            if(rx==0) begin
                state <= start;
                sample_count <= 0;

            end
        end
        start: begin
            if(sample_count == 7) begin
            sample_count <=0;
            bit_index <=0;
            state <= data;
        end
        else sample_count <= sample_count + 1;
        end
        data: begin
            if(sample_count == 15) begin
                sample_count <= 0;
                temp_data[bit_index] <= rx;
                if(bit_index == 7) begin
                    state <= stop;
                end
                else bit_index = bit_index + 1;
            end
            else sample_count <= sample_count + 1;
        end
        stop:begin
             if(sample_count == 15) begin
            data_out <= temp_data;
            rdy <= 1;
            state <= idle;
        end
        else sample_count = sample_count + 1;
        end
        default: state <= idle; 
    endcase
    end
    else rdy <= 0;
    
    end
 
endmodule
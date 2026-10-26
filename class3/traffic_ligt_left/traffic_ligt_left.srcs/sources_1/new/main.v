`timescale 1ns / 1ps

module traffic_light_full (clk, rst, R1, Y1, G1, LR1, LY1, L1, R2, Y2, G2, LR2, LY2, L2);
    input clk;
    input rst;
    
    output reg R1, Y1, G1;   
    output reg LR1, LY1, L1; 
    output reg R2, Y2, G2;   
    output reg LR2, LY2, L2; 

    parameter integer GRTime  = 15; 
    parameter integer YRTime  = 3;  
    parameter integer RGTime  = 10; 
    parameter integer GR2Time = 15; 
    parameter integer RG2Time = 10; 

    parameter [3:0] YYYY = 4'b0000; 
    parameter [3:0] GRRR = 4'b0001; 
    parameter [3:0] YRRR = 4'b0010; 
    parameter [3:0] RGRR = 4'b0011; 
    parameter [3:0] RYRR = 4'b0100; 
    parameter [3:0] RRGR = 4'b0101; 
    parameter [3:0] RRYR = 4'b0110; 
    parameter [3:0] RRRG = 4'b0111; 
    parameter [3:0] RRRY = 4'b1000; 

    reg [3:0] state = YYYY;
    integer TimeCnt = 0;
    integer onTime = YRTime;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state   <= YYYY;
            TimeCnt <= 0;
        end
        else begin
            case (state)
                YYYY: begin
                    state   <= GRRR;
                    TimeCnt <= 0;
                end
                GRRR: begin
                    onTime <= GRTime;
                    if (TimeCnt >= GRTime - 1) begin state <= YRRR; TimeCnt <= 0; end
                    else TimeCnt <= TimeCnt + 1;
                end
                YRRR: begin
                    onTime <= YRTime;
                    if (TimeCnt >= YRTime - 1) begin state <= RGRR; TimeCnt <= 0; end
                    else TimeCnt <= TimeCnt + 1;
                end
                RGRR: begin
                    onTime <= RGTime;
                    if (TimeCnt >= RGTime - 1) begin state <= RYRR; TimeCnt <= 0; end
                    else TimeCnt <= TimeCnt + 1;
                end
                RYRR: begin
                    onTime <= YRTime;
                    if (TimeCnt >= YRTime - 1) begin state <= RRGR; TimeCnt <= 0; end
                    else TimeCnt <= TimeCnt + 1;
                end
                RRGR: begin
                    onTime <= GR2Time;
                    if (TimeCnt >= GR2Time - 1) begin state <= RRYR; TimeCnt <= 0; end
                    else TimeCnt <= TimeCnt + 1;
                end
                RRYR: begin
                    onTime <= YRTime;
                    if (TimeCnt >= YRTime - 1) begin state <= RRRG; TimeCnt <= 0; end
                    else TimeCnt <= TimeCnt + 1;
                end
                RRRG: begin
                    onTime <= RG2Time;
                    if (TimeCnt >= RG2Time - 1) begin state <= RRRY; TimeCnt <= 0; end
                    else TimeCnt <= TimeCnt + 1;
                end
                RRRY: begin
                    onTime <= YRTime;
                    if (TimeCnt >= YRTime - 1) begin state <= GRRR; TimeCnt <= 0; end
                    else TimeCnt <= TimeCnt + 1;
                end
                default: state <= YYYY;
            endcase
        end
    end

    always @(state) begin
        R1 = 1'b1; Y1 = 1'b0; G1 = 1'b0; 
        LR1 = 1'b1; LY1 = 1'b0; L1 = 1'b0;
        R2 = 1'b1; Y2 = 1'b0; G2 = 1'b0; 
        LR2 = 1'b1; LY2 = 1'b0; L2 = 1'b0;

        case (state)
            YYYY: begin 
                R1 = 1'b1; Y1 = 1'b0; G1 = 1'b0; LR1 = 1'b1; LY1 = 1'b0; L1 = 1'b0;
                R2 = 1'b1; Y2 = 1'b0; G2 = 1'b0; LR2 = 1'b1; LY2 = 1'b0; L2 = 1'b0;
            end
            GRRR: begin 
                R1 = 1'b0; Y1 = 1'b0; G1 = 1'b1; LR1 = 1'b1; LY1 = 1'b0; L1 = 1'b0;
                R2 = 1'b1; Y2 = 1'b0; G2 = 1'b0; LR2 = 1'b1; LY2 = 1'b0; L2 = 1'b0;
            end
            YRRR: begin 
                R1 = 1'b0; Y1 = 1'b1; G1 = 1'b0; LR1 = 1'b1; LY1 = 1'b0; L1 = 1'b0;
                R2 = 1'b1; Y2 = 1'b0; G2 = 1'b0; LR2 = 1'b1; LY2 = 1'b0; L2 = 1'b0;
            end
            RGRR: begin 
                R1 = 1'b1; Y1 = 1'b0; G1 = 1'b0; LR1 = 1'b0; LY1 = 1'b0; L1 = 1'b1;
                R2 = 1'b1; Y2 = 1'b0; G2 = 1'b0; LR2 = 1'b1; LY2 = 1'b0; L2 = 1'b0;
            end
            RYRR: begin 
                R1 = 1'b1; Y1 = 1'b0; G1 = 1'b0; LR1 = 1'b0; LY1 = 1'b1; L1 = 1'b0;
                R2 = 1'b1; Y2 = 1'b0; G2 = 1'b0; LR2 = 1'b1; LY2 = 1'b0; L2 = 1'b0;
            end
            RRGR: begin 
                R1 = 1'b1; Y1 = 1'b0; G1 = 1'b0; LR1 = 1'b1; LY1 = 1'b0; L1 = 1'b0;
                R2 = 1'b0; Y2 = 1'b0; G2 = 1'b1; LR2 = 1'b1; LY2 = 1'b0; L2 = 1'b0;
            end
            RRYR: begin 
                R1 = 1'b1; Y1 = 1'b0; G1 = 1'b0; LR1 = 1'b1; LY1 = 1'b0; L1 = 1'b0;
                R2 = 1'b0; Y2 = 1'b1; G2 = 1'b0; LR2 = 1'b1; LY2 = 1'b0; L2 = 1'b0;
            end
            RRRG: begin 
                R1 = 1'b1; Y1 = 1'b0; G1 = 1'b0; LR1 = 1'b1; LY1 = 1'b0; L1 = 1'b0;
                R2 = 1'b1; Y2 = 1'b0; G2 = 1'b0; LR2 = 1'b0; LY2 = 1'b0; L2 = 1'b1;
            end
            RRRY: begin 
                R1 = 1'b1; Y1 = 1'b0; G1 = 1'b0; LR1 = 1'b1; LY1 = 1'b0; L1 = 1'b0;
                R2 = 1'b1; Y2 = 1'b0; G2 = 1'b0; LR2 = 1'b0; LY2 = 1'b1; L2 = 1'b0;
            end
            default: begin
                R1 = 1'b1; Y1 = 1'b0; G1 = 1'b0; LR1 = 1'b1; LY1 = 1'b0; L1 = 1'b0;
                R2 = 1'b1; Y2 = 1'b0; G2 = 1'b0; LR2 = 1'b1; LY2 = 1'b0; L2 = 1'b0;
            end
        endcase
    end
endmodule
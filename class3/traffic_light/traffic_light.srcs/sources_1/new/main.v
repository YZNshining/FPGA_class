`timescale 1ns / 1ps

// ================= 分频模块 =================
module frq_div(clk, rst, clk_div);
    parameter main_clk = 50000000, output_freq = 1;
    parameter cnt_value = ((main_clk/output_freq)/2) - 1;

    input clk, rst;
    output reg clk_div;
    reg [31:0] cnt; 
    
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            cnt <= 0;
            clk_div <= 0;
        end else begin
            if(cnt >= cnt_value) begin
                cnt <= 0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end
endmodule

// ================= 红绿灯状态机模块 =================
module traffic_light(clk, rst, G1, Y1, R1, G2, Y2, R2);
    input  clk, rst;
    output G1, Y1, R1, G2, Y2, R2;
    
    parameter YY = 3'b000, RY = 3'b001, GR = 3'b010, YR = 3'b011, RG = 3'b100;
    reg [2:0] state;
    
    // 此时由于clk是1Hz，这里的数字代表秒数
    parameter RGTime = 10, RYTime = 3, GRTime = 15, YRTime = 3;
    integer TimeCnt;
    
    reg G1 = 1'b0, Y1 = 1'b0, R1 = 1'b0;
    reg G2 = 1'b0, Y2 = 1'b0, R2 = 1'b0;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= YY;
            TimeCnt <= 0;
        end else begin
            case (state)
                YY: begin
                    state <= RY;
                    TimeCnt <= 0;
                end
                RY: begin
                    if (TimeCnt >= RYTime) begin
                        state <= GR;
                        TimeCnt <= 0;
                    end else begin
                        TimeCnt <= TimeCnt + 1;
                    end
                end
                GR: begin
                    if (TimeCnt >= GRTime) begin
                        state <= YR;
                        TimeCnt <= 0;
                    end else begin
                        TimeCnt <= TimeCnt + 1;
                    end
                end
                YR: begin
                    if (TimeCnt >= YRTime) begin
                        state <= RG;
                        TimeCnt <= 0;
                    end else begin
                        TimeCnt <= TimeCnt + 1;
                    end
                end
                RG: begin
                    if (TimeCnt >= RGTime) begin
                        state <= RY;
                        TimeCnt <= 0;
                    end else begin
                        TimeCnt <= TimeCnt + 1;
                    end
                end
                default: state <= YY;
            endcase
        end
    end

    always @(*) begin
        G1 = 1'b0; Y1 = 1'b0; R1 = 1'b0;
        G2 = 1'b0; Y2 = 1'b0; R2 = 1'b0;
        
        case (state)
            YY: begin G1=0; Y1=0; R1=0; G2=0; Y2=0; R2=0; end
            RY: begin G1=0; Y1=0; R1=1; G2=0; Y2=1; R2=0; end
            GR: begin G1=1; Y1=0; R1=0; G2=0; Y2=0; R2=1; end
            YR: begin G1=0; Y1=1; R1=0; G2=0; Y2=0; R2=1; end
            RG: begin G1=0; Y1=0; R1=1; G2=1; Y2=0; R2=0; end
            default: begin G1=0; Y1=0; R1=0; G2=0; Y2=0; R2=0; end
        endcase
    end
endmodule

// ================= 顶层模块 =================
module top_traffic(clk, rst, G1, Y1, R1, G2, Y2, R2);
    input clk, rst;
    output G1, Y1, R1, G2, Y2, R2;
    
    wire clk1hz;
    
    frq_div #(.main_clk(50000000), .output_freq(1)) 
        u_div (.clk(clk), .rst(rst), .clk_div(clk1hz));
        
    traffic_light u_traffic (
        .clk(clk1hz), 
        .rst(rst), 
        .G1(G1), .Y1(Y1), .R1(R1), 
        .G2(G2), .Y2(Y2), .R2(R2)
    );
endmodule
`timescale 1ns / 1ps

module frq_div(clk,rst,clk_div);
    parameter main_clk = 50000000, output_freq=1000;
    parameter cnt_value = ((main_clk/output_freq)/2)-1;

    input clk,rst;
    output reg clk_div;
    integer cnt;
    
    always @(posedge clk or negedge rst) begin
        if(rst==0)begin
            cnt<= 0;
            clk_div<=0;
        end
        else begin
            if(cnt>=cnt_value)begin
                cnt<=0;
                clk_div<=~clk_div;
            end
            else
                cnt<=cnt+1;
       end
    end
endmodule

module cnt14(clk,rst,cnt);
    input clk,rst;
    output reg [2:0] cnt;
    
    always @(posedge clk or negedge rst)begin
        if(rst==0) cnt<=0;
        else begin
            if(cnt==3) cnt<=0;
            else cnt <=cnt + 1;
        end
    end
endmodule

module segtest(num,intseg,seg,segcom );
    input[3:0] num;
    input [2:0] intseg;
    output reg [6:0]  seg;
    output reg [7:0]  segcom;
   
    always@(*)begin
        seg = 7'b1111111;
        segcom = 8'd0;
        case (intseg)
            3'd0: segcom = 8'b0000_0001; 
            3'd1: segcom = 8'b0000_0010; 
            3'd2: segcom = 8'b0000_0100; 
            3'd3: segcom = 8'b0000_1000; 
            default: segcom = 8'b0000_0000;
        endcase
        case(num)
            4'd0: seg = ~7'h3F; 
            4'd1: seg = ~7'h06; 
            4'd2: seg = ~7'h5B;
            4'd3: seg = ~7'h4F; 
            4'd4: seg = ~7'h66; 
            4'd5: seg = ~7'h6D; 
            4'd6: seg = ~7'h7D; 
            4'd7: seg = ~7'h07;
            4'd8: seg = ~7'h7F; 
            4'd9: seg = ~7'h6F; 
            default: seg = 7'h7F; 
        endcase
    end
endmodule

module traffic_light_cnt (clk, rst, R1, Y1, G1, L1, R2, Y2, G2, L2, EW_Count, NS_Count);
    input clk;
    input rst;
    output reg R1, Y1, G1, L1; 
    output reg R2, Y2, G2, L2; 
    output reg [7:0] EW_Count;
    output reg [7:0] NS_Count;

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
                YYYY: begin state <= GRRR; TimeCnt <= 0; end
                GRRR: begin onTime <= GRTime;
                    if (TimeCnt >= GRTime - 1) begin state <= YRRR; TimeCnt <= 0; end else TimeCnt <= TimeCnt + 1; end
                YRRR: begin onTime <= YRTime;
                    if (TimeCnt >= YRTime - 1) begin state <= RGRR; TimeCnt <= 0; end else TimeCnt <= TimeCnt + 1; end
                RGRR: begin onTime <= RGTime;
                    if (TimeCnt >= RGTime - 1) begin state <= RYRR; TimeCnt <= 0; end else TimeCnt <= TimeCnt + 1; end
                RYRR: begin onTime <= YRTime;
                    if (TimeCnt >= YRTime - 1) begin state <= RRGR; TimeCnt <= 0; end else TimeCnt <= TimeCnt + 1; end
                RRGR: begin onTime <= GR2Time;
                    if (TimeCnt >= GR2Time - 1) begin state <= RRYR; TimeCnt <= 0; end else TimeCnt <= TimeCnt + 1; end
                RRYR: begin onTime <= YRTime;
                    if (TimeCnt >= YRTime - 1) begin state <= RRRG; TimeCnt <= 0; end else TimeCnt <= TimeCnt + 1; end
                RRRG: begin onTime <= RG2Time;
                    if (TimeCnt >= RG2Time - 1) begin state <= RRRY; TimeCnt <= 0; end else TimeCnt <= TimeCnt + 1; end
                RRRY: begin onTime <= YRTime;
                    if (TimeCnt >= YRTime - 1) begin state <= GRRR; TimeCnt <= 0; end else TimeCnt <= TimeCnt + 1; end
                default: state <= YYYY;
            endcase
        end
    end

    always @(state or TimeCnt) begin
        R1 = 1'b1; Y1 = 1'b0; G1 = 1'b0; L1 = 1'b0;
        R2 = 1'b1; Y2 = 1'b0; G2 = 1'b0; L2 = 1'b0;
        EW_Count = 8'd0; NS_Count = 8'd0;

        case (state)
            YYYY: begin
                EW_Count = 8'd0; NS_Count = 8'd0;
            end
            GRRR: begin
                R1=0; Y1=0; G1=1; L1=0;
                R2=1; Y2=0; G2=0; L2=0;
                EW_Count = GRTime - TimeCnt; NS_Count = 31 - TimeCnt;
            end
            YRRR: begin
                R1=0; Y1=1; G1=0; L1=0;
                R2=1; Y2=0; G2=0; L2=0;
                EW_Count = YRTime - TimeCnt; NS_Count = 16 - TimeCnt;
            end
            RGRR: begin
                R1=1; Y1=0; G1=0; L1=1;
                R2=1; Y2=0; G2=0; L2=0;
                EW_Count = RGTime - TimeCnt; NS_Count = 13 - TimeCnt;
            end
            RYRR: begin
                R1=1; Y1=1; G1=0; L1=0;
                R2=1; Y2=0; G2=0; L2=0;
                EW_Count = YRTime - TimeCnt; NS_Count = 3 - TimeCnt;
            end
            RRGR: begin
                R1=1; Y1=0; G1=0; L1=0;
                R2=0; Y2=0; G2=1; L2=0;
                EW_Count = 31 - TimeCnt; NS_Count = GR2Time - TimeCnt;
            end
            RRYR: begin
                R1=1; Y1=0; G1=0; L1=0;
                R2=0; Y2=1; G2=0; L2=0;
                EW_Count = 16 - TimeCnt; NS_Count = YRTime - TimeCnt;
            end
            RRRG: begin
                R1=1; Y1=0; G1=0; L1=0;
                R2=1; Y2=0; G2=0; L2=1;
                EW_Count = 13 - TimeCnt; NS_Count = RG2Time - TimeCnt;
            end
            RRRY: begin
                R1=1; Y1=0; G1=0; L1=0;
                R2=1; Y2=1; G2=0; L2=0;
                EW_Count = 3 - TimeCnt; NS_Count = YRTime - TimeCnt;
            end
            default: begin
                R1=1; Y1=0; G1=0; L1=0;
                R2=1; Y2=0; G2=0; L2=0;
            end
        endcase
    end
endmodule

module top_module(clk, rst, R1, Y1, G1, L1, R2, Y2, G2, L2, seg, segcom);
    input clk, rst;
    output R1, Y1, G1, L1;
    output R2, Y2, G2, L2;
    output [6:0] seg;
    output [7:0] segcom;
    
    wire clk1hz;
    wire clk1khz;
    wire [7:0] EW_Count;
    wire [7:0] NS_Count;
    wire [2:0] scan;
    
    reg [3:0] digit;
    reg [2:0] intseg;
    
    wire [3:0] ew_tens = EW_Count / 10;
    wire [3:0] ew_ones = EW_Count % 10;
    wire [3:0] ns_tens = NS_Count / 10;
    wire [3:0] ns_ones = NS_Count % 10;

    frq_div #(.main_clk(50000000), .output_freq(1))    u_1hz (.clk(clk), .rst(rst), .clk_div(clk1hz));
    frq_div #(.main_clk(50000000), .output_freq(1000)) u_1khz (.clk(clk), .rst(rst), .clk_div(clk1khz));

    traffic_light_cnt u_traffic (
        .clk(clk1hz), .rst(rst), 
        .R1(R1), .Y1(Y1), .G1(G1), .L1(L1),
        .R2(R2), .Y2(Y2), .G2(G2), .L2(L2),
        .EW_Count(EW_Count), .NS_Count(NS_Count)
    );

    cnt14 u_cnt14 (.clk(clk1khz), .rst(rst), .cnt(scan));

    always @(*) begin
        digit  = 4'd0;
        intseg = 3'd0;
        case(scan)
            3'd0: begin digit = ew_ones; intseg = 3'd0; end
            3'd1: begin digit = ew_tens; intseg = 3'd1; end
            3'd2: begin digit = ns_ones; intseg = 3'd2; end
            3'd3: begin digit = ns_tens; intseg = 3'd3; end
            default: begin digit = 4'd0; intseg = 3'd0; end
        endcase
    end
    
    segtest u_segtest (.num(digit), .intseg(intseg), .seg(seg), .segcom(segcom));

endmodule
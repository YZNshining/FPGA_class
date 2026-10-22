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
            if(cnt==cnt_value)begin
                cnt<=0;
                clk_div<=~clk_div;
            end
            else
                cnt<=cnt+1;
       end



    end

endmodule
module cnt13(clk,rst,cnt);

    input clk,rst;
    output reg [1:0] cnt;

    always @(posedge clk or negedge rst)begin
        if(rst==0) cnt<=0;
        else begin
            if(cnt==2'b10) cnt<=0;
            else cnt <=cnt + 1;
        end


    end


endmodule
module segtest(num,intseg,seg,segcom );
    input[3:0] num;
    input [1:0] intseg;
    output reg [6:0]  seg;
    output reg [7:0]  segcom;


    always@(*)begin

        seg = 7'b1111111;
        segcom = 8'd0;
        case (intseg)
            2'd0: segcom = 8'b0000_0001;
            2'd1: segcom = 8'b0000_0010;
            2'd2: segcom = 8'b0000_0100;
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

module int3seg3(rst,int_value,dec100,dec10,dec1 );
    input rst;
    input[7:0] int_value;
    output reg [3:0]  dec100,dec10,dec1;

    always@(*)begin
    if(rst==0)begin
        dec100=0;
        dec10=0;
        dec1=0;
    end
    else begin
        dec100=int_value/100;
        dec10=(int_value%100)/10;
        dec1=(int_value%100)%10;

    end

    end

endmodule

module updowncnt(clk, rst, mode, cnt);
    input clk, rst, mode;
    output reg [7:0] cnt;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            cnt <= 8'd0;
        end
        else begin
            if (mode == 0) begin
                if (cnt == 8'd0)
                    cnt <= 8'd153;
                else
                    cnt <= cnt - 1;
            end
            else begin
                if (cnt == 8'd153)
                    cnt <= 8'd0;
                else
                    cnt <= cnt + 1;
            end
        end
    end
endmodule

module top_module(clk, rst, mode, cnt1, seg, segcom);
    input clk,rst,mode;
    output [1:0] cnt1;
    output [6:0] seg;
    output [7:0] segcom;
    wire clk1hz;
    wire clk1khz;
    wire [7:0] cnt_div;
    wire [3:0] dec100, dec10, dec1;
    wire [1:0] scan;
    reg  [3:0] digit;
    reg  [1:0] intseg;
    frq_div  #(.main_clk(50), .output_freq(1))    u_1hz (clk,rst,clk1hz);
    frq_div  #(.main_clk(100), .output_freq(10))  u_1khz (clk,rst,clk1khz);
    updowncnt u_cntup (.clk(clk1hz),.rst(rst),.mode(mode),.cnt(cnt_div));
    int3seg3 u_int3seg3 ( .rst(rst), .int_value(cnt_div),.dec100(dec100),.dec10(dec10), .dec1(dec1));
    cnt13 u_cnt13 (.clk(clk1khz),.rst(rst),.cnt(scan));
    
    assign cnt1 = scan;
     always @(*) begin
        digit  = 4'd0;
        intseg = 2'd0;
        if(cnt1 == 2'd0) begin
            digit  = dec1;
            intseg = 2'd0;
        end
        if(cnt1 == 2'd1) begin
            digit  = dec10;
            intseg = 2'd1;
        end
        if(cnt1 == 2'd2) begin
            digit  = dec100;
            intseg = 2'd2;
        end
    end
    segtest u_segtest ( .num(digit),.intseg(intseg), .seg(seg),.segcom(segcom));


endmodule

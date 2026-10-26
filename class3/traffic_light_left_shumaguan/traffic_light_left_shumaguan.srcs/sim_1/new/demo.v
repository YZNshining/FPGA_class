`timescale 1ns / 1ps

module tb_top_module();

    reg clk;
    reg rst;
    
    wire R1, Y1, G1, LR1, LY1, L1;
    wire R2, Y2, G2, LR2, LY2, L2;
    wire [6:0] seg;
    wire [7:0] segcom;

    top_module uut (
        .clk(clk), 
        .rst(rst),
        .R1(R1), .Y1(Y1), .G1(G1), 
        .LR1(LR1), .LY1(LY1), .L1(L1),
        .R2(R2), .Y2(Y2), .G2(G2), 
        .LR2(LR2), .LY2(LY2), .L2(L2),
        .seg(seg), 
        .segcom(segcom)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk; 
    end

    initial begin
        rst = 0;
        
        #100;
        rst = 1;

        #500_000_000; 
        
        $finish;
    end

endmodule
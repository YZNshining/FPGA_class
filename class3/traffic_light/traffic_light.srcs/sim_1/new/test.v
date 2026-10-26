`timescale 1ns / 1ps

module tb_traffic_light();

    reg clk;
    reg rst;
    wire G1, Y1, R1, G2, Y2, R2;

    traffic_light uut (
        .clk(clk), 
        .rst(rst), 
        .G1(G1), 
        .Y1(Y1), 
        .R1(R1), 
        .G2(G2), 
        .Y2(Y2), 
        .R2(R2)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        rst = 0;
        
        #20;
        rst = 1;

        #1000;
        
        $finish;
    end

endmodule
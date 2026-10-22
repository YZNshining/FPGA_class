`timescale 1ns / 1ps

module tb_top();

    reg clk;
    reg rst;
    reg mode;

    wire [1:0] cnt1;
    wire [6:0] seg;
    wire [7:0] segcom;

    top_module u_top(
        .clk(clk),
        .rst(rst),
        .mode(mode),
        .cnt1(cnt1),
        .seg(seg),
        .segcom(segcom)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        rst = 0;
        mode = 0;

        #100;
        rst = 1;

        #100000;

        mode = 1;

        #100000;

        $finish;
    end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/28 10:17:13
// Design Name: 
// Module Name: tb_addsub
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb_addsub4;
    reg  [3:0] a;
    reg  [3:0] b;
    reg        cin;
    reg        mode;

    wire [3:0] sum;
    wire       cout;
    wire       borrow;

    // 实例化方案二的 addsub4
    addsub4 uut(
        .a(a),
        .b(b),
        .cin(cin),
        .mode(mode),
        .sum(sum),
        .cout(cout),
        .borrow(borrow)
    );

    // 打印信号变化
    initial begin
        $monitor("time=%0t | a=%d b=%d cin=%b mode=%b | sum=%d cout=%b borrow=%b",
                 $time, a, b, cin, mode, sum, cout, borrow);
    end

    // 激励
    initial begin
        // 初始值
        a = 4'd0; b = 4'd0; cin = 1'b0; mode = 1'b0;
        #10;

        // ================= 加法测试 =================
        a = 4'd3;  b = 4'd5;  cin = 1'b0; mode = 1'b0; #10; // 3+5=8,  cout=0, borrow=0
        a = 4'd9;  b = 4'd7;  cin = 1'b1; mode = 1'b0; #10; // 9+7+1=17 -> sum=1, cout=1
        a = 4'd15; b = 4'd15; cin = 1'b0; mode = 1'b0; #10; // 15+15=30 -> sum=14, cout=1

        // ================= 减法测试 =================
        // mode=1 时 cin 被忽略，borrow=1 表示有借位
        a = 4'd9;  b = 4'd5;  cin = 1'b0; mode = 1'b1; #10; // 9-5=4,  cout=1, borrow=0
        a = 4'd5;  b = 4'd9;  cin = 1'b0; mode = 1'b1; #10; // 5-9=-4 -> sum=12, cout=0, borrow=1
        a = 4'd7;  b = 4'd7;  cin = 1'b0; mode = 1'b1; #10; // 7-7=0,  cout=1, borrow=0
        a = 4'd0;  b = 4'd0;  cin = 1'b0; mode = 1'b1; #10; // 0-0=0,  cout=1, borrow=0
        a = 4'd2;  b = 4'd1;  cin = 1'b0; mode = 1'b1; #10; // 2-1=1,  cout=1, borrow=0
        a = 4'd1;  b = 4'd2;  cin = 1'b0; mode = 1'b1; #10; // 1-2=-1 -> sum=15, cout=0, borrow=1

        // 验证 mode=1 时 cin 被忽略
        a = 4'd2;  b = 4'd1;  cin = 1'b1; mode = 1'b1; #10; // 仍是 2-1=1, borrow=0

        #10 $finish;
    end
endmodule

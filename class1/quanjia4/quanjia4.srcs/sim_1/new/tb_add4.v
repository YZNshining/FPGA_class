`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/28 10:00:20
// Design Name: 
// Module Name: tb_add4
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

`timescale 1ns / 1ns
module testbench_add4;
reg [3:0] a,b;
reg cin;
wire [3:0] sum;
wire cout;

add4 uut(
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial begin

    a=4'd0; b=4'd0; cin=0;
    #10 a=4'd3; b=4'd5; cin=0;
    #10 a=4'd9; b=4'd7; cin=1;
    #10 a=4'd15;b=4'd15;cin=1;
    #10 $finish;
end

endmodule


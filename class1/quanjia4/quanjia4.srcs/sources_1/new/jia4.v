`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/28 09:12:41
// Design Name: 
// Module Name: jia4
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

module add4(a,b,cin,sum,cout);
    input [3:0] a,b;
    input cin;
    output reg [3:0] sum;
    output reg cout;
    reg [4:0] carry;
    integer i;
always @(*)begin
    carry[0] = cin;
    for(i=0;i<4;i=i+1)begin
        sum[i] = a[i] ^ b[i] ^ carry[i];
        carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
    end
    cout = carry[4];
end
endmodule

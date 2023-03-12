`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIT MADRAS
// Engineer: SIDDHARTH KOLTE
// 
// Create Date: 11.03.2023 11:03:36
// Design Name: 
// Module Name: clock_divider_tb
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


module clock_divider_tb();
    //Input
    reg clk_50;
    //Output
    wire clk;
    
    clock_divider DUT(.clk_50(clk_50), .clk(clk));
    initial
        begin
            clk_50 = 1'b0;
            forever #10 clk_50 = ~clk_50;
        end
endmodule

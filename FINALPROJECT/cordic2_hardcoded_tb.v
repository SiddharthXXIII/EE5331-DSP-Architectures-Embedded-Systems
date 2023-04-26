`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIT MADRAS
// Engineer: ANANNYAA PATHAK
// Engineer: HEMANT GEDAM
// Engineer: SIDDHARTH KOLTE
// 
// Create Date: 03.04.2023 09:46:54
// Design Name: 
// Module Name: cordic2
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


module cordic2_tb();
    reg clk;
    wire signed [31:0] x_out;
    
    cordic2 vector_mode(x_out,clk);
    
    initial
        begin
               clk = 1'b0; 
               #400 $finish;
        end
     always #1 clk = ~clk;
endmodule

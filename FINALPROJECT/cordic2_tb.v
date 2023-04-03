`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2023 10:28:09
// Design Name: 
// Module Name: cordic2_tb
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
    reg signed [8:0] x_in;
    reg signed [8:0] y_in;
    reg signed [8:0] z_in;
    wire signed [31:0] dummy1;
    wire signed [31:0] dummy2;
    wire signed [31:0] dummy3;
    
    cordic2 vector_mode(.clk(clk),.x_in(x_in),.y_in(y_in),.z_in(z_in),.dummy1(dummy1),.dummy2(dummy2),.dummy3(dummy3));
    
    initial
        begin
            x_in = 0;
            y_in = 0;
            clk = 1'b0;
            
            #1 x_in = 9'd1; y_in = 9'd0; z_in = 9'd180;
            #20 x_in = 9'd1; y_in = 9'd0; z_in = 9'd135;
            #20 x_in = 9'd1; y_in = 9'd0; z_in = -9'd70;
            #20 x_in = 9'd1; y_in = 9'd0; z_in = 9'd70;
        end
        
    initial
        begin
            #400 $finish;
        end
     always #1 clk = ~clk;
endmodule


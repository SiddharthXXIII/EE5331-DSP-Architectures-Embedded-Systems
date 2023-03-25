`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2023 00:04:55
// Design Name: 
// Module Name: cordic_tb
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


module cordic_tb();
    reg clk;
    reg signed [7:0] x_in,y_in;
    wire [31:0] r;
    wire signed [31:0] phi;
    
    cordic vector_mode(.clk(clk),.x_in(x_in),.y_in(y_in),.r(r),.phi(phi));
    
    initial
        begin
            x_in = 0;
            y_in = 0;
            clk = 1'b0;
            
            #1 x_in = 8'd8; y_in = -8'd6;
            #40 x_in = 8'd6; y_in = 8'd8;
           //#2 x_in = -8'd8; y_in = 8'd6; 
        end
        
    initial
        begin
            #400 $finish;
        end
     always #1 clk = ~clk;
endmodule

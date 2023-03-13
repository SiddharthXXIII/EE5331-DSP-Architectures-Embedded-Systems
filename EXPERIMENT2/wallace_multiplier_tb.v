`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIT MADRAS
// Engineer: SIDDHARTH KOTLE
// 
// Create Date: 25.02.2023 21:55:11
// Design Name: 
// Module Name: wallace_multiplier_tb
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


module wallace_multiplier_tb();
     //Inputs
     reg [3:0] a;
     reg [3:0] b;
     //Outputs
     wire [7:0] m;
     
     //Unit Under Test
     wallace_multiplier uut( .a(a), .b(b), .m(m));
     
     initial
        begin
            a = 4'h2;
            b = 4'h4;
            
            #20
            a = 4'h5;
            b = 4'h6;
            
            #20
            a = 4'h7;
            b = 4'h8;
            
            #20 $finish;
        end                    
endmodule

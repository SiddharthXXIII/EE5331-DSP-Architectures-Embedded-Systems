`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIT MADRAS
// Engineer: SIDDHARTH KOLTE
// 
// Create Date: 11.03.2023 10:36:22
// Design Name: 
// Module Name: Johnsons_counter_1_Hz
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
module johnson4bit(q3,q2,q1,q0,clk_50,rst);
    input clk_50, rst;
    output q0,q1,q2,q3;
    
    wire q3bar, q2bar, q1bar, q0bar;
    wire clk;
	 
	clock_divider C1(.clk_50(clk_50), .clk(clk));
	
    
	dflipflop_withreset D3(q3,q3bar,q0bar,rst,clk);
  dflipflop_withreset D2(q2,q2bar,q3,rst,clk);
  dflipflop_withreset D1(q1,q1bar,q2,rst,clk);
  dflipflop_withreset D0(q0,q0bar,q1,rst,clk);
	 
endmodule


module dflipflop_withreset(q, qbar, d, rst, clk);
    input d, rst, clk;
    output reg q,qbar;
    
    always @ (posedge clk)
        begin
            if (~rst)
                begin
                    q <= 1'b0;
                    qbar <= 1'b1;
                end
            else
                begin
                    q <= d;
                    qbar <= (~d);
                end
        end

endmodule


module clock_divider(input clk_50,
                     output reg clk);

    reg [27:0] counter = 28'd0;
    //parameter divisor = 28'd4;
    parameter divisor = 28'd50000000;

    always @(posedge clk_50)
        begin
            counter <= counter + 28'd1;
                
            if(counter >= (divisor - 1))
                counter <= 28'd0;
                
            clk <= (counter < divisor/2) ? 1'b1 : 1'b0;
        end             
endmodule

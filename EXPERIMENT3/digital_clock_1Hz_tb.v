`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIT MADRAS
// Engineer: SIDDHARTH KOLTE
// 
// Create Date: 11.03.2023 12:12:46
// Design Name: 
// Module Name: digital_clock_1Hz_tb
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


module digital_clock_1Hz_tb();
    //Input
    reg clk;
    reg start;
    //Output
    wire sec;
    wire [5:0]minutes;
    wire hours;
    wire clk_60sec;
    wire [5:0]sec_count;
    
    digital_clock_1Hz DUT(.start(start), .clk(clk), .sec(sec), .minutes(minutes), .hours(hours), .clk_60sec(clk_60sec), .sec_count(sec_count));
    initial
        begin
            clk = 1'b0;
            #30;
            forever #10 clk = ~clk;
        end
        
    initial #40 start = 1'b1;    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIT MADRAS
// Engineer: SIDDHARTH KOLTE
// 
// Create Date: 11.03.2023 11:45:45
// Design Name: 
// Module Name: digital_clock_1Hz
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


module digital_clock_1Hz(start, clk, sec, minutes, hours, clk_60sec, sec_count);
    input start;
    input clk;

    output sec;
    output reg [5:0]minutes = 6'd0;
    output reg hours = 1'd0;

    reg [27:0]count = 28'd0; // fill in size of count to generate a 1-Hz clock
    reg clk_1Hz = 1'b0;
    output reg clk_60sec = 1'b0;
    output reg [5:0]sec_count = 6'd0;
    
    //parameter divisor = 28'd5; //Use this for simulation
    parameter divisor = 28'd50000000; // Use this for FPGA implementation
    parameter clock_div = 6'd60;    
    assign sec = clk_1Hz;
    // 1-second clock generating block
    always@(posedge clk)
        begin
            if(start == 1'b0)
                begin
                    count <= 28'd0;
                    clk_1Hz <= !clk_1Hz ;
                end
            else
                begin
                    if(count == ((divisor-2)/2))
                        begin
                            count <= 28'd0;
                            clk_1Hz <= !clk_1Hz;
                        end
                    else
                        count <= count + 28'd1;
                end
        end
    //1-minute clock generating block
    always@(posedge clk_1Hz)
        begin
            if(start == 1'b0)
                begin
                    sec_count <= 6'd0;
                    clk_60sec <= !clk_60sec;
                end
            else
                begin
                    if(sec_count == ((clock_div-2)/2))
                        begin
                            sec_count <= 6'd0;
                            clk_60sec <= !clk_60sec;
                        end
                    else
                        sec_count <= sec_count + 6'd1;
                end
        end

    // minutes and hours counting block
    always@(posedge clk_60sec)
        begin
            if(start == 1'b0)
                begin
                    minutes <= 6'd0;
                    hours <= 1'b0 ;
                end
            else
                begin
                    if(minutes == (clock_div-1))
                        begin
                            minutes <= 6'd0 ;
                            hours <= !hours;
                        end
                    else
                        minutes <= minutes + 6'd1;
                end
        end
endmodule

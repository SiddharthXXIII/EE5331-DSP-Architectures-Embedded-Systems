`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIT MADRAS
// Engineer: SIDDHARTH KOLTE
// 
// Create Date: 22.03.2023 11:14:42
// Design Name: 
// Module Name: cordic
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


module cordic(input clk ,
              input signed [7:0] x_in ,
              input signed [7:0] y_in ,
              output signed [31:0] r ,
              output signed [31:0] phi , 
              output signed [31:0] dummy1,
              output signed [31:0] dummy2,
              output signed [31:0] dummy3);
              
    wire signed [31:0] xc [15:0];
    wire signed [31:0] yc [15:0];
    wire signed [31:0] zc [15:0];
    wire signed [31:0] x_sh ,y_sh;
    wire signed [31:0] x_s;
    
    reg signed [7:0] x,y;
    reg [31:0] z = 32'd0;
    wire signed [31:0] x_rot,y_rot,z_rot;          
    wire signed [31:0] atan0, atan1, atan2, atan3, atan4, atan5, atan6, atan7;
    wire signed [31:0] atan8, atan9, atan10, atan11, atan12, atan13, atan14, atan15;
    
      assign atan0 = 32'd450000;
	  assign atan1 = 32'd265650;
	  assign atan2 = 32'd140362;
	  assign atan3 = 32'd71250;
	  assign atan4 = 32'd35763;
	  assign atan5 = 32'd17899;
	  assign atan6 = 32'd8951;
	  assign atan7 = 32'd4476;
	  assign atan8 = 32'd2238;
	  assign atan9 = 32'd1119;
	  assign atan10 = 32'd559;
	  assign atan11 = 32'd279;
	  assign atan12 = 32'd140;
	  assign atan13 = 32'd70;
	  assign atan14 = 32'd35;
	  assign atan15 = 32'd17;
	
	always @(posedge clk)
	   begin
	       x <= x_in;
	       y <= y_in;
	       z <= 32'd0;
	   end
	
	cordic_rotate rotation(.clk(clk), .x(x), .y(y), .x_rot(x_rot), .y_rot(y_rot), .z_rot(z_rot));   
	
	cordic_update  cordic0(.clk(clk), .i(5'd0), .x(x_rot), .y(y_rot), .z(z_rot), .atan(atan0), .x_next(xc[0]), .y_next(yc[0]), .z_next(zc[0]));
	cordic_update  cordic1(.clk(clk), .i(5'd1), .x(xc[0]), .y(yc[0]), .z(zc[0]), .atan(atan1), .x_next(xc[1]), .y_next(yc[1]), .z_next(zc[1]));
	cordic_update  cordic2(.clk(clk), .i(5'd2), .x(xc[1]), .y(yc[1]), .z(zc[1]), .atan(atan2), .x_next(xc[2]), .y_next(yc[2]), .z_next(zc[2]));
	cordic_update  cordic3(.clk(clk), .i(5'd3), .x(xc[2]), .y(yc[2]), .z(zc[2]), .atan(atan3), .x_next(xc[3]), .y_next(yc[3]), .z_next(zc[3]));
	cordic_update  cordic4(.clk(clk), .i(5'd4), .x(xc[3]), .y(yc[3]), .z(zc[3]), .atan(atan4), .x_next(xc[4]), .y_next(yc[4]), .z_next(zc[4]));
	cordic_update  cordic5(.clk(clk), .i(5'd5), .x(xc[4]), .y(yc[4]), .z(zc[4]), .atan(atan5), .x_next(xc[5]), .y_next(yc[5]), .z_next(zc[5]));
	cordic_update  cordic6(.clk(clk), .i(5'd6), .x(xc[5]), .y(yc[5]), .z(zc[5]), .atan(atan6), .x_next(xc[6]), .y_next(yc[6]), .z_next(zc[6]));
	cordic_update  cordic7(.clk(clk), .i(5'd7), .x(xc[6]), .y(yc[6]), .z(zc[6]), .atan(atan7), .x_next(xc[7]), .y_next(yc[7]), .z_next(zc[7]));
	cordic_update  cordic8(.clk(clk), .i(5'd8), .x(xc[7]), .y(yc[7]), .z(zc[7]), .atan(atan8), .x_next(xc[8]), .y_next(yc[8]), .z_next(zc[8]));
	cordic_update  cordic9(.clk(clk), .i(5'd9), .x(xc[8]), .y(yc[8]), .z(zc[8]), .atan(atan9), .x_next(xc[9]), .y_next(yc[9]), .z_next(zc[9]));
	cordic_update  cordic10(.clk(clk), .i(5'd10), .x(xc[9]), .y(yc[9]), .z(zc[9]), .atan(atan10), .x_next(xc[10]), .y_next(yc[10]), .z_next(zc[10]));
	cordic_update  cordic11(.clk(clk), .i(5'd11), .x(xc[10]), .y(yc[10]), .z(zc[10]), .atan(atan11), .x_next(xc[11]), .y_next(yc[11]), .z_next(zc[11]));
	cordic_update  cordic12(.clk(clk), .i(5'd12), .x(xc[11]), .y(yc[11]), .z(zc[11]), .atan(atan12), .x_next(xc[12]), .y_next(yc[12]), .z_next(zc[12]));
	cordic_update  cordic13(.clk(clk), .i(5'd13), .x(xc[12]), .y(yc[12]), .z(zc[12]), .atan(atan13), .x_next(xc[13]), .y_next(yc[13]), .z_next(zc[13]));
	cordic_update  cordic14(.clk(clk), .i(5'd14), .x(xc[13]), .y(yc[13]), .z(zc[13]), .atan(atan14), .x_next(xc[14]), .y_next(yc[14]), .z_next(zc[14]));
    	cordic_update  cordic15(.clk(clk), .i(5'd15), .x(xc[14]), .y(yc[14]), .z(zc[14]), .atan(atan15), .x_next(xc[15]), .y_next(yc[15]), .z_next(zc[15]));
    	multiplier m1(.clk(clk), .x(xc[15]), .x_s(x_s));
	
    assign dummy1 = xc[15];
    assign dummy2 = yc[15];
    assign dummy3 = zc[15];
    assign r = x_s;
	assign phi = zc[15];
              
endmodule

module cordic_rotate(input clk ,
                     input signed [7:0] x,
                     input signed [7:0] y,
                     output reg signed [31:0] x_rot,
                     output reg signed [31:0] y_rot,
                     output reg signed [31:0] z_rot);
                     
    always @(posedge clk)
        begin
            if( x < 0 && y >= 0 )
                begin
                    x_rot = y*10000;
                    y_rot = -x*10000;
                    z_rot = -900000;
                end
            else if( x < 0 && y < 0 )
                begin
                    x_rot = -y*10000;
                    y_rot = x*10000;
                    z_rot = 900000;                    
                end
            else
                begin
                    x_rot = x*10000;
                    y_rot = y*10000;
                    z_rot = 0;                                        
                end
        end
endmodule

module cordic_update(input clk ,
                     input signed [4:0] i,
                     input signed [31:0] x,
                     input signed [31:0] y,
                     input signed [31:0] z,
                     input signed [31:0] atan,
                     output reg signed [31:0] x_next,
                     output reg signed [31:0] y_next,
                     output reg signed [31:0] z_next);
                     
    always @(posedge clk)
        begin
            x_next = x +{ y > 0 ? (y >>> i) : -(y >>> i)};
            y_next = y +{ y > 0 ? -(x >>> i) : (x >>> i)};
            z_next = z +{ y > 0 ? atan : -atan};
        end
endmodule

module multiplier(input clk,
                  input signed [31:0] x, 
                  output reg signed [31:0] x_s);

    always @(posedge clk) 
        begin
            x_s = {x[31],x[31:1]} + {{3{x[31]}},x[31:3]} - {{6{x[31]}},x[31:6]} - {{9{x[31]}},x[31:9]};
        end
endmodule

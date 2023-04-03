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


module cordic2(input clk ,
              input signed [8:0] x_in ,
              input signed [8:0] y_in ,
              input signed [8:0] z_in , 
              output signed [31:0] dummy1,
              output signed [31:0] dummy2,
              output signed [31:0] dummy3);
              
    wire signed [31:0] xc [7:0];
    wire signed [31:0] yc [7:0];
    wire signed [31:0] zc [7:0];

    wire signed [31:0] x_s [1:0];
    wire signed [31:0] y_s [1:0];
    wire signed [31:0] z_s [1:0];
    
    reg signed [8:0] x,y,z;         

    wire signed [31:0] x_sh ,y_sh;
    assign dummy1 = zc[4];
    assign dummy2 = x_sh;
    assign dummy3 = y_sh;

    always @(posedge clk)
	   begin
	       x <= x_in;
	       y <= y_in;
	       z <= z_in;
	   end
	
	
    cordic_rotate cordic1(.clk(clk), .x(x), .y(y),.z(z), .x_rot(xc[0]), .y_rot(yc[0]), .z_rot(zc[0]));
    cordic_friendly_angle cordic2(.clk(clk), .x(xc[0]), .y(yc[0]), .z(zc[0]), .x_next(xc[1]), .y_next(yc[1]), .z_next(zc[1]));
    multiplier1 m2(.clk(clk), .x(xc[1]), .y(yc[1]), .x_s(x_s[0]), .y_s(y_s[0]));
    cordic_usr cordic3(.clk(clk), .x(x_s[0]), .y(y_s[0]), .z(zc[1]), .x_next(xc[2]), .y_next(yc[2]), .z_next(zc[2]));
    multiplier2 m3(.clk(clk), .x(xc[2]), .y(yc[2]), .x_s(x_s[1]), .y_s(y_s[1]));
    cordic_nominal1 cordic4(.clk(clk), .x(x_s[1]), .y(y_s[1]), .z(zc[2]), .x_next(xc[3]), .y_next(yc[3]), .z_next(zc[3]));
    cordic_nominal2 cordic5(.clk(clk), .x(xc[3]), .y(yc[3]), .z(zc[3]), .x_next(xc[4]), .y_next(yc[4]), .z_next(zc[4]));
  
//    cordic_micro_rotations1 cordic6(.clk(clk), .x(xc[4]), .y(yc[4]), .z(zc[4]), .x_next(xc[5]), .y_next(yc[5]), .z_next(zc[5]));
    
    cordic_nominal3 cordic6(.clk(clk), .x(xc[4]), .y(yc[4]), .z(zc[4]), .x_next(xc[5]), .y_next(yc[5]), .z_next(zc[5]));
    cordic_micro_rotations2 cordic7(.clk(clk), .x(xc[5]), .y(yc[5]), .z(zc[5]), .x_next(xc[6]), .y_next(yc[6]), .z_next(zc[6]));
    normalize n1(.clk(clk), .x(xc[6]), .y(yc[6]), .z(z), .x_next(x_sh), .y_next(y_sh));
    
endmodule

module cordic_rotate(input clk ,
                     input signed [8:0] x,
                     input signed [8:0] y,
                     input signed [8:0] z,
                     output reg signed [31:0] x_rot,
                     output reg signed [31:0] y_rot,
                     output reg signed [31:0] z_rot);
                     
    always @(*)
        begin
            if( z < -135 && x || y)
                begin
                    x_rot = -x*10000;
                    y_rot = -y*10000;
                    z_rot = (z*10000) + 1800000;
                end
            else if(z >= -135 && z < -45 && x || y)
                begin
                    x_rot = -y*10000;
                    y_rot = x*10000;
                    z_rot = z*10000 + 900000;  
                end
            else if(z >= -45 && z < 45 && x || y)
                begin
                    x_rot = x*10000;
                    y_rot = y*10000;
                    z_rot = z*10000;                                        
                end
            else if( z >= 45 && z < 135 && x || y)
                begin
                    x_rot = y*10000;
                    y_rot = -x*10000;
                    z_rot = (z*10000) - 900000;                    
                end
            else if(z >= 135 && x || y)
                begin
                    x_rot = -x*10000;
                    y_rot = -y*10000;
                    z_rot = (z*10000) - 1800000;
                end
        end                     
endmodule

module cordic_friendly_angle(input clk ,
                             input signed [31:0] x,
                             input signed [31:0] y,
                             input signed [31:0] z,
                             output reg signed [31:0] x_next,
                             output reg signed [31:0] y_next,
                             output reg signed [31:0] z_next);
                     
    wire signed [31:0] atan0, atan1, atan2;
    assign atan0 = 32'd0;
	assign atan1 = 32'd162600;
	assign atan2 = 32'd368700;
	
    always @(*)
        begin
            if( z < -265650)
                begin
                    x_next = 20*x - 15*y;
                    y_next = 20*y + 15*x;
                    z_next = z + atan2;                    
                end
            else if(z >= -265650 && z < -103050)
                begin
                    x_next = 24*x - 7*y;
                    y_next = 24*y + 7*x;
                    z_next = z + atan1;                    
                end
            else if(z >= -103050 && z < 103050)
                begin
                    x_next = 25*x + 0*y;
                    y_next = 25*y - 0*x;                    
                    z_next = z + atan0;
                end
            else if( z >= 103050 && z < 265650)
                begin
                    x_next = 24*x + 7*y;
                    y_next = 24*y - 7*x;
                    z_next = z - atan1;                    
                end
            else if(z >= 265650)
                begin
                    x_next = 20*x + 15*y;
                    y_next = 20*y - 15*x;
                    z_next = z - atan2;
                end
        end
endmodule

module multiplier1(input clk,
                  input signed [31:0] x,y, 
                  output reg signed [31:0] x_s,
                  output reg signed [31:0] y_s);

    always @(*) 
        begin
            x_s = {{5{x[31]}},x[31:5]} + {{6{x[31]}},x[31:6]} - {{8{x[31]}},x[31:8]} - {{9{x[31]}},x[31:9]} - {{10{x[31]}},x[31:10]};
            y_s = {{5{y[31]}},y[31:5]} + {{6{y[31]}},y[31:6]} - {{8{y[31]}},y[31:8]} - {{9{y[31]}},y[31:9]} - {{10{y[31]}},y[31:10]};
        end
endmodule

module cordic_usr(input clk ,
                             input signed [31:0] x,
                             input signed [31:0] y,
                             input signed [31:0] z,
                             output reg signed [31:0] x_next,
                             output reg signed [31:0] y_next,
                             output reg signed [31:0] z_next);
                     
    wire signed [31:0] atan0, atan1;
    assign atan0 = 32'd0;
	assign atan1 = 32'd71250;
	
    always @(*)
        begin
            if( z < -35630)
                begin
                    x_next = 128*x - 16*y;
                    y_next = 128*y + 16*x;
                    z_next = z + atan1;                    
                end
            else if(z >= -35630 && z < 35630)
                begin
                    x_next = 129*x + 0*y;
                    y_next = 129*y - 0*x;                    
                    z_next = z + atan0;
                end
            else if( z > 35630)
                begin
                    x_next = 128*x + 16*y;
                    y_next = 128*y - 16*x;
                    z_next = z - atan1;                    
                end
        end
endmodule

module multiplier2(input clk,
                  input signed [31:0] x,y, 
                  output reg signed [31:0] x_s,
                  output reg signed [31:0] y_s);

    always @(*) 
        begin
            x_s = {{7{x[31]}},x[31:7]} - {{14{x[31]}},x[31:14]};
            y_s = {{7{y[31]}},y[31:7]} + {{14{y[31]}},y[31:14]};
        end
endmodule

module cordic_nominal1(input clk ,
                             input signed [31:0] x,
                             input signed [31:0] y,
                             input signed [31:0] z,
                             output reg signed [31:0] x_next,
                             output reg signed [31:0] y_next,
                             output reg signed [31:0] z_next);
                     
    wire signed [31:0] atan0;
    assign atan0 = 32'd17900;
	
    always @(*)
        begin
            if( z < 0)
                begin
                    x_next = x - (y >>> 5);
                    y_next = y + (x >>> 5);
                    z_next = z + atan0;                    
                end
            else if(z >= 0)
                begin
                    x_next = x + (y >>> 5);
                    y_next = y - (x >>> 5);
                    z_next = z - atan0;                
                end
        end
endmodule

module cordic_nominal2(input clk ,
                             input signed [31:0] x,
                             input signed [31:0] y,
                             input signed [31:0] z,
                             output reg signed [31:0] x_next,
                             output reg signed [31:0] y_next,
                             output reg signed [31:0] z_next);
                     
    wire signed [31:0] atan0;
    assign atan0 = 32'd8950;
	
    always @(*)
        begin
            if( z < 0)
                begin
                    x_next = x - (y >>> 6);
                    y_next = y + (x >>> 6);
                    z_next = z + atan0;                    
                end
            else if(z >= 0)
                begin
                    x_next = x + (y >>> 6);
                    y_next = y - (x >>> 6);
                    z_next = z - atan0;                
                end
        end
endmodule

module cordic_nominal3(input clk ,
                             input signed [31:0] x,
                             input signed [31:0] y,
                             input signed [31:0] z,
                             output reg signed [31:0] x_next,
                             output reg signed [31:0] y_next,
                             output reg signed [31:0] z_next);
                     
    wire signed [31:0] atan0;
    assign atan0 = 32'd4480;
	
    always @(*)
        begin
            if( z < 0)
                begin
                    x_next = x - (y >>> 7);
                    y_next = y + (x >>> 7);
                    z_next = z + atan0;                    
                end
            else if(z >= 0)
                begin
                    x_next = x + (y >>> 7);
                    y_next = y - (x >>> 7);
                    z_next = z - atan0;                
                end
        end
endmodule

module cordic_micro_rotations1(input clk ,
                             input signed [31:0] x,
                             input signed [31:0] y,
                             input signed [31:0] z,
                             output reg signed [31:0] x_next,
                             output reg signed [31:0] y_next,
                             output reg signed [31:0] z_next);
                     
    wire signed [31:0] atan0;
    assign atan0 = 32'd1120;
	
    always @(*)
        begin
            if( z < -8960)
                begin
                    x_next = x - 8*(y >>> 9);
                    y_next = y + 8*(x >>> 9);
                    z_next = z + 8*atan0;                    
                end
            else if(z >= -8960 && z < -7840)
                begin
                    x_next = x - 7*(y >>> 9);
                    y_next = y + 7*(x >>> 9);
                    z_next = z + 7*atan0;                    
                end
            else if(z >= -7840 && z < -6720)
                begin
                    x_next = x - 6*(y >>> 9);
                    y_next = y + 6*(x >>> 9);
                    z_next = z + 6*atan0;                    
                end
            else if(z >= -6720 && z < -5600)
                begin
                    x_next = x - 5*(y >>> 9);
                    y_next = y + 5*(x >>> 9);
                    z_next = z + 5*atan0;                    
                end
            else if(z >= -5600 && z < -4480)
                begin
                    x_next = x - 4*(y >>> 9);
                    y_next = y + 4*(x >>> 9);
                    z_next = z + 4*atan0;                    
                end
            else if(z >= -4480 && z < -3360)
                begin
                    x_next = x - 3*(y >>> 9);
                    y_next = y + 3*(x >>> 9);
                    z_next = z + 3*atan0;                    
                end
            else if(z >= -3360 && z < -2240)
                begin
                    x_next = x - 2*(y >>> 9);
                    y_next = y + 2*(x >>> 9);
                    z_next = z + 2*atan0;                    
                end
            else if(z >= -2240 && z < -1120)
                begin
                    x_next = x - 1*(y >>> 9);
                    y_next = y + 1*(x >>> 9);
                    z_next = z + 1*atan0;                    
                end
            else if(z >= -1120 && z < +1120)
                begin
                    x_next = x - 0*(y >>> 9);
                    y_next = y + 0*(x >>> 9);
                    z_next = z + 0*atan0;                    
                end
            else if(z >= 1120 && z < 2240)
                begin
                    x_next = x + 1*(y >>> 9);
                    y_next = y - 1*(x >>> 9);
                    z_next = z - 1*atan0;                    
                end
            else if(z >= 2240 && z < 3360)
                begin
                    x_next = x + 2*(y >>> 9);
                    y_next = y - 2*(x >>> 9);
                    z_next = z - 2*atan0;                    
                end
            else if(z >= 3360 && z < 4480)
                begin
                    x_next = x + 3*(y >>> 9);
                    y_next = y - 3*(x >>> 9);
                    z_next = z - 3*atan0;                    
                end
            else if(z >= 4480 && z < 5600)
                begin
                    x_next = x + 4*(y >>> 9);
                    y_next = y - 4*(x >>> 9);
                    z_next = z - 4*atan0;                    
                end
            else if(z >= 5600 && z < 6720)
                begin
                    x_next = x + 5*(y >>> 9);
                    y_next = y - 5*(x >>> 9);
                    z_next = z - 5*atan0;                    
                end 
            else if(z >= 6720 && z < 7840)
                begin
                    x_next = x + 6*(y >>> 9);
                    y_next = y - 6*(x >>> 9);
                    z_next = z - 6*atan0;                    
                end
            else if(z >= 7840 && z < 8960)
                begin
                    x_next = x + 7*(y >>> 9);
                    y_next = y - 7*(x >>> 9);
                    z_next = z - 7*atan0;                    
                end
            else if(z >= 8960)
                begin
                    x_next = x + 8*(y >>> 9);
                    y_next = y - 8*(x >>> 9);
                    z_next = z - 8*atan0;                    
                end
        end
endmodule
        
module cordic_micro_rotations2(input clk ,
                             input signed [31:0] x,
                             input signed [31:0] y,
                             input signed [31:0] z,
                             output reg signed [31:0] x_next,
                             output reg signed [31:0] y_next,
                             output reg signed [31:0] z_next);
                     
    wire signed [31:0] atan0;
    assign atan0 = 32'd560;
	
    always @(*)
        begin
            if( z < -4480)
                begin
                    x_next = x - 8*(y >>> 10);
                    y_next = y + 8*(x >>> 10);
                    z_next = z + 8*atan0;                    
                end
            else if(z >= -4480 && z < -3920)
                begin
                    x_next = x - 7*(y >>> 10);
                    y_next = y + 7*(x >>> 10);
                    z_next = z + 7*atan0;                    
                end
            else if(z >= -3920 && z < -3360)
                begin
                    x_next = x - 6*(y >>> 10);
                    y_next = y + 6*(x >>> 10);
                    z_next = z + 6*atan0;                    
                end
            else if(z >= -3360 && z < -2800)
                begin
                    x_next = x - 5*(y >>> 10);
                    y_next = y + 5*(x >>> 10);
                    z_next = z + 5*atan0;                    
                end
            else if(z >= -2800 && z < -2240)
                begin
                    x_next = x - 4*(y >>> 10);
                    y_next = y + 4*(x >>> 10);
                    z_next = z + 4*atan0;                    
                end
            else if(z >= -2240 && z < -1680)
                begin
                    x_next = x - 3*(y >>> 10);
                    y_next = y + 3*(x >>> 10);
                    z_next = z + 3*atan0;                    
                end
            else if(z >= -1680 && z < -1120)
                begin
                    x_next = x - 2*(y >>> 10);
                    y_next = y + 2*(x >>> 10);
                    z_next = z + 2*atan0;                    
                end
            else if(z >= -1120 && z < -560)
                begin
                    x_next = x - 1*(y >>> 10);
                    y_next = y + 1*(x >>> 10);
                    z_next = z + 1*atan0;                    
                end
            else if(z >= -560 && z < +560)
                begin
                    x_next = x - 0*(y >>> 10);
                    y_next = y + 0*(x >>> 10);
                    z_next = z + 0*atan0;                    
                end
            else if(z >= 560 && z < 1120)
                begin
                    x_next = x + 1*(y >>> 10);
                    y_next = y - 1*(x >>> 10);
                    z_next = z - 1*atan0;                    
                end
            else if(z >= 1120 && z < 1680)
                begin
                    x_next = x + 2*(y >>> 10);
                    y_next = y - 2*(x >>> 10);
                    z_next = z - 2*atan0;                    
                end
            else if(z >= 1680 && z < 2240)
                begin
                    x_next = x + 3*(y >>> 10);
                    y_next = y - 3*(x >>> 10);
                    z_next = z - 3*atan0;                    
                end
            else if(z >= 2240 && z < 2800)
                begin
                    x_next = x + 4*(y >>> 10);
                    y_next = y - 4*(x >>> 10);
                    z_next = z - 4*atan0;                    
                end
            else if(z >= 2800 && z < 3360)
                begin
                    x_next = x + 5*(y >>> 10);
                    y_next = y - 5*(x >>> 10);
                    z_next = z - 5*atan0;                    
                end 
            else if(z >= 3360 && z < 3920)
                begin
                    x_next = x + 6*(y >>> 10);
                    y_next = y - 6*(x >>> 10);
                    z_next = z - 6*atan0;                    
                end
            else if(z >= 3920 && z < 4480)
                begin
                    x_next = x + 7*(y >>> 10);
                    y_next = y - 7*(x >>> 10);
                    z_next = z - 7*atan0;                    
                end
            else if(z >= 4480)
                begin
                    x_next = x + 8*(y >>> 10);
                    y_next = y - 8*(x >>> 10);
                    z_next = z - 8*atan0;                    
                end
        end
endmodule

module normalize(input clk ,
                             input signed [31:0] x,
                             input signed [31:0] y,
                             input signed [8:0] z,
                             output reg signed [31:0] x_next,
                             output reg signed [31:0] y_next);

    always @(posedge clk)
        begin
            if(z > -180 && z <= -90)
                begin
                    x_next = { x > 0 ? -x : x};
                    y_next = { y > 0 ? -y : y};
                end
            else if(z > -90 && z <= 0)
                begin
                    x_next = { x > 0 ? x : -x};
                    y_next = { y > 0 ? -y : y};
                end
            else if(z > 0 && z <= 90)
                begin
                    x_next = { x > 0 ? x : -x};
                    y_next = { y > 0 ? y : -y};
                end
            else if(z > 90 && z <= 180)
                begin
                    x_next = { x > 0 ? -x : x};
                    y_next = { y > 0 ? y : -y};                    
                end
        end                                   
endmodule

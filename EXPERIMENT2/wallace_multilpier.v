`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIT MADRAS
// Engineer: SIDDHARTH KOLTE
// 
// Create Date: 25.02.2023 18:52:14
// Design Name: 
// Module Name: wallace_multiplier
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


module wallace_multiplier(m);
   
    //Uncomment the input for simulation and change the module defination 
    //input [3:0]a,b;
    output [7:0]m ;
    wire [3:0]p0, p1, p2, p3;
    wire s5, s4,s3,s2,s1,s0;
    wire c5, c4,c3,c2,c1,c0;
    wire c6, c7,c8;
    wire k1, k2, l1, l2;
    
    //Hard coding for LCD display. Comment it for simulation part
    assign a = 4'h2;
    assign b = 4'h7;
	
    assign p0 = {a[0], a[0], a[0], a[0]} & b;
    assign p1 = {a[1], a[1], a[1], a[1]} & b;
    assign p2 = {a[2], a[2], a[2], a[2]} & b;
    assign p3 = {a[3], a[3], a[3], a[3]} & b;
    
    half_add h1( .x1(p0[1]), .x2(p1[0]), .z_s(s0), .z_c(c0));
    
    full_add f1( .x1(p0[2]), .x2(p1[1]), .x3(p2[0]), .z_s(s1), .z_c(c1));
    
    half_add h3( .x1(p3[0]), .x2(p2[1]), .z_s(k1), .z_c(l1));
    full_add f2( .x1(p0[3]), .x2(p1[2]), .x3(k1), .z_s(s2), .z_c(c2));
    
    half_add h4( .x1(p3[1]), .x2(p2[2]), .z_s(k2), .z_c(l2));
    full_add f3( .x1(p1[3]), .x2(k2), .x3(l1), .z_s(s3), .z_c(c3));
    
    full_add f4( .x1(p2[3]), .x2(p3[2]), .x3(l2), .z_s(s4), .z_c(c4));
    
    assign m[0] = p0[0];
    assign m[1] = s0;
    half_add h5( .x1(s1), .x2(c0), .z_s(m[2]), .z_c(c5));
    full_add f5( .x1(s2), .x2(c1), .x3(c5), .z_s(m[3]), .z_c(c6));
    full_add f6( .x1(s3), .x2(c2), .x3(c6), .z_s(m[4]), .z_c(c7));
    full_add f7( .x1(s4), .x2(c3), .x3(c7), .z_s(m[5]), .z_c(c8));
    full_add f8( .x1(p3[3]), .x2(c4), .x3(c8), .z_s(m[6]), .z_c(m[7]));
    
    
endmodule

module half_add(input x1,
                input x2,
                output z_s,
                output z_c);

    assign {z_c,z_s} = x1 + x2;
endmodule

module full_add(input x1,
                input x2,
                input x3,
                output z_s,
                output z_c);

    assign {z_c,z_s} = x1 + x2 + x3;
endmodule

module lcd_display (clk, sf_ce0, lcd_rs, lcd_rw, lcd_e, lcd_4, lcd_5, lcd_6, lcd_7,a);
    parameter k = 18;
    input clk; // synthesis attribute PERIOD clk "50 MHz"
    reg [k+8-1:0] count=0;
    output reg sf_ce0; // high for full LCD access
    reg lcd_busy=1;
    reg lcd_stb;
    reg [5:0] lcd_code;
    reg [6:0] lcd_stuff;
    output reg lcd_rs;
    output reg lcd_rw;
    output reg lcd_7;
    output reg lcd_6;
    output reg lcd_5;
    output reg lcd_4;
    output reg lcd_e;
    input [7:0]a;
    reg [3:0]a1;
    always @ (posedge clk) begin
        count <= count + 1;
        sf_ce0 <= 1;
        case (count[k+7:k+2])
            0: lcd_code <= 6'h03; // power-on initialization; see page 53 in Spartan 3e user guide
            1: lcd_code <= 6'h03;
            2: lcd_code <= 6'h03;
            3: lcd_code <= 6'h02;
            4: lcd_code <= 6'h02; // function set upper nibble (see Table 5-3 in page 49)
            5: lcd_code <= 6'h08; // function set lower nibble
            6: lcd_code <= 6'h00; // entry mode set upper nibble (see Table 5-3 in page 48)
            7: lcd_code <= 6'h06; // entry mode set lower nibble
            8: lcd_code <= 6'h00; // display on/off control upper nibble (see Table 5-3 in page 48)
            9: lcd_code <= 6'h0C; // display on/off control lower nibble
            10: lcd_code <= 6'h00; // display clear upper nibble (see Table 5-3 in page 48)
            11: lcd_code <= 6'h01; // display clear lower nibble
            12: begin lcd_code[5:4] <= 2'h2; // {lcd_rs,lcd_rw} = lcd_code[5:4] (see Table 5-1 in page 44)
                    if(a[7:4] > 4'd9) // Detect whether 'a[7:4]' is number (0-9) or character (A-F)
                    begin
                        a1 <= a[7:4] - 4'd9;
                        lcd_code[3:0] <= 4'h4; // Upper nibble to display characters A to F (see Fig. 5-4)
                    end
                    else begin
                        a1 <= a[7:4];
                        lcd_code[3:0] <= 4'h3; end // Upper nibble to display digits 0 to 9 (see Fig. 5-4)
                    end
           13: lcd_code <= {2'h2, a1} ; // Lower nibble to display characters A to F (see Fig. 5-4)
           14: begin lcd_code[3:0] <= 2'h2;
                if(a[3:0] > 4'd9)
                begin
                    a1 <= a[3:0] - 4'd9;
                    lcd_code[3:0] <= 4'h4;
                end
                else begin
                    a1 <= a[3:0] ;
                    lcd_code[3:0] <= 4'h3; end
                end
           15: lcd_code <= {2'h2, a1} ;
           default: lcd_code <= 6'h10;
        endcase
        //if (lcd_rw) // comment-out for repeating display
        // lcd_busy <= 0; // comment-out for repeating display
        lcd_stb <= ^count[k+1:k+0] & ~lcd_rw & lcd_busy; // clkrate / 2^(k+2)
        lcd_stuff <= {lcd_stb,lcd_code};
        {lcd_e,lcd_rs,lcd_rw,lcd_7,lcd_6,lcd_5,lcd_4} <= lcd_stuff;
    end
endmodule

module top(clk, sf_ce0, lcd_rs, lcd_rw, lcd_e, lcd_4, lcd_5, lcd_6, lcd_7);
    input clk; // synthesis attribute PERIOD clk "50 MHz"
    output sf_ce0; // high for full LCD access
    output lcd_rs;
    output lcd_rw;
    output lcd_7;
    output lcd_6;
    output lcd_5;
    output lcd_4;
    output lcd_e;

    wire [7:0] x,m;
    
    wallace_multiplier DUT (m);

    assign x=m;
    lcd_display ld1 (clk, sf_ce0, lcd_rs, lcd_rw, lcd_e, lcd_4, lcd_5, lcd_6, lcd_7,x);
    
endmodule

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

    wire [31:0] x,m;

    assign m = 32'hFFFFFFFF;


    assign x=m;
    lcd_display ld1 (clk, sf_ce0, lcd_rs, lcd_rw, lcd_e, lcd_4, lcd_5, lcd_6, lcd_7,x);
    
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
    input [31:0]a;
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
                    if(a[31:28] > 4'd9) // Detect whether 'a[7:4]' is number (0-9) or character (A-F)
                    begin
                        a1 <= a[31:28] - 4'd9;
                        lcd_code[3:0] <= 4'h4; // Upper nibble to display characters A to F (see Fig. 5-4)
                    end
                    else begin
                        a1 <= a[31:28];
                        lcd_code[3:0] <= 4'h3; end // Upper nibble to display digits 0 to 9 (see Fig. 5-4)
                    end
            13: lcd_code <= {2'h2, a1} ; // Lower nibble to display characters A to F (see Fig. 5-4)
            14: begin lcd_code[5:4] <= 2'h2; // {lcd_rs,lcd_rw} = lcd_code[5:4] (see Table 5-1 in page 44)
                    if(a[27:24] > 4'd9) // Detect whether 'a[7:4]' is number (0-9) or character (A-F)
                    begin
                        a1 <= a[27:24] - 4'd9;
                        lcd_code[3:0] <= 4'h4; // Upper nibble to display characters A to F (see Fig. 5-4)
                    end
                    else begin
                        a1 <= a[27:24];
                        lcd_code[3:0] <= 4'h3; end // Upper nibble to display digits 0 to 9 (see Fig. 5-4)
                    end
            15: lcd_code <= {2'h2, a1} ; // Lower nibble to display characters A to F (see Fig. 5-4)
            16: begin lcd_code[5:4] <= 2'h2; // {lcd_rs,lcd_rw} = lcd_code[5:4] (see Table 5-1 in page 44)
                    if(a[23:20] > 4'd9) // Detect whether 'a[7:4]' is number (0-9) or character (A-F)
                    begin
                        a1 <= a[23:20] - 4'd9;
                        lcd_code[3:0] <= 4'h4; // Upper nibble to display characters A to F (see Fig. 5-4)
                    end
                    else begin
                        a1 <= a[23:20];
                        lcd_code[3:0] <= 4'h3; end // Upper nibble to display digits 0 to 9 (see Fig. 5-4)
                    end
            17: lcd_code <= {2'h2, a1} ; // Lower nibble to display characters A to F (see Fig. 5-4)
            18: begin lcd_code[3:0] <= 2'h2;
                if(a[19:16] > 4'd9)
                begin
                    a1 <= a[19:16] - 4'd9;
                    lcd_code[3:0] <= 4'h4;
                end
                else begin
                    a1 <= a[19:16] ;
                    lcd_code[3:0] <= 4'h3; end
                end
            19: lcd_code <= {2'h2, a1} ;
            20: begin lcd_code[5:4] <= 2'h2; // {lcd_rs,lcd_rw} = lcd_code[5:4] (see Table 5-1 in page 44)
                    if(a[15:12] > 4'd9) // Detect whether 'a[7:4]' is number (0-9) or character (A-F)
                    begin
                        a1 <= a[15:12] - 4'd9;
                        lcd_code[3:0] <= 4'h4; // Upper nibble to display characters A to F (see Fig. 5-4)
                    end
                    else begin
                        a1 <= a[15:12];
                        lcd_code[3:0] <= 4'h3; end // Upper nibble to display digits 0 to 9 (see Fig. 5-4)
                    end
            21: lcd_code <= {2'h2, a1} ; // Lower nibble to display characters A to F (see Fig. 5-4)
            22: begin lcd_code[5:4] <= 2'h2; // {lcd_rs,lcd_rw} = lcd_code[5:4] (see Table 5-1 in page 44)
                    if(a[11:8] > 4'd9) // Detect whether 'a[7:4]' is number (0-9) or character (A-F)
                    begin
                        a1 <= a[11:8] - 4'd9;
                        lcd_code[3:0] <= 4'h4; // Upper nibble to display characters A to F (see Fig. 5-4)
                    end
                    else begin
                        a1 <= a[11:8];
                        lcd_code[3:0] <= 4'h3; end // Upper nibble to display digits 0 to 9 (see Fig. 5-4)
                    end
            23: lcd_code <= {2'h2, a1} ; // Lower nibble to display characters A to F (see Fig. 5-4)
            24: begin lcd_code[5:4] <= 2'h2; // {lcd_rs,lcd_rw} = lcd_code[5:4] (see Table 5-1 in page 44)
                    if(a[7:4] > 4'd9) // Detect whether 'a[7:4]' is number (0-9) or character (A-F)
                    begin
                        a1 <= a[7:4] - 4'd9;
                        lcd_code[3:0] <= 4'h4; // Upper nibble to display characters A to F (see Fig. 5-4)
                    end
                    else begin
                        a1 <= a[7:4];
                        lcd_code[3:0] <= 4'h3; end // Upper nibble to display digits 0 to 9 (see Fig. 5-4)
                    end
            25: lcd_code <= {2'h2, a1} ; // Lower nibble to display characters A to F (see Fig. 5-4)
            26: begin lcd_code[5:4] <= 2'h2; // {lcd_rs,lcd_rw} = lcd_code[5:4] (see Table 5-1 in page 44)
                    if(a[3:0] > 4'd9) // Detect whether 'a[7:4]' is number (0-9) or character (A-F)
                    begin
                        a1 <= a[3:0] - 4'd9;
                        lcd_code[3:0] <= 4'h4; // Upper nibble to display characters A to F (see Fig. 5-4)
                    end
                    else begin
                        a1 <= a[3:0];
                        lcd_code[3:0] <= 4'h3; end // Upper nibble to display digits 0 to 9 (see Fig. 5-4)
                    end
            27: lcd_code <= {2'h2, a1} ; // Lower nibble to display characters A to F (see Fig. 5-4)
           default: lcd_code <= 6'h10;
        endcase
        //if (lcd_rw) // comment-out for repeating display
        // lcd_busy <= 0; // comment-out for repeating display
        lcd_stb <= ^count[k+1:k+0] & ~lcd_rw & lcd_busy; // clkrate / 2^(k+2)
        lcd_stuff <= {lcd_stb,lcd_code};
        {lcd_e,lcd_rs,lcd_rw,lcd_7,lcd_6,lcd_5,lcd_4} <= lcd_stuff;
    end
endmodule
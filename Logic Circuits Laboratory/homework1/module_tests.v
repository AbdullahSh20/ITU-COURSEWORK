`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//Abdullah Jafar Mansour Shamout 150200919
//Muhammed Yusuf Mermer 150220762
//////////////////////////////////////////////////////////////////////////////////

module and_module_test();
    reg in1;
    reg in2;
    
    wire o;
    
    and_module uut(in1,in2,o);
    
    initial begin
    in1=0;  in2=0;   #250;
    in1=0;  in2=1;   #250;
    in1=1;  in2=0;   #250;
    in1=1;  in2=1;   #250;
    end
endmodule

module or_module_test();
    reg in1;
    reg in2;
    
    wire o;
    
    or_module uut(in1,in2,o);
    
    initial begin
    in1=0;  in2=0;   #250;
    in1=0;  in2=1;   #250;
    in1=1;  in2=0;   #250;
    in1=1;  in2=1;   #250;
    end
endmodule

module not_module_test();
    reg in1;
    
    wire o;
    
    not_module uut(in1,o);
    
    initial begin
    in1=0;  #500;
    in1=1;  #500;
    end
endmodule

module nand_module_test();
    reg in1;
    reg in2;
    
    wire o;
    
    nand_module uut(in1,in2,o);
    
    initial begin
    in1=0;  in2=0;   #250;
    in1=0;  in2=1;   #250;
    in1=1;  in2=0;   #250;
    in1=1;  in2=1;   #250;
    end
endmodule

module xor_module_test();
    reg in1;
    reg in2;
    
    wire o;
    
    xor_module uut(in1,in2,o);
    
    initial begin
    in1=0;  in2=0;   #250;
    in1=0;  in2=1;   #250;
    in1=1;  in2=0;   #250;
    in1=1;  in2=1;   #250;
    end
endmodule

module decoder_3to8_module_test();
    reg in1;
    reg in2;
    reg in3;
    
    wire o1,o2,o3,o4,o5,o6,o7,o8;
    
    decoder_3to8_module uut(in1,in2,in3,o1,o2,o3,o4,o5,o6,o7,o8);
    
    initial begin
    in1=0;  in2=0;   in3=0;  #125;
    in1=0;  in2=0;   in3=1;  #125;
    in1=0;  in2=1;   in3=0;  #125;
    in1=0;  in2=1;   in3=1;  #125;
    in1=1;  in2=0;   in3=0;  #125;
    in1=1;  in2=0;   in3=1;  #125;
    in1=1;  in2=1;   in3=0;  #125;
    in1=1;  in2=1;   in3=1;  #125;
    end
endmodule

module prelim_1_d_test();
    reg a;
    reg b;
    reg c;
    reg d;
    wire o;
    prelim_1_d uut(a,b,c,d,o);

    initial begin
    a=0;  b=0;   c=0; d=0; #60;
    a=0;  b=0;   c=1; d=0; #60;
    a=0;  b=1;   c=0; d=0; #60;
    a=0;  b=1;   c=1; d=0; #60;
    a=1;  b=0;   c=0; d=0; #60;
    a=1;  b=0;   c=1; d=0; #60;
    a=1;  b=1;   c=0; d=0; #60;
    a=1;  b=1;   c=1; d=0; #60;
    a=0;  b=0;   c=0; d=1; #60;
    a=0;  b=0;   c=1; d=1; #60;
    a=0;  b=1;   c=0; d=1; #60;
    a=0;  b=1;   c=1; d=1; #60;
    a=1;  b=0;   c=0; d=1; #60;
    a=1;  b=0;   c=1; d=1; #60;
    a=1;  b=1;   c=0; d=1; #60;
    a=1;  b=1;   c=1; d=1; #60;
    end
endmodule


module prelim_1_e_test ();
    reg a;
    reg b;
    reg c;
    reg d;
    wire o;
    prelim_1_e uut(a,b,c,d,o);

    initial begin
    a=0;  b=0;   c=0; d=0; #60;
    a=0;  b=0;   c=1; d=0; #60;
    a=0;  b=1;   c=0; d=0; #60;
    a=0;  b=1;   c=1; d=0; #60;
    a=1;  b=0;   c=0; d=0; #60;
    a=1;  b=0;   c=1; d=0; #60;
    a=1;  b=1;   c=0; d=0; #60;
    a=1;  b=1;   c=1; d=0; #60;
    a=0;  b=0;   c=0; d=1; #60;
    a=0;  b=0;   c=1; d=1; #60;
    a=0;  b=1;   c=0; d=1; #60;
    a=0;  b=1;   c=1; d=1; #60;
    a=1;  b=0;   c=0; d=1; #60;
    a=1;  b=0;   c=1; d=1; #60;
    a=1;  b=1;   c=0; d=1; #60;
    a=1;  b=1;   c=1; d=1; #60;
    end

endmodule

module prelim_1_f_test();

    reg a;
    reg b;
    reg c;
    reg d;
    wire o;
    prelim_1_f uut(a,b,c,d,o);

    initial begin
    a=0;  b=0;   c=0; d=0; #60;
    a=0;  b=0;   c=1; d=0; #60;
    a=0;  b=1;   c=0; d=0; #60;
    a=0;  b=1;   c=1; d=0; #60;
    a=1;  b=0;   c=0; d=0; #60;
    a=1;  b=0;   c=1; d=0; #60;
    a=1;  b=1;   c=0; d=0; #60;
    a=1;  b=1;   c=1; d=0; #60;
    a=0;  b=0;   c=0; d=1; #60;
    a=0;  b=0;   c=1; d=1; #60;
    a=0;  b=1;   c=0; d=1; #60;
    a=0;  b=1;   c=1; d=1; #60;
    a=1;  b=0;   c=0; d=1; #60;
    a=1;  b=0;   c=1; d=1; #60;
    a=1;  b=1;   c=0; d=1; #60;
    a=1;  b=1;   c=1; d=1; #60;
    end

endmodule

module F2_module_test();
    reg a;
    reg b;
    reg c;
    
    wire o;
    
    F2 uut(a,b,c,o);
    
    initial begin
    a=0;  b=0;   c=0;  #125;
    a=0;  b=0;   c=1;  #125;
    a=0;  b=1;   c=0;  #125;
    a=0;  b=1;   c=1;  #125;
    a=1;  b=0;   c=0;  #125;
    a=1;  b=0;   c=1;  #125;
    a=1;  b=1;   c=0;  #125;
    a=1;  b=1;   c=1;  #125;
    end
endmodule


module F3_module_test();
    reg a;
    reg b;
    reg c;
    
    wire o;
    
    F3 uut(a,b,c,o);
    
    initial begin
    a=0;  b=0;   c=0;  #125;
    a=0;  b=0;   c=1;  #125;
    a=0;  b=1;   c=0;  #125;
    a=0;  b=1;   c=1;  #125;
    a=1;  b=0;   c=0;  #125;
    a=1;  b=0;   c=1;  #125;
    a=1;  b=1;   c=0;  #125;
    a=1;  b=1;   c=1;  #125;
    end
endmodule

module bit_halfadder_module_test();
    reg in1;
    reg in2;
    
    wire sum,carry;
    
    bit_halfadder_module uut(in1,in2,sum,carry);
    
    initial begin
    in1=0;  in2=0;   #250;
    in1=0;  in2=1;   #250;
    in1=1;  in2=0;   #250;
    in1=1;  in2=1;   #250;
    end
endmodule

module bit_fulladder_module_test();
    reg in1;
    reg in2;
    reg cin;
    
    wire sum,carry;
    
    bit_fulladder_module uut(in1,in2,cin,sum,carry);
    
    initial begin
    in1=0;  in2=0;   cin=0;  #125;
    in1=0;  in2=0;   cin=1;  #125;
    in1=0;  in2=1;   cin=0;  #125;
    in1=0;  in2=1;   cin=1;  #125;
    in1=1;  in2=0;   cin=0;  #125;
    in1=1;  in2=0;   cin=1;  #125;
    in1=1;  in2=1;   cin=0;  #125;
    in1=1;  in2=1;   cin=1;  #125;
    end
endmodule

module four_bitadder_module_test();
    reg [3:0] in1;
    reg [3:0] in2;
    reg cin1;
    
    wire [3:0] sum;
    wire carry;
    
    four_bitadder_module uut(in1,in2,cin1,sum,carry);
    
    initial begin
    in1=4'd 8;  in2=4'd 1;   cin1=0;  #125;   //8+1
    in1=4'd 2;  in2=4'd 7;   cin1=0;  #125;   //2+7
    in1=4'd 4;  in2=4'd 5;   cin1=0;  #125;   //4+5
    in1=4'd 11; in2=4'd 10;  cin1=0;  #125; //11+10
    in1=4'd 14; in2=4'd 5;   cin1=0;  #125;  //14+5
    in1=4'd 15; in2=4'd 9;   cin1=0;  #125;  //15+9
    in1=4'd 6;  in2=4'd 3;   cin1=0;  #125;   //6+3
    in1=4'd 8;  in2=4'd 12;  cin1=0;  #125;  //8+12
    end
endmodule

module eight_bitadder_module_test();
    reg [7:0] in1;
    reg [7:0] in2;
    reg cin1;
    
    wire [7:0] sum;
    wire carry;
    
    eight_bitadder_module uut(in1,in2,cin1,sum,carry);
    
    initial begin
    in1=8'd 29;  in2=8'd 5;   cin1=0;  #125;   //29+5
    in1=8'd 51;  in2=8'd 92;   cin1=0;  #125;   //51+92
    in1=8'd 17;  in2=8'd 28;   cin1=0;  #125;   //17+28
    in1=8'd 191; in2=8'd 2;  cin1=0;  #125; //191+2
    in1=8'd 200; in2=8'd 95;   cin1=0;  #125;  //200+95
    in1=8'd 49; in2=8'd 25;   cin1=0;  #125;  //49+25
    in1=8'd 78;  in2=8'd 255;   cin1=0;  #125;   //78+255
    in1=8'd 43;  in2=8'd 59;  cin1=0;  #125;  //43+59
    end
endmodule

module mux_8to1_module_test();
    reg in1,in2,in3,in4,in5,in6,in7,in8,s1,s2,s3;
    wire o;
    
    mux_8to1_module uut(in1,in2,in3,in4,in5,in6,in7,in8,s1,s2,s3,o);
    
    initial begin
    in1=1;  in2=1;  in3=0;  in4=1;  in5=0;  in6=1;  in7=0;  in8=1;  s1=0;  s2=0;  s3=0; #250;
    in1=1;  in2=0;  in3=0;  in4=0;  in5=1;  in6=0;  in7=0;  in8=1;  s1=1;  s2=0;  s3=0; #250;
    in1=0;  in2=1;  in3=0;  in4=1;  in5=0;  in6=1;  in7=1;  in8=1;  s1=1;  s2=0;  s3=1; #250;
    in1=0;  in2=0;  in3=0;  in4=1;  in5=1;  in6=0;  in7=1;  in8=1;  s1=1;  s2=1;  s3=1; #250;
    end
endmodule


module sixteen_bit_adder_subs_module_test();
    reg[15:0] in1;
    reg[15:0] in2;
    reg cin1;
    reg [7:0] sub;

    wire [15:0] sum;
    wire carry;

    sixteen_bit_adder_subs_module uut(in1,in2,cin1,sum,carry,sub);
    initial begin
        in1=16'd 23; in2=16'd 3;  cin1=0; sub=8'd 0; #125;
        in1=16'd 21; in2=16'd 75;  cin1=0; sub=8'd0; #125;
        in1=16'd 16800; in2=16'd 16900;  cin1=0; sub=8'd0; #125;
        in1=16'd 6983; in2=16'd 6650;  cin1=0; sub=8'd0; #125;
        in1=16'd 325; in2=16'd 97;  cin1=0; sub=8'd0; #125;
        in1=16'd 44; in2=16'd 190;  cin1=0; sub=8'd0; #125;
        in1=16'd 463; in2=16'd 241;  cin1=0; sub=8'd0; #125;
        in1=16'd 86; in2=16'd 572;  cin1=0; sub=8'd0; #125;
    end



endmodule


module part_11_test();
    reg[15:0] in1;
    reg[15:0] in2;
    reg cin1;
    reg [7:0] sub;

    wire [15:0] sum;
    wire carry;

    part_11 uut(in1,in2,cin1,sum,carry,sub);
    initial begin
        in1=16'd 32; in2=16'd 7;  cin1=0; sub=8'b11111111; #125;
        in1=16'd 21; in2=16'd 85;  cin1=0; sub=8'b11111111; #125;
        in1=16'd 16; in2=16'd 36;  cin1=0; sub=8'b11111111; #125;
        in1=16'd 256; in2=16'd 5;  cin1=0; sub=8'b11111111; #125;
        in1=16'd 200; in2=16'd 95;  cin1=0; sub=8'b11111111; #125;
        in1=16'd 45; in2=16'd 135;  cin1=0; sub=8'b11111111; #125;
        in1=16'd 36; in2=16'd 255;  cin1=0; sub=8'b11111111; #125;
        in1=16'd 25; in2=16'd 65;  cin1=0; sub=8'b11111111; #125;
    end



endmodule


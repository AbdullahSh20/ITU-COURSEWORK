`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//Abdullah Jafar Mansour Shamout 150200919
//Muhammed Yusuf Mermer 150220762
//////////////////////////////////////////////////////////////////////////////////

module and_module(in1,in2,o);
    input wire in1;
    input wire in2;
    output wire o;
    assign o = in1 & in2;
endmodule

module three_and_module(in1,in2,in3,o);
    input wire in1;
    input wire in2;
    input wire in3;
    output wire o;
    assign o = in1 & in2 & in3;
endmodule

module four_and_module(in1,in2,in3,in4,o);
    input wire in1;
    input wire in2;
    input wire in3;
    input wire in4;
    output wire o;
    assign o = in1 & in2 & in3 & in4;
endmodule

module or_module(in1,in2,o);
    input wire in1;
    input wire in2;
    output wire o;
    assign o = in1 | in2;
endmodule

module three_or_module (
    input wire in1,
    input wire in2,
    input wire in3,
    output wire o);

    assign o=in1|in2|in3;
endmodule

module eight_or_module(in1,in2,in3,in4,in5,in6,in7,in8,o);
    input wire in1,in2,in3,in4,in5,in6,in7,in8;
    output wire o;
    assign o = in1 | in2 | in3 | in4 | in5 | in6 | in7 | in8;
endmodule

module not_module(in1,o);
    input wire in1;
    output wire o;
    assign o = ~in1;
endmodule

module nand_module(in1,in2,o);
    input wire in1;
    input wire in2;
    output wire o;
    assign o = ~(in1 & in2);
endmodule

module three_nand_module (input wire in1, input wire in2,input wire in3,output wire o);
    assign o = ~(in1 & in2 & in3);
endmodule 

//(~A & B) | (A & ~B)
module xor_module(in1,in2,o);
    input wire in1;
    input wire in2;
    output wire o;
    assign o = (~in1 & in2) | (in1 & ~in2);
endmodule

module eight_bit_xor_module(in1,in2,o);
    input wire [7:0]in1;
    input wire [7:0]in2;
    output wire [7:0]o;
    assign o = (~in1 & in2) | (in1 & ~in2);
endmodule

module mux_8to1_module(in1,in2,in3,in4,in5,in6,in7,in8,s1,s2,s3,o);
    input wire in1,in2,in3,in4,in5,in6,in7,in8;
    input wire s1,s2,s3;
    output wire o;
    
    wire a1,a2,a3,a4,a5,a6,a7,a8;
    wire nots1,nots2,nots3;
    
    not_module not1(s1,nots1);
    not_module not2(s2,nots2);
    not_module not3(s3,nots3);
    
    four_and_module and1(in1,nots1,nots2,nots3,a1);
    four_and_module and2(in2,nots1,nots2,s3,a2);
    four_and_module and3(in3,nots1,s2,nots3,a3);
    four_and_module and4(in4,nots1,s2,s3,a4);
    four_and_module and5(in5,s1,nots2,nots3,a5);
    four_and_module and6(in6,s1,nots2,s3,a6);
    four_and_module and7(in7,s1,s2,nots3,a7);
    four_and_module and8(in8,s1,s2,s3,a8);
    
    eight_or_module or1(a1,a2,a3,a4,a5,a6,a7,a8,o);
endmodule

module decoder_3to8_module(in1,in2,in3,o1,o2,o3,o4,o5,o6,o7,o8);
    input wire in1,in2,in3;
    output wire o1,o2,o3,o4,o5,o6,o7,o8;
    
    wire notin1,notin2,notin3;
    
    not_module not1(in1, notin1);
    not_module not2(in2, notin2);
    not_module not3(in3, notin3);
    
    three_and_module and1(notin1,notin2,notin3,o1);
    three_and_module and2(notin1,notin2,in3,o2);
    three_and_module and3(notin1,in2,notin3,o3);
    three_and_module and4(notin1,in2,in3,o4);
    three_and_module and5(in1,notin2,notin3,o5);
    three_and_module and6(in1,notin2,in3,o6);
    three_and_module and7(in1,in2,notin3,o7);
    three_and_module and8(in1,in2,in3,o8);
    
endmodule

module prelim_1_d (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire o);


    wire anot, bnot, dnot;
    wire anotb, anotbc;

    not_module not1(a,anot);
    and_module and1(anot,b,anotb);
    and_module and2(anotb,c,anotbc);



    wire ac, acd;

    and_module and3(a,c,ac);
    and_module and4(ac,d,acd);

    wire bnotdnot;
    not_module not2(b,bnot);
    not_module not3(d,dnot);
    and_module and5(bnot,dnot,bnotdnot);

    three_or_module tor(anotbc,acd,bnotdnot,o);


endmodule

module prelim_1_e(
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire o);
    wire anot,bnot,dnot;
    wire notOfanotbc, notOfacd, notOfbnotdnot;
    

    nand_module nand1(a,a,anot);
    three_nand_module nand2(anot,b,c,notOfanotbc);
    
    three_nand_module nand3(a,c,d,notOfacd);
    
    nand_module nand4(b,b,bnot);
    nand_module nand5(d,d,dnot);
    nand_module nand6(bnot,dnot,notOfbnotdnot);

    three_nand_module nand7(notOfacd,notOfanotbc,notOfbnotdnot,o);

endmodule

module prelim_1_f( input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire o);
    wire dnot;
    wire one, zero;

    not_module not1(d,dnot);
    and_module and1(d,dnot,zero);
    or_module or1(d,dnot,one);




    mux_8to1_module mux1(dnot,dnot,zero,one,dnot,one,zero,d,a,b,c,o);



endmodule


module F2(a,b,c,o);
    input wire a,b,c;
    wire o1,o2,o3,o4,o5,o6,o7,o8;
    output wire o;
    
    decoder_3to8_module decoder(a,b,c,o1,o2,o3,o4,o5,o6,o7,o8);
    
    or_module orA(o4,o6,o);
endmodule

module F3(a,b,c,o);
    input wire a,b,c;
    wire o1,o2,o3,o4,o5,o6,o7,o8;
    wire extra;
    output wire o;
    
    decoder_3to8_module decoder(a,b,c,o1,o2,o3,o4,o5,o6,o7,o8);
    
    or_module orA(o8,o7,extra);
    or_module orB(extra,o7,o);
endmodule

module bit_halfadder_module(a,b,sum,carry);
    input wire a,b;
    output wire sum,carry;
    xor_module xorA(a,b,sum);
    and_module andA(a,b,carry);
endmodule

module bit_fulladder_module(a,b,cin,sum,carry);
    input wire a,b,cin;
    wire carry1,carry2;
    output wire sum,carry;
    bit_halfadder_module half_adder1(a,b,sum1,carry1);
    bit_halfadder_module half_adder2(sum1,cin,sum,carry2);
    or_module or1(carry1,carry2,carry);
endmodule

module four_bitadder_module(a,b,cin1,sum, carry);
    input wire [3:0] a;
    input wire [3:0] b;
    input wire cin1;
    wire cin2,cin3,cin4;
    output wire [3:0] sum;
    output wire carry;
    
    bit_fulladder_module adder1(a[0],b[0],cin1,sum[0],cin2);
    bit_fulladder_module adder2(a[1],b[1],cin2,sum[1],cin3);
    bit_fulladder_module adder3(a[2],b[2],cin3,sum[2],cin4);
    bit_fulladder_module adder4(a[3],b[3],cin4,sum[3],carry);
   
endmodule

module eight_bitadder_module(a,b,cin1,sum, carry);
    input wire [7:0] a;
    input wire [7:0] b;
    input wire cin1;
    wire cin2,cin3,cin4,cin5,cin6,cin7,cin8;
    output wire [7:0] sum;
    output wire carry;
    
    bit_fulladder_module adder1(a[0],b[0],cin1,sum[0],cin2);
    bit_fulladder_module adder2(a[1],b[1],cin2,sum[1],cin3);
    bit_fulladder_module adder3(a[2],b[2],cin3,sum[2],cin4);
    bit_fulladder_module adder4(a[3],b[3],cin4,sum[3],cin5);
    bit_fulladder_module adder5(a[4],b[4],cin5,sum[4],cin6);
    bit_fulladder_module adder6(a[5],b[5],cin6,sum[5],cin7);
    bit_fulladder_module adder7(a[6],b[6],cin7,sum[6],cin8);
    bit_fulladder_module adder8(a[7],b[7],cin8,sum[7],carry);
   
endmodule


module sixteen_bit_adder_subs_module(a,b,cin1,sum, carry, sub);
    input wire [15:0] a;
    input wire [15:0] b;
    input wire cin1;
    input wire [7:0] sub;
    output wire [15:0] sum;
    output wire carry;

    wire cin2,cin3,cin4;

    //may change sub
    wire [7:0] bsubFirst;
    wire [7:0] bsubSecond;
    eight_bit_xor_module xor1(b[7:0],sub,bsubFirst) ;
    eight_bit_xor_module xor2(b[15:8],sub,bsubSecond);

    wire [7:0] sumfirst;
    wire [7:0] sumsecond;
    wire onebit_sub;
    assign onebit_sub =sub[0];
    xor_module xor3(onebit_sub, cin1,cin2);    


    eight_bitadder_module adder1(a[7:0],bsubFirst,cin2,sumfirst,cin3);
    eight_bitadder_module adder2(a[15:8],bsubSecond,cin3,sumsecond,cin4);
    assign sum= {sumsecond,sumfirst};
    xor_module xor4(onebit_sub,cin4,carry);

endmodule


module part_11(a,b,cin1,sum, carry, sub);
    input wire [15:0] a;
    input wire [15:0] b;
    input wire cin1;
    input wire [7:0] sub;
    output wire [15:0] sum;
    output wire carry;


    wire cin2,cin3,cin4,cin5,cin6,cin7,cin8,cin9,cin10,cin11,cin12,cin13,cin14,cin15,cin16,cin17;
    wire [15:0] twoA;

    bit_fulladder_module adder1(a[0],a[0],cin1,twoA[0],cin2);
    bit_fulladder_module adder2(a[1],a[1],cin2,twoA[1],cin3);
    bit_fulladder_module adder3(a[2],a[2],cin3,twoA[2],cin4);
    bit_fulladder_module adder4(a[3],a[3],cin4,twoA[3],cin5);
    bit_fulladder_module adder5(a[4],a[4],cin5,twoA[4],cin6);
    bit_fulladder_module adder6(a[5],a[5],cin6,twoA[5],cin7);
    bit_fulladder_module adder7(a[6],a[6],cin7,twoA[6],cin8);
    bit_fulladder_module adder8(a[7],a[7],cin8,twoA[7],cin9);

    bit_fulladder_module adder9(a[8],a[8],cin9,twoA[8],cin10);
    bit_fulladder_module adder10(a[9],a[9],cin10,twoA[9],cin11);
    bit_fulladder_module adder11(a[10],a[10],cin11,twoA[10],cin12);
    bit_fulladder_module adder12(a[11],a[11],cin12,twoA[11],cin13);
    bit_fulladder_module adder13(a[12],a[12],cin13,twoA[12],cin14);
    bit_fulladder_module adder14(a[13],a[13],cin14,twoA[13],cin15);
    bit_fulladder_module adder15(a[14],a[14],cin15,twoA[14],cin16);
    bit_fulladder_module adder16(a[15],a[15],cin16,twoA[15],cin17);



    sixteen_bit_adder_subs_module addsub1(b, twoA, cin17,sum, carry, sub);
    



endmodule
`timescale 1ns / 1ps
///////////////////////////////////////////////////////////
// Onur Yavri - 150220760                                //
// Erblina Nivokazi - 150200917                          //
// Abdullah Jafar Mansour Shamout - 150200919            //
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
//                        Part 1                         //
///////////////////////////////////////////////////////////

module n_bit_register_test();
    parameter n = 8;
    
    reg [n-1:0] I;
    reg [1:0] FunSel;
    reg clk,E;
    wire [n-1:0] Q;

    n_bit_register #(n) uut (clk,I,FunSel,E,Q);

    initial begin
        clk=0; 
        forever #20 clk = ~clk;    
    end
    
    initial begin
        I = 8'b00001000; FunSel = 2'b00; E = 1'b0;  #100;
        I = 8'b00001000; FunSel = 2'b01; E = 1'b0;  #100;
        I = 8'b00001000; FunSel = 2'b00; E = 1'b1;  #100;
        I = 8'b00001000; FunSel = 2'b01; E = 1'b1;  #100;
        I = 8'b00011110; FunSel = 2'b11; E = 1'b1;  #100;
        I = 8'b11111110; FunSel = 2'b11; E = 1'b1;  #100;
        I = 8'b00001000; FunSel = 2'b00; E = 1'b1;  #100;
        I = 8'b01010011; FunSel = 2'b01; E = 1'b1;  #100;
        I = 8'b01010011; FunSel = 2'b11; E = 1'b1;  #100;
        I = 8'b01010011; FunSel = 2'b10; E = 1'b1;  #100;
    end
    
endmodule

///////////////////////////////////////////////////////////
//                        Part 2                         //
///////////////////////////////////////////////////////////

// Part 2a
module IR_register_test();
    
    reg [7:0] I;
    reg [1:0] FunSel;
    reg clk,E,L_H;
    wire [15:0] IROut;

    IR_register uut (clk,I,FunSel,E,L_H,IROut);

    initial begin
        clk=0; 
        forever #20 clk = ~clk;    
    end
    
    initial begin
        I = 8'b00001000; FunSel = 2'b00; E = 1'b0; L_H = 1'b0;  #100;
        I = 8'b00001000; FunSel = 2'b01; E = 1'b0; L_H = 1'b1;  #100;
        I = 8'b00001000; FunSel = 2'b00; E = 1'b1; L_H = 1'b1;  #100;
        I = 8'b10001010; FunSel = 2'b01; E = 1'b1; L_H = 1'b0;  #100;
        I = 8'b00000101; FunSel = 2'b01; E = 1'b1; L_H = 1'b1;  #100;
        I = 8'b00111011; FunSel = 2'b11; E = 1'b1; L_H = 1'b0;  #100;
        I = 8'b00001000; FunSel = 2'b10; E = 1'b1; L_H = 1'b1;  #100;
        I = 8'b01010011; FunSel = 2'b01; E = 1'b1; L_H = 1'b1;  #100;
        I = 8'b01010011; FunSel = 2'b00; E = 1'b1; L_H = 1'b0;  #100;
        I = 8'b01010011; FunSel = 2'b11; E = 1'b1; L_H = 1'b1;  #100;
    end
endmodule

// Part 2b
module register_file_test();
    parameter n = 8;
    reg [n-1:0] I;
    reg [2:0] O1Sel;
    reg [2:0] O2Sel;
    reg [1:0] FunSel;
    reg [3:0] RSel;
    reg [3:0] TSel;
    reg clock;
    wire [n-1:0] O1;
    wire [n-1:0] O2;
    
    register_file #(.n(n)) uut(I, O1Sel, O2Sel, FunSel, RSel, TSel, O1, O2, clock);
                                  
    initial begin
        
        I = 8'b0000_0110; // input/load
        clock = 1;
        RSel = 4'b1111; TSel = 4'b1111; FunSel = 2'b00; O1Sel = 3'b011; O2Sel = 3'b111; #125; //Sets all the registers to zero
        RSel = 4'b0011; TSel = 4'b0011; FunSel = 2'b11; O1Sel = 3'b011; O2Sel = 3'b000; #125; //Increments R3,R4,T3,T4 and displays O1=T4(incrementing) and O2=T1=0
        RSel = 4'b0110; TSel = 4'b0001; FunSel = 2'b00; O1Sel = 3'b100; O2Sel = 3'b001; #125; //Sets to zero R2,R3,T4 and display O1=R1=0 and O2=0
        RSel = 4'b0011; TSel = 4'b1100; FunSel = 2'b11; O1Sel = 3'b011; O2Sel = 3'b110; #125; //Increments R3,R4,T1,T2 and displays O1=T4 and O2=R3(incrementing)
        RSel = 4'b0000; TSel = 4'b0110; FunSel = 2'b00; O1Sel = 3'b100; O2Sel = 3'b011; #125; //Sets to zero T2,T3 and displays O1=R1=0 and O2=T3(incremented)
        RSel = 4'b0110; TSel = 4'b1001; FunSel = 2'b10; O1Sel = 3'b110; O2Sel = 3'b111; #125; //Decrementing R2,R3,T1,T4 and displays O1=R3(decrementing) and O2=R4(incremented)
        RSel = 4'b1001; TSel = 4'b0101; FunSel = 2'b01; O1Sel = 3'b110; O2Sel = 3'b000; #125; //Loads R1,R4,T2,T4 and displays O1=R3 and O2=T3
        RSel = 4'b0000; TSel = 4'b0000; FunSel = 2'b01; O1Sel = 3'b000; O2Sel = 3'b001; #125; //The registers are not enabled, displays O1=T1 and O2=T2
    end
    
    always begin
        clock = ~clock; #15;
    end
                                                             
endmodule

// Part 2c
module address_register_file_test();
    parameter n = 8;
    reg [n-1:0] I;
    reg [1:0] OutASel;
    reg [1:0] OutBSel;
    reg [1:0] FunSel;
    reg [3:0] RSel;
    reg clock;
    wire [n-1:0] OutA;
    wire [n-1:0] OutB;
    
    address_register_file #(.n(n)) uut(I, OutASel, OutBSel, FunSel, RSel, OutA, OutB,clock);
                                  
    initial begin
        I = 8'b0000_0101; //input/load
        clock = 1; 
        RSel = 4'b1111; FunSel = 2'b01; OutASel = 2'b11; OutBSel = 2'b00; #250; //Loads all registers and display OutA=PC and OutB=AR
        RSel = 4'b1100; FunSel = 2'b11; OutASel = 2'b10; OutBSel = 2'b11; #250; //Increments PC and AR and displays OutA=PCPast and OutB=PC
        RSel = 4'b0011; FunSel = 2'b00; OutASel = 2'b01; OutBSel = 2'b00; #250; //Resets SP and PCPast and displays OutA=SP and OutB =AR
        RSel = 4'b0000; FunSel = 2'b10; OutASel = 2'b00; OutBSel = 2'b01; #250; //Registers are not enabled, displays OutA=AR and OutB=SP
    end
    
    always begin
        clock = ~clock; #25;
    end
                                                             
endmodule


///////////////////////////////////////////////////////////
//                        Part 3                         //
///////////////////////////////////////////////////////////

module alu_test();
    reg [7:0] A = 8'd0;
    reg [7:0] B = 8'd0;
    reg [3:0] FunSel = 4'd0;
    wire [3:0] FlagOut;
    wire [7:0] OutALU;
    ALU uut(.A(A), .B(B), .FunSel(FunSel), .OutALU(OutALU), .FlagOut(FlagOut));

    initial begin
        A = 8'b1111_0000;
        B = 8'b1010_1010; //                                           BINARY     Z|C|N|O
        FunSel = 4'b0000; #30; // A                                   11110000 -> 0|0|1|0
        FunSel = 4'b0001; #30; // B                                   10101010 -> 0|0|1|0
        FunSel = 4'b0010; #30; // ~A                                  00001111 -> 0|0|0|0
        FunSel = 4'b0011; #30; // ~B                                  01010101 -> 0|0|0|0
        B = 8'b1111_1111; #30; // ~B                                  00000000 -> 1|0|0|0

        FunSel = 4'b0100; // A + B     
        //                                                             BINARY     Z|C|N|O
        A = 8'b0000_1111; B = 8'b0001_1000; #30; // Normal            00100111 -> 0|0|0|0
        A = 8'b0011_0000; B = 8'b0001_1111; #30; // Normal            01001111 -> 0|0|0|0
        A = 8'b1111_1111; B = 8'b0000_0001; #30; // Zero              00000000 -> 1|1|0|0
        A = 8'b1111_1111; B = 8'b0000_0111; #30; // Carry (Cin: 1)    00000111 -> 0|1|0|0
        A = 8'b1111_1111; B = 8'b1111_1111; #30; // Negative (Cin: 1) 11111111 -> 0|1|1|0
        A = 8'b0111_1111; B = 8'b0000_0001; #30; // Overflow          10000001 -> 0|0|1|1
 
        FunSel = 4'b0101; // A - B
        //                                                             BINARY     Z|C|N|O
        A = 8'b1111_1111; B = 8'b1111_1111; #30; // Normal            00000000 -> 1|1|0|0
        A = 8'b0000_1111; B = 8'b0000_1100; #30; // Normal            00000011 -> 0|1|0|0
        A = 8'b0000_0001; B = 8'b0000_0001; #30; // Zero              00000000 -> 1|1|0|0
        A = 8'b0000_0111; B = 8'b0000_1111; #30; // Negative          11111000 -> 0|0|1|0
        A = 8'b0111_1111; B = 8'b1111_1111; #30; // Overflow P-N=N    10000000 -> 0|0|1|1
        A = 8'b1000_1111; B = 8'b0111_1111; #30; // Overflow N-P=P    00010000 -> 0|1|0|1

        A = 8'b1111_1111; B = 8'b1111_1110; #30;


        FunSel = 4'b0110; // A > B => A, A <= B => 0
        //                                                             BINARY     Z|C|N|O
        A = 8'b1111_1111; B = 8'b1111_1110; #30; // A > B             11111111 -> 0|1|1|0
        A = 8'b0111_1111; B = 8'b0000_1111; #30; // A > B             01111111 -> 0|1|0|0
        A = 8'b0001_1000; B = 8'b0001_1000; #30; // A = B             00000000 -> 1|1|0|0
        A = 8'b1111_1111; B = 8'b0111_1111; #30; // A < B             00000000 -> 1|1|0|0
        A = 8'b0111_1111; B = 8'b1111_1111; #30; // Overflow P-N=N    00000000 -> 1|1|0|1
        A = 8'b1000_1111; B = 8'b0111_1111; #30; // Overflow N-P=P    00000000 -> 1|1|0|1
        
        FunSel = 4'b0111; // A AND B
        //                                                             BINARY     Z|C|N|O
        A = 8'b1111_0000; B = 8'b0011_1010; #30; // Normal            00110000 -> 0|1|0|0
        A = 8'b1111_0000; B = 8'b0000_0000; #30; // Zero              00000000 -> 1|1|0|0
        A = 8'b1111_0000; B = 8'b1010_1010; #30; // Negative          10100000 -> 0|1|1|0

        FunSel = 4'b1000; // A OR B        
        //                                                             BINARY     Z|C|N|O
        A = 8'b0110_0011; B = 8'b0011_0011; #30; // Normal            01110011 -> 0|1|0|0
        A = 8'b0000_0000; B = 8'b0000_0000; #30; // Zero              00000000 -> 1|1|0|0
        A = 8'b1110_0011; B = 8'b0001_0011; #30; // Negative          11110011 -> 0|1|1|0

        FunSel = 4'b1001; // A NAND B      
        //                                                             BINARY     Z|C|N|O
        A = 8'b1110_0101; B = 8'b1110_1011; #30; // Normal            00011110 -> 0|1|0|0
        A = 8'b1111_1111; B = 8'b1111_1111; #30; // Zero              00000000 -> 1|1|0|0
        A = 8'b1110_0101; B = 8'b0110_1011; #30; // Negative          10011110 -> 0|1|1|0

        FunSel = 4'b1010; // A XOR B       
        //                                                             BINARY     Z|C|N|O
        A = 8'b0110_0111; B = 8'b0101_1111; #30; // Normal            00111000 -> 0|1|0|0
        A = 8'b1111_0000; B = 8'b1111_0000; #30; // Zero              00000000 -> 1|1|0|0
        A = 8'b0110_0111; B = 8'b1101_1111; #30; // Negative          10111000 -> 0|1|1|0

        FunSel = 4'b1011; // LSL A
        //                                                             BINARY     Z|C|N|O
        A = 8'b0011_1101; #30; // Normal                              01111010 -> 0|0|0|0
        A = 8'b0000_0000; #30; // Zero                                00000000 -> 1|0|0|0
        A = 8'b1001_0000; #30; // Carry                               00100000 -> 0|1|0|0
        A = 8'b0111_1001; #30; // Negative                            11110010 -> 0|0|1|0

        FunSel = 4'b1100; // LSR A
        //                                                             BINARY     Z|C|N|O
        A = 8'b0111_0011; #30; // Normal                              00111001 -> 0|1|0|0
        A = 8'b0000_0000; #30; // Zero                                00000000 -> 1|0|0|0
        A = 8'b1110_1101; #30; // Carry                               01110110 -> 0|1|0|0
        A = 8'b0110_0110; #30; // Negative                            00110011 -> 0|0|1|0
        
        FunSel = 4'b1101; // ASL A
        //                                                             BINARY     Z|C|N|O
        A = 8'b0001_1010; #30; // Normal                              00110100 -> 0|0|0|0
        A = 8'b0000_0000; #30; // Zero                                00000000 -> 1|0|0|0
        A = 8'b1100_1010; #30; // Negative                            10010100 -> 0|0|1|0
        A = 8'b1010_0001; #30; // Overflow                            01000010 -> 0|0|0|1
        
        FunSel = 4'b1110; // ASR A
        //                                                             BINARY     Z|C|N|O
        A = 8'b0011_1101; #30; // Normal                              00011110 -> 0|0|0|0
        A = 8'b0000_0000; #30; // Zero                                00000000 -> 1|0|0|0
        A = 8'b1000_1100; #30; // Negative                            11000110 -> 0|0|1|0
        
        FunSel = 4'b1111; // CSR A
        //                                                             BINARY     Z|C|N|O
        A = 8'b1100_1001; #30; // Normal (C: 0)                       01100100 -> 0|1|1|0
        A = 8'b0000_0000; #30; // Zero (C: 1)                         10000000 -> 0|0|1|0
        A = 8'b0000_0001; #30; // Zero (C: 0)                         00000000 -> 1|0|0|0
        A = 8'b1001_1111; #30; // Carry (C: 0)                        01001111 -> 0|1|0|0
        A = 8'b0001_1111; #30; // Negative (C: 1)                     10001111 -> 0|1|1|0
    end
endmodule


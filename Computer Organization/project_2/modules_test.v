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


/////////////////////////////////////////Project 2 stuff starts from here/////////////////////////////////////////////////
module counter_test();
    reg clk;
    reg reset;
    reg count;
    wire [3:0] O;
    counter uut (clk,reset,count,O);
    
    initial begin
        clk=0; 
        forever #20 clk = ~clk;    
    end
    
    initial begin
        reset = 0; count = 0; #100;
        reset = 0; count = 1; #100;
        reset = 1; count = 1; #100;
        reset = 0; count = 1; #100;
        reset = 0; count = 1; #100;
        reset = 0; count = 1; #100;
        reset = 0; count = 0; #100;
        reset = 1; count = 0; #100;
        reset = 0; count = 1; #100;
        reset = 0; count = 1; #100;
    end
    
endmodule

module decoder_4to16_test();
    reg enable;
    reg [3:0] I;
    wire [15:0] O;
    
    decoder_4to16 uut (enable,I,O);

    initial begin
        enable = 0; I = 4'd0; #50;
        enable = 0; I = 4'd1; #50;
        enable = 1; I = 4'd0; #50;
        enable = 1; I = 4'd1; #50;
        enable = 1; I = 4'd2; #50;
        enable = 1; I = 4'd3; #50;
        enable = 1; I = 4'd4; #50;
        enable = 1; I = 4'd5; #50;
        enable = 1; I = 4'd6; #50;
        enable = 1; I = 4'd7; #50;
        enable = 1; I = 4'd8; #50;
        enable = 1; I = 4'd9; #50;
        enable = 1; I = 4'd10; #50;
        enable = 1; I = 4'd11; #50;
        enable = 1; I = 4'd12; #50;
        enable = 1; I = 4'd13; #50;
        enable = 0; I = 4'd14; #50;
        enable = 1; I = 4'd14; #50;
        enable = 1; I = 4'd15; #50;
    end
endmodule

module instruction_decoder_test();
    reg T2;
    reg [7:0] IR_H;
    wire [15:0] D;
    wire A;
    wire [1:0] SEL;
    
    instruction_decoder uut(T2,IR_H, D, A, SEL);
    initial begin
        T2 = 0; IR_H = 8'h00;   #125;   //first 4 bits are for operation AND which is 0 in hex, next 4 bits define DSTREG first bit is ignored, second one decides its from register file thus 0, last two pick R1 thus 00 so 0000 is 0 in hex
        T2 = 1; IR_H = 8'h00;   #125;
        T2 = 0; IR_H = 8'h91;   #125;   //BRA 0x09, skip 0, IM 0, RSEL is fixed on PC so for that case RSEL doesnt matter i guess, so the next hex digit will look like this in binary 00XX
        T2 = 1; IR_H = 8'h91;   #125;
        T2 = 0; IR_H = 8'hC7;   #125;   //LD  0x0C,skip 0, D 1, R4 is 11 so 0111 is 7
        T2 = 1; IR_H = 8'hC7;   #125;
    end
endmodule

module fetch_L_test();
    reg T0;
    wire [1:0] ARF_FunSel;
    wire [3:0] ARF_RegSel;
    wire [1:0] OutBSel;
    wire [1:0] OutASel;
    wire cs;
    wire wr;
    wire [1:0] IR_FunSel;
    wire E;
    wire L_H;
    fetch_L uut (T0,ARF_FunSel,ARF_RegSel,OutBSel,OutASel,cs,wr,E,L_H,IR_FunSel);

    initial begin
        T0=0; 
        forever #250 T0 = ~T0;    
    end
endmodule

module fetch_H_test();
    reg T1;
    wire [1:0] ARF_FunSel;
    wire [3:0] ARF_RegSel;
    wire [1:0] OutBSel;
    wire [1:0] OutASel;
    wire cs;
    wire wr;
    wire [1:0] IR_FunSel;
    wire E;
    wire L_H;
    fetch_H uut (T1,ARF_FunSel,ARF_RegSel,OutBSel,OutASel,cs,wr,E,L_H,IR_FunSel);

    initial begin
        T1=0; 
        forever #250 T1 = ~T1;    
    end
endmodule

module control_unit_test();     //this is the test file so far, I added my stuff to check them, you can edit on the module to add to your stuff too
    reg clk;
    reg [7:0] IR_H;      //the high part of the IR used in the decoding process
    wire SC_reset;
    wire [1:0] ARF_FunSel;
    wire [3:0] ARF_RegSel;
    wire [1:0] OutBSel;
    wire [1:0] OutASel;
    wire [1:0] ARF_FunSel; 
    wire [3:0] ARF_RegSel; 
    wire [1:0] ARF_OutBSel;
    wire [1:0] ARF_OutASel;
    wire [3:0] ALU_FunSel; 
    wire [2:0] RF_O1Sel;   
    wire [2:0] RF_O2Sel;   
    wire [1:0] RF_FunSel;  
    wire [3:0] RF_RegSel;  
    wire [3:0] RF_TSel;    
    wire [1:0] MuxASel;    
    wire [1:0] MuxBSel;    
    wire MuxCSel;          
    wire Mem_CS;           
    wire Mem_WR;           
    wire IR_LH;            
    wire IR_Enable;        
    wire [1:0] IR_FunSel;
    control_unit uut(
        .clk(Clock),
        .IROut(IROut),
        .ARF_FunSel(ARF_FunSel), 
        .ARF_RegSel(ARF_RSel),
        .ARF_OutBSel(ARF_OutBSel), 
        .ARF_OutASel(ARF_OutASel),
        .ALU_FlagReg(ALU_FlagReg), 
        .ALU_FunSel(ALU_FunSel), 
        .RF_O1Sel(RF_O1Sel), 
        .RF_O2Sel(RF_O2Sel), 
        .RF_FunSel(RF_FunSel), 
        .RF_RegSel(RF_RSel), 
        .RF_TSel(RF_TSel),
        .MuxASel(MuxASel), 
        .MuxBSel(MuxBSel), 
        .MuxCSel(MuxCSel), 
        .Mem_CS(Mem_CS), 
        .Mem_WR(Mem_WR), 
        .IR_LH(IR_LH), 
        .IR_Enable(IR_Enable), 
        .IR_FunSel(IR_FunSel),
        .SC_Reset(SC_reset));
    wire [15:0] T;  
    assign T = uut.T;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        IR_H = 8'h00;   #125;  
        IR_H = 8'h00;   #125;
        IR_H = 8'h00;   #250;
        IR_H = 8'hC7;   #250;
        IR_H = 8'hC7;   #250;
    end
endmodule

module execute_operation_test();
    wire [3:0] Timer; // Timer
    wire [15:0] T;
    reg [15:0] D = 16'b0; // Operation
    reg clk = 0;
    reg [3:0] ALU_FlagReg = 4'bZ; // ALU Flags [ Z | C | N | O ]
    reg addressing_mode;
    reg [1:0] RSEL;
    reg [7:0] address;

    wire SC_Reset;

    wire [2:0] RFO1Sel; 
    wire [2:0] RFO2Sel; 
    wire [1:0] RFFunSel; 
    wire [3:0] RFRegSel; 
    wire [3:0] RFTSel;

    wire [1:0] MuxASel; 
    wire [1:0] MuxBSel; 
    wire MuxCSel; 

    wire [1:0] ARFFunSel;
    wire [3:0] ARFRegSel;
    wire [1:0] ARFOutASel;
    wire [1:0] ARFOutBSel;

    wire [3:0] ALUFunSel;

    wire Mem_WR;
    wire Mem_CS;
    reg reset = 1'b1;

    counter timer(.clk(clk), .reset(SC_Reset | reset), .count(1'b1), .O(Timer));

    decoder_4to16 decoder(.enable(1'b1), .I(Timer), .O(T));

    execute_operation uut(.T(T), .D(D), .ALU_FlagReg(ALU_FlagReg), .address(address), .RSEL(RSEL), .addressing_mode(addressing_mode),
        .SC_Reset(SC_Reset), .RF_O1Sel(RFO1Sel), .RF_O2Sel(RFO2Sel), .RF_FunSel(RFFunSel), .RF_RegSel(RFRegSel), .RF_TSel(RFTSel),
        .MuxASel(MuxASel), .MuxBSel(MuxBSel), .MuxCSel(MuxCSel),
        .ARF_FunSel(ARFFunSel), .ARF_RegSel(ARFRegSel), .ARF_OutASel(ARFOutASel), .ARF_OutBSel(ARFOutBSel),
        .ALU_FunSel(ALUFunSel), .Mem_WR(Mem_WR), .Mem_CS(Mem_CS)
    );

    initial begin
        forever #5 clk = ~clk;
    end

    initial begin
        // Reset the timer (Sequence counter simulator)
        #10;
        reset = 0;
        #5;
        // For 2 operand operations
        // D = 0x00
        D = 16'b0000_0000_0000_0001;
        // DSTREG <- SREG1 AND SREG2
        // DSTREG FROM RF, SREG1 FROM RF, SREG2 FROM RF
        addressing_mode = 0; RSEL = 2'b00; address[7:4] = 4'b0001; address[3:0] = 4'b0010;
        #25; // Wait for 3 clock cycle, fetch and decode
        #15; // Wait for the operation

        // DSTREG FROM RF, SREG1 FROM RF, SREG2 FROM ARF
        addressing_mode = 0; RSEL = 2'b00; address[7:4] = 4'b0001; address[3:0] = 4'b0110;
        #35; // Wait for 3 clock cycle, fetch and decode
        #15; // Wait for the operation
        
        // DSTREG FROM RF, SREG1 FROM ARF, SREG2 FROM RF
        addressing_mode = 0; RSEL = 2'b00; address[7:4] = 4'b0101; address[3:0] = 4'b0010;
        #35; // Wait for 3 clock cycle, fetch and decode
        #15; // Wait for the operation
        
        // DSTREG FROM ARF, SREG1 FROM RF, SREG2 FROM RF
        addressing_mode = 1; RSEL = 2'b00; address[7:4] = 4'b0001; address[3:0] = 4'b0010;
        #35; // Wait for 3 clock cycle, fetch and decode
        #15; // Wait for the operation
        
        // DSTREG FROM ARF, SREG1 FROM RF, SREG2 FROM ARF
        addressing_mode = 1; RSEL = 2'b00; address[7:4] = 4'b0001; address[3:0] = 4'b0110;
        #35; // Wait for 3 clock cycle, fetch and decode
        #15; // Wait for the operation
        
        
        // DSTREG FROM ARF, SREG1 FROM ARF, SREG2 FROM RF
        addressing_mode = 1; RSEL = 2'b00; address[7:4] = 4'b0101; address[3:0] = 4'b0010;
        #35; // Wait for 3 clock cycle, fetch and decode
        #15; // Wait for the operation
        
        
        // For 1 operand operations
        // D = 0x02
        D = 16'b0000_0000_0000_0100;
        // DSTREG <- NOT SREG1
        // DSTREG FROM RF, SREG1 FROM RF
        addressing_mode = 1'b0; RSEL = 2'b00; address[7:4] = 4'b0001; address[3:0] = 4'bZ;
        #35; // Wait for 3 clock cycle, fetch and decode
        #15; // Wait for the outputs

        // DSTREG FROM RF, SREG1 FROM ARF
        addressing_mode = 1'b0; RSEL = 2'b00; address[7:4] = 4'b0101; address[3:0] = 4'bZ;
        #35; // Wait for 3 clock cycle, fetch and decode
        #15; // Wait for the outputs        

        // DSTREG FROM ARF, SREG1 FROM RF
        addressing_mode = 1'b1; RSEL = 2'b00; address[7:4] = 4'b0001; address[3:0] = 4'bZ;
        #35; // Wait for 3 clock cycle, fetch and decode
        #15; // Wait for the outputs

        // DSTREG FROM ARF, SREG1 FROM ARF
        addressing_mode = 1'b1; RSEL = 2'b00; address[7:4] = 4'b0101; address[3:0] = 4'bZ;
        #35; // Wait for 3 clock cycle, fetch and decode
        #15; // Wait for the outputs

        // For INC/DEC operations
        // D = 0x07
        D = 16'b0000_0000_1000_0000;
        // DSTREG FROM RF, SREG1 FROM RF
        addressing_mode = 1'b0; RSEL = 2'b00; address[7:4] = 4'b0001; address[3:0] = 4'bZ;
        #35; // Wait for 3 clock cycle, fetch and decode
        #25; // Wait for the outputs

        // DSTREG FROM RF, SREG1 FROM ARF
        addressing_mode = 1'b0; RSEL = 2'b00; address[7:4] = 4'b0101; address[3:0] = 4'bZ;
        #35; // Wait for 3 clock cycle, fetch and decode
        #25; // Wait for the outputs

        // DSTREG FROM ARF, SREG1 FROM RF
        addressing_mode = 1'b1; RSEL = 2'b00; address[7:4] = 4'b0001; address[3:0] = 4'bZ;
        #35; // Wait for 3 clock cycle, fetch and decode
        #25; // Wait for the outputs

        // DSTREG FROM ARF, SREG1 FROM ARF
        addressing_mode = 1'b1; RSEL = 2'b00; address[7:4] = 4'b0101; address[3:0] = 4'bZ;
        #35; // Wait for 3 clock cycle, fetch and decode
        #25; // Wait for the outputs

        // For various addresing mode operations
        // D = 0x09, addressing mode = 0 (IM)
        D = 16'b0000_0010_0000_0000; addressing_mode = 1'b0;
        // PC <- VALUE
        #35; // Wait for 3 clock cycle, fetch and decode
        #15; // Wait for the outputs
        // D = 0x0A, addressing mode = 0 (IM)
        D = 16'b0000_0100_0000_0000; addressing_mode = 1'b0;
        // IF Z = 0 THEN PC <- VALUE
        ALU_FlagReg = 4'b0ZZZ;
        #35; // Wait for 3 clock cycle, fetch and decode
        #15; // Wait for the outputs

        ALU_FlagReg = 4'b1ZZZ;
        #35; // Wait for 3 clock cycle, fetch and decode
        #15; // Wait for the outputs

        // D = 0x0C, addressing mode = 0 (IM)
        D = 16'b0001_0000_0000_0000; addressing_mode = 1'b0;
        // Rx <- VALUE
        #35; // Wait for 3 clock cycle, fetch and decode
        #15; // Wait for the outputs

        // D = 0x0C, addressing mode = 1 (D)
        D = 16'b0001_0000_0000_0000; addressing_mode = 1'b1;
        // Rx <- VALUE
        #35; // Wait for 3 clock cycle, fetch and decode
        #15; // Wait for the outputs

        // D = 0x0D, addressing mode = 1 (D)
        D = 16'b0010_0000_0000_0000; addressing_mode = 1'b1;
        // VALUE <- Rx
        #35; // Wait for 3 clock cycle, fetch and decode
        #15; // Wait for the outputs

        // For PUL and PSH
        // D = 0x0E
        D = 16'b0100_0000_0000_0000;
        #35; // Wait for 3 clock cycle, fetch and decode
        #25; // Wait for the outputs

        // D = 0x0F
        D = 16'b1000_0000_0000_0000;
        #35; // Wait for 3 clock cycle, fetch and decode
        #25; // Wait for the outputs
        $stop;
    end
endmodule


module control_unit_test_1();     //this is the test file so far, I added my stuff to check them, you can edit on the module to add to your stuff too
    reg clk;
    reg SC_reset;        //this value is going to be changed from your final execution modules, also idk whether this should be input/output it depends on the way you guys code so change it if you see it suitable
    reg [15:0] IR;
    wire [1:0] ARF_FunSel;
    wire [3:0] ARF_RegSel;
    wire [1:0] OutBSel;
    wire [1:0] OutASel;
    control_unit uut(clk,IR,SC_reset,ARF_FunSel,ARF_RegSel,OutBSel,OutASel);

    initial begin
        clk = 0;
        forever #20 clk = ~clk;
    end

    initial begin
        IR = 16'h0000; SC_reset = 1;  #125;  
        IR = 16'h0000; SC_reset = 0;  #125;
        IR = 16'h0000; SC_reset = 0;  #250;
        IR = 16'hC700; SC_reset = 1;  #250;
        IR = 16'hC700; SC_reset = 0;  #250;
    end
endmodule

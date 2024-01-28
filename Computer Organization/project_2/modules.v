`timescale 1ns / 1ps
///////////////////////////////////////////////////////////
// Onur Yavri - 150220760                                //
// Erblina Nivokazi - 150200917                          //
// Abdullah Jafar Mansour Shamout - 150200919            //
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
//                        Part 1                         //
///////////////////////////////////////////////////////////

module n_bit_register #(parameter n = 8)(clk,I,FunSel,E,Q);

    input wire [n-1:0] I;
    input wire [1:0] FunSel;
    input wire E;
    input wire clk;
    output reg [n-1:0] Q;
    always @(posedge clk)
        begin
        if(E)
        begin
            case(FunSel)
                2'b00   :   Q <= {n{1'b0}};
                2'b01   :   Q <= I[n-1:0];
                2'b10   :   Q <= Q - {{n-1{1'b0}},1'b1};
                2'b11   :   Q <= Q + {{n-1{1'b0}},1'b1};
            default     :   Q <= Q;
            endcase
        end
        else
        begin
        Q<=Q;
        end
        end
endmodule

///////////////////////////////////////////////////////////
//                        Part 2                         //
///////////////////////////////////////////////////////////

// Part 2a
module IR_register(clk,I,FunSel,E,L_H,IROut);
    input wire [7:0] I;
    input wire [1:0] FunSel;
    input wire L_H;
    input wire E;
    input wire clk;
    output reg [15:0] IROut;
    always @(posedge clk)
        begin
        if(E)
        begin
            case(FunSel)
                2'b00   :   IROut <= 16'b0000000000000000;
                2'b01   :begin   
                            if(L_H)
                            begin 
                                IROut[15:8] <= I;
                            end 
                            else 
                            begin 
                                IROut[7:0] <= I; 
                            end
                         end
                2'b10   :   IROut <= IROut - 16'b0000000000000001;
                2'b11   :   IROut <= IROut + 16'b0000000000000001;
            default     :   IROut <= IROut;
            endcase
        end
        else
        begin
            IROut <= IROut;
        end
    end
endmodule

// Part 2b
module register_file(I,O1Sel,O2Sel,FunSel,RSel,TSel,O1,O2,clk);
    input wire [7:0] I;
    input wire [2:0] O1Sel;
    input wire [2:0] O2Sel;
    input wire [1:0] FunSel;
    input wire [3:0] RSel;
    input wire [3:0] TSel;
    input wire clk;
    output reg [7:0] O1;
    output reg [7:0] O2;
    
    wire ER1,ER2,ER3,ER4,ET1,ET2,ET3,ET4;
    
    wire [7:0] Q_R1;
    wire [7:0] Q_R2;
    wire [7:0] Q_R3;
    wire [7:0] Q_R4;
    wire [7:0] Q_T1;
    wire [7:0] Q_T2;
    wire [7:0] Q_T3;
    wire [7:0] Q_T4;
        
    assign {ER1,ER2,ER3,ER4} = RSel;
    assign {ET1,ET2,ET3,ET4} = TSel;
    
    n_bit_register #(8) R1 (.clk(clk),.I(I),.FunSel(FunSel),.E(ER1),.Q(Q_R1));
    n_bit_register #(8) R2 (.clk(clk),.I(I),.FunSel(FunSel),.E(ER2),.Q(Q_R2));
    n_bit_register #(8) R3 (.clk(clk),.I(I),.FunSel(FunSel),.E(ER3),.Q(Q_R3));
    n_bit_register #(8) R4 (.clk(clk),.I(I),.FunSel(FunSel),.E(ER4),.Q(Q_R4));
    
    n_bit_register #(8) T1 (.clk(clk),.I(I),.FunSel(FunSel),.E(ET1),.Q(Q_T1));
    n_bit_register #(8) T2 (.clk(clk),.I(I),.FunSel(FunSel),.E(ET2),.Q(Q_T2));
    n_bit_register #(8) T3 (.clk(clk),.I(I),.FunSel(FunSel),.E(ET3),.Q(Q_T3));
    n_bit_register #(8) T4 (.clk(clk),.I(I),.FunSel(FunSel),.E(ET4),.Q(Q_T4));
    
    always @(*) begin
        case (O1Sel)
            3'b000: O1 <= Q_T1;
            3'b001: O1 <= Q_T2;
            3'b010: O1 <= Q_T3;
            3'b011: O1 <= Q_T4;
            3'b100: O1 <= Q_R1;
            3'b101: O1 <= Q_R2;
            3'b110: O1 <= Q_R3;
            3'b111: O1 <= Q_R4;
        endcase
        case (O2Sel)
            3'b000: O2 <= Q_T1;
            3'b001: O2 <= Q_T2;
            3'b010: O2 <= Q_T3;
            3'b011: O2 <= Q_T4;
            3'b100: O2 <= Q_R1;
            3'b101: O2 <= Q_R2;
            3'b110: O2 <= Q_R3;
            3'b111: O2 <= Q_R4;
        endcase
    end
    
endmodule

// Part 2c
module address_register_file(I,OutASel,OutBSel,FunSel,RSel,OutA,OutB,clk);
    input wire [7:0] I;
    input wire [1:0] OutASel;
    input wire [1:0] OutBSel;
    input wire [1:0] FunSel;
    input wire [3:0] RSel;
    input wire clk;
    output reg [7:0] OutA;
    output reg [7:0] OutB;
    
    wire E1,E2,E3,E4;
    
    wire [7:0] Q_PC;
    wire [7:0] Q_AR;
    wire [7:0] Q_SP;
    wire [7:0] Q_PCPast;
                
    assign {E1,E2,E3,E4} = RSel;
    
    n_bit_register #(8) PC (.clk(clk), .I(I), .FunSel(FunSel), .E(E1), .Q(Q_PC));
    n_bit_register #(8) AR (.clk(clk), .I(I), .FunSel(FunSel), .E(E2), .Q(Q_AR));
    n_bit_register #(8) SP (.clk(clk), .I(I), .FunSel(FunSel), .E(E3), .Q(Q_SP));
    n_bit_register #(8) PCPast (.clk(clk), .I(I), .FunSel(FunSel), .E(E4), .Q(Q_PCPast));
    
    always @(*) begin
        case (OutASel)
            2'b00: OutA <= Q_AR;
            2'b01: OutA <= Q_SP;
            2'b10: OutA <= Q_PCPast;
            2'b11: OutA <= Q_PC;
        endcase
        case (OutBSel)
            2'b00: OutB <= Q_AR;
            2'b01: OutB <= Q_SP;
            2'b10: OutB <= Q_PCPast;
            2'b11: OutB <= Q_PC;
        endcase
    end
    
endmodule


///////////////////////////////////////////////////////////
//                        Part 3                         //
///////////////////////////////////////////////////////////

module ALU(A, B, FunSel, OutALU, FlagOut);
    input wire [7:0] A;
    input wire [7:0] B;
    input wire [3:0] FunSel;
    output reg [7:0] OutALU;
    output reg [3:0] FlagOut;
    reg Z = 1'bX;
    reg C = 1'bX;
    reg N = 1'bX;
    reg O = 1'bX; 
    // Zero|Carry|Negative|Overflow
    
    always @(A, B, FunSel) begin
        case (FunSel)
        4'b0000: // OutALU = A
            begin
                OutALU = A;

                // FLAG UPDATE
                if (OutALU[7] == 1) begin // Negative
                    N = 1;
                end else begin
                    N = 0;
                end
            end

        4'b0001: // OutALU = B
            begin
                OutALU = B;

                // FLAG UPDATE
                if (OutALU[7] == 1) begin // Negative
                    N = 1;
                end else begin
                    N = 0;
                end
            end

        //-----------------------//

        4'b0010: // OutALU = NOT A
            begin
                OutALU = ~A;

                // FLAG UPDATE
                if (OutALU[7] == 1) begin // Negative
                    N = 1;
                end else begin
                    N = 0;
                end
            end

        4'b0011: // OutALU = NOT B
            begin
                OutALU = ~B;

                // FLAG UPDATE
                if (OutALU[7] == 1) begin // Negative
                    N = 1;
                end else begin
                    N = 0;
                end
            end

        //-----------------------//

        4'b0100: // OutALU = A + B + Carry
            begin
                O = 0;
                {C, OutALU} = {1'b0, A} + {1'b0, B} + {8'd0, C};

                // FLAG UPDATE
                if ((A[7] == B[7]) && (B[7] != OutALU[7])) begin
                    O = 1;
                end
                if (OutALU[7] == 1) begin // Negative
                    N = 1;
                end else begin
                    N = 0;
                end
            end

        4'b0101: // OutALU = A - B
            begin
                O = 0;
                {C, OutALU} = {1'b0, A} + {1'b0, (~B + 8'd1)};
                
                // FLAG UPDATE
                if ((B[7] == OutALU[7]) && (B[7] != A[7])) begin
                    O = 1;
                end
                if (OutALU[7] == 1) begin // Negative
                    N = 1;
                end else begin
                    N = 0;
                end
            end

        4'b0110: // OutALU = Compare A, B  // (A > B) ? A : 0
            begin
                O = 0;
                {C, OutALU} = {1'b0, A} + {1'b0, (~B + 8'd1)};

                // FLAG UPDATE
                if ((B[7] == OutALU[7]) && (B[7] != A[7])) begin // Overflow
                    O = 1;
                end
                //

                if (O) begin
                    if (A[7] == 1 && B[7] == 0) begin
                        OutALU = 8'd0;
                    end else begin
                        OutALU = A;
                    end
                end else begin
                    if (OutALU[7] == 1 || OutALU == 8'd0) begin
                        OutALU = 8'd0;
                    end else begin
                        OutALU = A;
                    end
                end

                // FLAG UPDATE
                if (OutALU[7] == 1) begin // Negative
                    N = 1;
                end else begin
                    N = 0;
                end
                //
            end

        //-----------------------//

        4'b0111: // OutALU = A AND B
            begin
                OutALU = A & B;

                // FLAG UPDATE
                if (OutALU[7] == 1) begin // Negative
                    N = 1;
                end else begin
                    N = 0;
                end
            end

        4'b1000: // OutALU = A OR B
            begin
                OutALU = A | B;

                // FLAG UPDATE
                if (OutALU[7] == 1) begin // Negative
                    N = 1;
                end else begin
                    N = 0;
                end
            end

        4'b1001: // OutALU = A NAND B
            begin
                OutALU = ~(A & B);

                // FLAG UPDATE
                if (OutALU[7] == 1) begin // Negative
                    N = 1;
                end else begin
                    N = 0;
                end
            end

        4'b1010: // OutALU = A XOR B
            begin
                OutALU = A ^ B;

                // FLAG UPDATE
                if (OutALU[7] == 1) begin // Negative
                    N = 1;
                end else begin
                    N = 0;
                end
            end

        //-----------------------//

        4'b1011: // OutALU = LSL A
            begin
                C = A[7];
                OutALU = A;
                OutALU = OutALU << 1;

                // FLAG UPDATE
                if (OutALU[7] == 1) begin // Negative
                    N = 1;
                end else begin
                    N = 0;
                end
            end

        4'b1100: // OutALU = LSR A
            begin
                C = A[0];
                OutALU = A;
                OutALU = OutALU >> 1;

                // FLAG UPDATE
                if (OutALU[7] == 1) begin // Negative
                    N = 1;
                end else begin
                    N = 0;
                end        
            end

        4'b1101: // OutALU = ASL A
            begin
                OutALU = A;
                OutALU = OutALU << 1;

                // FLAG UPDATE
                if (A[7] != OutALU[7]) begin // Overflow
                    O = 1;
                end else begin
                    O = 0;
                end
                if (OutALU[7] == 1) begin // Negative
                    N = 1;
                end else begin
                    N = 0;
                end
            end

        4'b1110: // OutALU = ASR A
            begin
                OutALU = A;
                OutALU = OutALU >> 1;
                OutALU[7] = OutALU[6];
                
                // FLAG UPDATE
                if (OutALU[7] == 1) begin // Negative
                    N = 1;
                end else begin
                    N = 0;
                end
            end

        4'b1111: // OutALU = CSR A
            begin
                OutALU = {C, A[7:1]};
                C = A[0];

                // FLAG UPDATE
                if (OutALU[7] == 1) begin // Negative
                    N = 1;
                end else begin
                    N = 0;
                end
            end
        endcase


        if (OutALU == 8'd0) begin // Zero
            Z = 1;
        end else begin
            Z = 0;
        end

        FlagOut <= {Z,C,N,O};
    end
endmodule

///////////////////////////////////////////////////////////
//                        Part 4                         //
///////////////////////////////////////////////////////////

module MUX_2TO1(S, D0, D1, Y);
    input wire S;
    input wire [7:0] D0;
    input wire [7:0] D1;
    output reg [7:0] Y;

    always@(S, D0, D1) begin
        case(S)
            1'b0: Y <= D0;
            1'b1: Y <= D1;
            default: Y <= D0;
        endcase
    end
endmodule

module MUX_4TO1(S, D0, D1, D2, D3, Y);
    input wire [1:0] S;
    input wire [7:0] D0; 
    input wire [7:0] D1;
    input wire [7:0] D2;
    input wire [7:0] D3;
    output reg [7:0] Y;

    always@(S, D0, D1, D2, D3) begin
        case(S)
            2'b00: Y <= D0;
            2'b01: Y <= D1;
            2'b10: Y <= D2;
            2'b11: Y <= D3;
            default: Y <= D0;
        endcase
    end
endmodule

module Memory(
    input wire [7:0] address,
    input wire [7:0] data,
    input wire wr, // Read = 0, Write = 1
    input wire cs, // Chip is enable when cs = 0
    input wire clock,
    output reg [7:0] o // Output
);
    //Declaration of the RAM area
    reg [7:0] RAM_DATA[0:255];
    //Read RAM data from the file
    initial $readmemh("RAM.mem", RAM_DATA);
    // Read the selected data from RAM
    always @(*) begin
        o = ~wr && ~cs ? RAM_DATA[address] : 8'hZ;
    end

    //Write the data to ram
    always @(posedge clock) begin
        if (wr && ~cs) begin
            RAM_DATA[address] <= data;
        end
    end
endmodule

module ALUSystem (
    RF_O1Sel, 
    RF_O2Sel, 
    RF_FunSel,
    RF_RSel,
    RF_TSel,
    ALU_FunSel,
    ALU_FlagReg,
    ARF_OutASel, 
    ARF_OutBSel, 
    ARF_FunSel,
    ARF_RegSel,
    IR_LH,
    IR_Enable,
    IR_Funsel,
    IROut,
    Mem_WR,
    Mem_CS,
    MuxASel,
    MuxBSel,
    MuxCSel,
    Clock
);
     
    //RF
    input wire [2:0] RF_O1Sel;
    input wire [2:0] RF_O2Sel;
    input wire [1:0] RF_FunSel; 
    input wire [3:0] RF_RSel;
    input wire [3:0] RF_TSel;
    wire [7:0] RF_O1; 
    wire [7:0] RF_O2;
    
    //ALU
    input wire [3:0] ALU_FunSel;
    wire [7:0] ALUOut;
    wire [3:0] ALUOutFlag;
    output wire [3:0] ALU_FlagReg;

    //ARF
    input wire [1:0] ARF_OutASel; 
    input wire [1:0] ARF_OutBSel; 
    input wire [1:0] ARF_FunSel;
    input wire [3:0] ARF_RegSel;
    wire [7:0] AOut;
    wire [7:0] BOut;
    
    //IR
    input wire IR_LH;
    input wire IR_Enable;
    input wire [1:0] IR_Funsel;
    output wire [15:0] IROut;

    //Memory
    input wire Mem_WR;
    input wire Mem_CS;
    wire [7:0] MemoryOut;
    wire [7:0] Address;

    // MUX A
    input wire [1:0] MuxASel;
    wire [7:0] MuxAOut;
    
    //MUX B
    input wire [1:0] MuxBSel;
    wire [7:0] MuxBOut;
    //MUX C
    input wire MuxCSel;
    wire [7:0] MuxCOut;
    
    input wire Clock;
    assign Address = BOut;
    
    Memory _Memory(
        .clock(Clock), 
        .address(Address), 
        .data(ALUOut), 
        .wr(Mem_WR), 
        .cs(Mem_CS), 
        .o(MemoryOut)
    );

    ALU _ALU(
        .A(MuxCOut), 
        .B(RF_O2), 
        .FunSel(ALU_FunSel), 
        .OutALU(ALUOut), 
        .FlagOut(ALUOutFlag)
    );
    
    MUX_4TO1 _MUXA(
        .S(MuxASel), 
        .D0(ALUOut), 
        .D1(MemoryOut), 
        .D2(IROut[7:0]), 
        .D3(AOut), 
        .Y(MuxAOut)
    );

    MUX_4TO1 _MUXB(
        .S(MuxBSel), 
        .D0(ALUOut), 
        .D1(MemoryOut), 
        .D2(IROut[7:0]), 
        .D3(AOut), 
        .Y(MuxBOut)
    );

    MUX_2TO1 _MUXC(
        .S(MuxCSel), 
        .D0(RF_O1), 
        .D1(AOut), 
        .Y(MuxCOut)
    );

    IR_register _IR(
        .clk(Clock),
        .I(MemoryOut),
        .FunSel(IR_Funsel),
        .E(IR_Enable),
        .L_H(IR_LH),
        .IROut(IROut)
    );

    register_file _RF(
        .clk(Clock),
        .I(MuxAOut), 
        .O1Sel(RF_O1Sel), 
        .O2Sel(RF_O2Sel), 
        .FunSel(RF_FunSel), 
        .RSel(RF_RSel), 
        .TSel(RF_TSel), 
        .O1(RF_O1), 
        .O2(RF_O2)
    );
    
    address_register_file _ARF(
        .I(MuxBOut), 
        .OutASel(ARF_OutASel), 
        .OutBSel(ARF_OutBSel), 
        .FunSel(ARF_FunSel), 
        .RSel(ARF_RegSel),
        .OutA(AOut), 
        .OutB(BOut), 
        .clk(Clock)
    );
    assign ALU_FlagReg = ALUOutFlag;
endmodule

///////////////////////////////////////////////////////////
//                      Project 2                        //
///////////////////////////////////////////////////////////

module counter(clk,reset,count,O);
    input wire clk,reset,count;
    output reg [3:0] O = 4'b0;

    always@(posedge clk)    //no need to reset if it overflows since the upper bits will be ignored 1111 -> 10000 which 0000 in our case
        begin
            if(reset)
                O <= 0;
            else if(count)
                O <= O + 1;
            else
                O <= O;
    end
endmodule

module decoder_4to16(enable,I,O);
    input wire enable;
    input wire [3:0] I;
    output reg [15:0] O;
    
    always @(*)
    begin
        if(enable) begin
        case(I)
            4'h0 : O = 16'h0001;
            4'h1 : O = 16'h0002;
            4'h2 : O = 16'h0004;
            4'h3 : O = 16'h0008;
            4'h4 : O = 16'h0010;
            4'h5 : O = 16'h0020;
            4'h6 : O = 16'h0040;
            4'h7 : O = 16'h0080;
            4'h8 : O = 16'h0100;
            4'h9 : O = 16'h0200;
            4'hA : O = 16'h0400;
            4'hB : O = 16'h0800;
            4'hC : O = 16'h1000;
            4'hD : O = 16'h2000;
            4'hE : O = 16'h4000;
            4'hF : O = 16'h8000;
            default : O = 0;
        endcase
        end
        else
        begin
            O = O;
        end
    end
endmodule
module fetch_L(T0,ARF_FunSel,ARF_RegSel,OutBSel,OutASel,cs,wr,E,L_H,IR_FunSel);
    input wire T0;
    output reg [1:0] ARF_FunSel;
    output reg [3:0] ARF_RegSel;
    output reg [1:0] OutBSel;
    output reg [1:0] OutASel;
    output reg cs; //chip select, is active low for memory
    output reg wr; //read is 0 write is 1
    output reg [1:0] IR_FunSel;
    output reg E;
    output reg L_H;
    
    
    always @(T0)        //might need to change it to always * later, but for now it makes sense
    begin
        if(T0)
        begin
            OutBSel <= 2'b11;
            //idk what to do with OutASel as I dont need it here
            OutASel <= 2'bZZ;
            cs <= 1'b0;
            wr <= 1'b0;
            E <= 1'b1;
            L_H <= 1'b0;
            IR_FunSel <= 2'b01;
            ARF_RegSel <= 4'b1000;
            ARF_FunSel <= 2'b11;
        end
        else
        begin
            OutBSel <= 2'bZZ;
            //idk what to do with OutASel as I dont need it here
            OutASel <= 2'bZZ;
            cs <= 1'bZ;
            wr <= 1'bZ;
            E <= 1'bZ;
            L_H <= 1'bZ;
            IR_FunSel <= 2'bZZ;
            ARF_RegSel <= 4'bZZZZ;
            ARF_FunSel <= 2'bZZ;
        end
        end
endmodule

module fetch_H(T1,ARF_FunSel,ARF_RegSel,OutBSel,OutASel,cs,wr,E,L_H,IR_FunSel);
    input wire T1;
    output reg [1:0] ARF_FunSel;
    output reg [3:0] ARF_RegSel;
    output reg [1:0] OutBSel;
    output reg [1:0] OutASel;
    output reg cs; //chip select, is active low for memory
    output reg wr; //read is 0 write is 1
    output reg [1:0] IR_FunSel;
    output reg E;
    output reg L_H;
    
    
    always @(T1)
    begin
        if(T1)
        begin
            OutBSel <= 2'b11;
            //idk what to do with OutASel as I dont need it here
            OutASel <= 2'bZZ;
            cs <= 1'b0;
            wr <= 1'b0;
            E <= 1'b1;
            L_H <= 1'b1;
            IR_FunSel <= 2'b01;
            ARF_RegSel <= 4'b1000;
            ARF_FunSel <= 2'b11;
        end
        else
        begin
            OutBSel <= 2'bZZ;
            //idk what to do with OutASel as I dont need it here
            OutASel <= 2'bZZ;
            cs <= 1'bZ;
            wr <= 1'bZ;
            E <= 1'bZ;
            L_H <= 1'bZ;
            IR_FunSel <= 2'bZZ;
            ARF_RegSel <= 4'bZZZZ;
            ARF_FunSel <= 2'bZZ;
        end
        end
endmodule


module instruction_decoder(T2,IR_H, D, A, SEL);         // A is for addressing if from D we get 9,10,12,13
    input wire [7:0] IR_H;
    input wire T2;
    output wire [15:0] D;
    output reg A;
    output reg [1:0] SEL;
    decoder_4to16 operation_decode(T2,IR_H[7:4],D);         // here I would get the output for the operation and accordingly I would use it in the enable parts of the other functions
        always @(*)
        begin
            if(T2)
            begin
            A <= IR_H[2];
            SEL <= IR_H[1:0];
            end
        end
endmodule

module execute_operation(
    input wire [15:0] T, // Timer
    input wire [15:0] D, // Operation
    input wire [3:0] ALU_FlagReg, // ALU Flags [ Z | C | N | O ]
    input wire [1:0] RSEL,
    input wire addressing_mode,
    input wire [7:0] address,

    output reg SC_Reset,
    
    output reg [2:0] RF_O1Sel, 
    output reg [2:0] RF_O2Sel, 
    output reg [1:0] RF_FunSel, 
    output reg [3:0] RF_RegSel, 
    output reg [3:0] RF_TSel, 
    
    output reg [1:0] MuxASel, 
    output reg [1:0] MuxBSel, 
    output reg MuxCSel, 
    
    output reg [1:0] ARF_FunSel,
    output reg [3:0] ARF_RegSel,
    output reg [1:0] ARF_OutASel,
    output reg [1:0] ARF_OutBSel,

    output reg [3:0] ALU_FunSel,

    output reg Mem_WR,
    output reg Mem_CS
    );
    
    reg IM = 0;
    reg Dir = 0; 
    wire Z = ALU_FlagReg[3];
    wire [3:0] DSTREG = {1'b0, addressing_mode, RSEL};
    wire [3:0] SREG1 = address[7:4];
    wire [3:0] SREG2 = address[3:0];

    // Sources:
    // 00 : RF, RF
    // 01 : RF, ARF
    // 10 : ARF, RF
    // 11 : ARF, ARF
    reg [1:0] sources = 2'b00; 

    always @(T or D or address or RSEL or addressing_mode or ALU_FlagReg) begin // I don't know if this works??
        if (T[0]) begin
            SC_Reset <= 0;
            Mem_CS <= 1;
            Mem_WR <= 0;
        end
        case (D)
            16'b0000_0000_0000_0001: ALU_FunSel <= 4'b0111; // AND
            16'b0000_0000_0000_0010: ALU_FunSel <= 4'b1000; // OR
            16'b0000_0000_0000_0100: ALU_FunSel <= 4'b0010; // NOT
            16'b0000_0000_0000_1000: ALU_FunSel <= 4'b0100; // ADD
            16'b0000_0000_0001_0000: ALU_FunSel <= 4'b0101; // SUB
            16'b0000_0000_0010_0000: ALU_FunSel <= 4'b1100; // LSR
            16'b0000_0000_0100_0000: ALU_FunSel <= 4'b1011; // LSL
            16'b0000_0000_1000_0000: ALU_FunSel <= 4'b0000; // INC DSTREG <- SREG1 // DSTREG <- DSTREG + 1
            16'b0000_0001_0000_0000: ALU_FunSel <= 4'b0000; // DEC DSTREG <- SREG1 // DSTREG <- DSTREG - 1
            16'b0000_1000_0000_0000: ALU_FunSel <= 4'b0000; // MOV
        endcase

        if ((D[9] || D[10] || D[12] || D[13] || D[14] || D[15])) begin 
            if (addressing_mode == 0) begin
                IM <= 1;
                Dir <= 0;
            end else begin
                IM <= 0;
                Dir <= 1;
            end
        end

        // SREG1 from RF
        if ((D[0] || D[1] || D[3] || D[4] || D[2] || D[5] || D[6] || D[7] || D[8] || D[11])
            && T[3] && SREG1[2] == 0) begin
            // ALU_A <- SREG1
            RF_O1Sel <= {1'b1, SREG1[1:0]};
            MuxCSel <= 0;
            sources <= {SREG1[2], sources[0]};    
        end

        // SREG2 from RF
        if ((D[0] || D[1] || D[3] || D[4]) 
            && T[3] && SREG2[2] == 0) begin
            // ALU_B <- SREG2
            RF_O2Sel <= {1'b1, SREG2[1:0]};
            sources <= {sources[1], SREG2[2]};    
        end

        // SREG1 from ARF
        if ((D[0] || D[1] || D[3] || D[4] || D[2] || D[5] || D[6] || D[7] || D[8])
            && T[3] && SREG1[2] == 1) begin
            // ALU_A <- SREG1
            MuxCSel <= 1;
            case (SREG1[1:0])
                2'b00: ARF_OutASel <= 2'b01; // ARF Output is SP
                2'b01: ARF_OutASel <= 2'b00; // ARF Output is AR
                2'b10: ARF_OutASel <= 2'b11; // ARF Output is PC
                2'b11: ARF_OutASel <= 2'b11; // ARF Output is PC
                default: ARF_OutASel <= 2'b11;
            endcase
            
            sources = {SREG1[2], sources[0]};
        end

        // SREG2 from ARF
        if ((D[0] || D[1] || D[3] || D[4]) 
            && T[3] && SREG2[2] == 1) begin
            // RF_T1 <- SREG2
            case (SREG2[1:0])
                2'b00: ARF_OutASel <= 2'b01; // ARF Output is SP
                2'b01: ARF_OutASel <= 2'b00; // ARF Output is AR
                2'b10: ARF_OutASel <= 2'b11; // ARF Output is PC
                2'b11: ARF_OutASel <= 2'b11; // ARF Output is PC
                default: ARF_OutASel <= 2'b11;
            endcase 
            MuxASel <= 2'b11;
            RF_FunSel <= 2'b01;
            RF_TSel <= 4'b1000;
            RF_O2Sel <= 3'b000;

            sources <= {sources[1], SREG2[2]};
        end

        if (T[4] && sources[0] == 1) begin
            // ALU_B <- T1
            RF_TSel <= 4'b0000;
            RF_FunSel <= 2'b00;
        end


        // DSTREG is in RF
        if (((T[3] && sources == 2'b00) || 
            (T[4] && sources == 2'b01) || 
            (T[3] && sources == 2'b10)) &&
            DSTREG[2] == 0 && !(D[9] || D[10] || D[12] || D[13] || D[14] || D[15])) 
        begin
            // DSTREG <- ALU_Out
            MuxASel <= 2'b00;
            RF_FunSel = 2'b01;
            case (DSTREG[1:0])
                2'b00 : RF_RegSel <= 4'b1000; // R1
                2'b01 : RF_RegSel <= 4'b0100; // R2
                2'b10 : RF_RegSel <= 4'b0010; // R3
                2'b11 : RF_RegSel <= 4'b0001; // R4
                default: RF_RegSel <= 4'bZZZZ;
            endcase
        end

        // DSTREG is in ARF
        if (((T[3] && sources == 2'b00) || 
            (T[4] && sources == 2'b01) || 
            (T[3] && sources == 2'b10)) &&
            DSTREG[2] == 1 && !(D[9] || D[10] || D[12] || D[13] || D[14] || D[15])) 
        begin
            // DSTREG <- ALU_Out
            MuxBSel <= 2'b00;
            ARF_FunSel <= 2'b01;
            case (DSTREG[1:0])
                2'b01: ARF_RegSel <= 4'b1000; // AR
                2'b00: ARF_RegSel <= 4'b0100; // SP
                2'b10: ARF_RegSel <= 4'b0001; // PC
                2'b11: ARF_RegSel <= 4'b0001; // PC
                default: ARF_RegSel <= 4'bZZZZ;
            endcase
        end

        // In case of increment, increment DSTREG, it's already swapped with SREG1
        if (((T[4] && sources == 2'b00) || 
            (T[5] && sources == 2'b01) || 
            (T[4] && sources == 2'b10)) &&
            D[7]) begin
            if (DSTREG[2] == 1) begin // If DSTREG is in ARF
                ARF_FunSel <= 2'b11; // Increment
            end else begin // If DSTREG is in RF
                RF_FunSel <= 2'b11; // Increment
            end
        end

        // In case of decrement, decrement DSTREG, it's already swapped with SREG1
        if (((T[4] && sources == 2'b00) || 
            (T[5] && sources == 2'b01) || 
            (T[4] && sources == 2'b10)) &&
            D[8]) begin
            if (DSTREG[2] == 1) begin // If DSTREG is in ARF
                ARF_FunSel <= 2'b10; // Decrement
            end else begin // If DSTREG is in RF
                RF_FunSel <= 2'b10; // Decrement
            end
        end


        //RF_O1Sel
        if(D[12] && T[4] && Dir)
        begin
            RF_O1Sel <= 3'b000;
        end
        
        if((D[13] && T[3] && Dir) || (D[15] && T[3]))
        begin
            RF_O1Sel <= {1'b1, RSEL};
        end
                
        //RF_FunSel
        if((D[12] && T[3]) || (D[14] && T[4]))
        begin
            RF_FunSel <= 2'b01;
        end

        //RF_RegSel
        if((D[12] && T[3]) || (D[14] && T[4]))
        begin
            case (RSEL)
            2'b00 : RF_RegSel <= 4'b1000;
            2'b01 : RF_RegSel <= 4'b0100;
            2'b10 : RF_RegSel <= 4'b0010;
            2'b11 : RF_RegSel <= 4'b0001; 
            endcase
        end

        //ALUFunSel
        if((D[12] && T[4] && Dir) || (D[15] && T[3]) || (D[13] && T[3] && Dir))
        begin
            ALU_FunSel <= 4'b0000;
        end
        
        //ARFOutBSel
        if((D[14] && T[4]) || (D[15] && T[3]))
        begin
            ARF_OutBSel <= 2'b01;
        end
        
        if((D[12] && T[3] && Dir) || (D[12] && T[5] && Dir) || (D[13] && T[4] && Dir) || (D[13] && T[3] && Dir))
        begin
            ARF_OutBSel <= 2'b00;
        end
        
        //ARFFunSel
        if(D[15] && T[4])
        begin
            ARF_FunSel <= 2'b10;
        end

        if(T[3])
        begin
            case (D)
                16'b0100_0000_0000_0000: ARF_FunSel = 2'b11;
                16'b0000_0010_0000_0000: begin
                    if(IM) begin
                        ARF_FunSel = 2'b01;
                    end
                end
                16'b0000_0100_0000_0000: begin
                    if(IM && !Z) begin
                        ARF_FunSel = 2'b01;
                    end
                end
            endcase
        end
        
        //ARF_RegSel
        if((D[15] && T[4]) || (D[14] && T[3]))
        begin
            ARF_RegSel <= 4'b0010;
        end

        if((D[9] && T[3] && IM) || (D[10] && T[3] && IM && !Z))
        begin
            ARF_RegSel <= 4'b1000;
        end
        
        //Mem_WR
        if((D[15] && T[3]) || (D[13] && T[3] && Dir))
        begin
            Mem_WR <= 1'b1;
        end
        
        if((D[14] && T[4]) || (D[13] && T[4] && Dir) || (D[12] && T[3] && Dir))
        begin
            Mem_WR <= 1'b0;
        end

        //Mem_CS
        if((D[13] && T[4] && Dir) || (D[15] && T[3]) || (D[14] && T[4]) || (D[13] && T[3] && Dir) || (D[12] && T[3] && Dir))
        begin
            Mem_CS <= 1'b0;
        end

        //MuxAsel
        if((D[14] && T[4]) || (D[12] && T[3] && Dir))
        begin
            MuxASel <= 2'b01;
        end
        
        if(D[12] && T[3] && IM)
        begin
            MuxASel <= 2'b10;
        end

        //MuxBSel
        if((D[9] && T[3] && IM) || (D[10] && T[3] && IM && !Z))
        begin
            MuxBSel <= 2'b10;
        end
        
        //MuxCSel
        if((D[15] && T[3]) || (D[12] && T[4] && Dir) || (D[13] && T[3] && Dir))
        begin
            MuxCSel <= 1'b0;
        end
        // Choose correct time to reset sequence counter, 
        //    set RF_FunSel and ARF_FunSel to ZZ, set RF_RegSel, RF_TSel and ARF_RegSel to ZZZZ

        /*
            D0  ends at T3
            D1  ends at T3
            D2  ends at T3
            D3  ends at T3
            D4  ends at T3
            D5  ends at T3
            D6  ends at T3
            D7  ends at T4
            D8  ends at T4
            D9  ends at T3 (IM)
            D10 ends at T4 (IM)
            D11 ends at T3
            D12 ends at T3 if it's D
            D12 ends at T3 if it's IM
            D13 ends at T3
            D14 ends at T4
            D15 ends at T4
        */
        // Clean up
        // If timer doesn't work, increment them by 1
        if ((T[4] && (D[0] || D[1] || D[2] || D[3] || D[4] || D[5] || D[6] || (D[9] && IM) || D[11] || (D[12] && (IM || Dir)) || D[13] || (D[10] && IM))) ||
            (T[5] && (D[7] || D[8] || D[14] || D[15]))) begin
            SC_Reset <= 1; // Reset the counter to zero
            RF_RegSel <= 4'bZZZZ;
            RF_TSel <= 4'bZZZZ;
            ARF_RegSel <= 4'bZZZZ; 
            RF_FunSel <= 2'bZZ;
            ARF_FunSel <= 2'bZZ;
            Mem_CS <= 1;
            Mem_WR <= 0;
            MuxASel <= 2'bZZ;
            MuxBSel <= 2'bZZ;
            MuxCSel <= 1'bZ;
            RF_O1Sel <= 3'bZ;
            RF_O2Sel <= 3'bZ;
            ARF_OutASel <= 2'bZ; 
            ARF_OutBSel <= 2'bZ; 
        end
    end
endmodule

module control_unit(clk, IROut,ARF_FunSel,ARF_RegSel,ARF_OutBSel, ARF_OutASel, 
    ALU_FlagReg, ALU_FunSel, RF_O1Sel, RF_O2Sel, RF_FunSel, RF_RegSel, RF_TSel,
    MuxASel, MuxBSel, MuxCSel, Mem_CS, Mem_WR, IR_LH, IR_Enable, IR_FunSel, SC_Reset);    //add the outputs you need for enable, I added the ones I need, FUNSEL, REGSEL, ...........
    input wire clk;
    input wire [15:0] IROut;      //the high part of the IR used in the decoding process
    input wire [3:0] ALU_FlagReg;
    
    output reg SC_Reset;        //this value is going to be changed from your final execution modules, also idk whether this should be input/output it depends on the way you guys code so change it if you see it suitable
    output reg [1:0] ARF_FunSel;
    output reg [3:0] ARF_RegSel;
    output reg [1:0] ARF_OutBSel;
    output reg [1:0] ARF_OutASel;
    output reg [3:0] ALU_FunSel;
    output reg [2:0] RF_O1Sel;
    output reg [2:0] RF_O2Sel;
    output reg [1:0] RF_FunSel;
    output reg [3:0] RF_RegSel;
    output reg [3:0] RF_TSel;

    output reg [1:0] MuxASel;
    output reg [1:0] MuxBSel;
    output reg MuxCSel;

    output reg Mem_CS;
    output reg Mem_WR;
    output reg IR_LH;
    output reg IR_Enable;
    output reg [1:0] IR_FunSel; 

    wire [15:0] T;
    wire [3:0] temp;    //temp wire to send data from counter to decoder
    //creating a counter that is then decoded to give me the times needed to make my instructions execute in orded
    counter SC(clk,SC_Reset,1'b1,temp);       //gave 1 to count continuously
    decoder_4to16 SC_decoder(1'b1,temp,T);    //gave 1 to be always active
    // Setup the system
    initial begin
        Mem_WR <= 1'b0;
        Mem_CS <= 1'b1;
        ARF_FunSel <= 2'b00;
        RF_FunSel <= 2'b00;
        RF_RegSel <= 4'b1111;
        ARF_RegSel <= 4'b1111;
        RF_TSel <= 4'b1111;
        SC_Reset <= 1;
        
        #6; // According to clock frequency
        RF_RegSel <= 4'b0000;
        ARF_RegSel <= 4'b0000;
        RF_TSel <= 4'b0000;
        SC_Reset <= 0;
        #4;
    end
    //Dont forget to reset PC at the start of the last module to start it from 0
    
    //fetching the instructions in low indian order, needs two cylces as memory line is limited, they are different modules, fetch_L and fetch_H
    always @(T[0])
    begin
        if(T[0] && SC_Reset == 0)
        begin
            ARF_OutBSel <= 2'b11;
            ARF_OutASel <= 2'bZ;
            Mem_CS <= 1'b0;
            Mem_WR <= 1'b0;
            IR_Enable <= 1'b1;
            IR_LH <= 1'b0;
            IR_FunSel <= 2'b01;
            ARF_RegSel <= 4'b1000;
            ARF_FunSel <= 2'b11;
        end
        else
        begin
            ARF_OutBSel <= 2'bZ;
            ARF_OutASel <= 2'bZ;
            Mem_CS <= 1'bZ;
            Mem_WR <= 1'bZ;
            IR_Enable <= 1'bZ;
            IR_LH <= 1'bZ;
            IR_FunSel <= 2'bZ;
            ARF_RegSel <= 4'b0;
            ARF_FunSel <= 2'bZ;
        end
    end
    always @(T[1])
    begin
        if(T[1])
        begin
            ARF_OutBSel <= 2'b11;
            ARF_OutASel <= 2'bZ;
            Mem_CS <= 1'b0;
            Mem_WR <= 1'b0;
            IR_Enable<= 1'b1;
            IR_LH <= 1'b1;
            IR_FunSel <= 2'b01;
            ARF_RegSel <= 4'b1000;
            ARF_FunSel <= 2'b11;
        end
        else
        begin
            ARF_OutBSel <= 2'bZ;
            ARF_OutASel <= 2'bZ;
            Mem_CS <= 1'bZ;
            Mem_WR <= 1'bZ;
            IR_Enable<= 1'bZ;
            IR_LH <= 1'bZ;
            IR_FunSel <= 2'bZ;
            ARF_RegSel <= 4'b0;
            ARF_FunSel <= 2'bZ;
        end
    end
    
    //decoding the instruction after it has been fully loaded to the instruction register
    wire [15:0] D;    //used to give out which instruction it is
    wire A;          //used to give out whether it is Direct/Indirect or ARF/RF related
    wire [1:0] SEL;        //used in the selection of the register, if you forgot how i explained it ask me
    instruction_decoder step3(T[2], IROut[15:8], D, A, SEL);

    reg IM = 0;
    reg Dir = 0; 
    wire Z = ALU_FlagReg[3];
    wire [3:0] DSTREG = {1'b0, A, SEL};
    wire [3:0] SREG1 = IROut[7:4];
    wire [3:0] SREG2 = IROut[3:0];

    // Sources:
    // 00 : RF, RF
    // 01 : RF, ARF
    // 10 : ARF, RF
    // 11 : ARF, ARF
    reg [1:0] sources = 2'b00; 

    always @(T or D or IROut[7:0] or SEL or A or ALU_FlagReg) begin // I don't know if this works??
        if (T[0]) begin
            SC_Reset <= 0;
            RF_O1Sel <= 3'bZ;
            RF_O2Sel <= 3'bZ;
            RF_RegSel <= 4'bZ;
            RF_TSel <= 4'bZ;
            ARF_RegSel <= 4'bZ; 
            ARF_OutASel <= 2'bZ; 
            ARF_OutBSel <= 2'bZ; 
            RF_FunSel <= 2'bZ;
            ARF_FunSel <= 2'bZ;
            ALU_FunSel <= 4'bZ;
            Mem_CS <= 1;
            Mem_WR <= 0;
        end
        case (D)
            16'b0000_0000_0000_0001: ALU_FunSel <= 4'b0111; // AND
            16'b0000_0000_0000_0010: ALU_FunSel <= 4'b1000; // OR
            16'b0000_0000_0000_0100: ALU_FunSel <= 4'b0010; // NOT
            16'b0000_0000_0000_1000: ALU_FunSel <= 4'b0100; // ADD
            16'b0000_0000_0001_0000: ALU_FunSel <= 4'b0101; // SUB
            16'b0000_0000_0010_0000: ALU_FunSel <= 4'b1100; // LSR
            16'b0000_0000_0100_0000: ALU_FunSel <= 4'b1011; // LSL
            16'b0000_0000_1000_0000: ALU_FunSel <= 4'b0000; // INC DSTREG <- SREG1 // DSTREG <- DSTREG + 1
            16'b0000_0001_0000_0000: ALU_FunSel <= 4'b0000; // DEC DSTREG <- SREG1 // DSTREG <- DSTREG - 1
            16'b0000_1000_0000_0000: ALU_FunSel <= 4'b0000; // MOV
        endcase

        if ((D[9] || D[10] || D[12] || D[13] || D[14] || D[15])) begin 
            if (A == 0) begin
                IM <= 1;
                Dir <= 0;
            end else begin
                IM <= 0;
                Dir <= 1;
            end
        end

        // SREG1 from RF
        if ((D[0] || D[1] || D[3] || D[4] || D[2] || D[5] || D[6] || D[7] || D[8] || D[11])
            && T[3] && SREG1[2] == 0) begin
            // ALU_A <- SREG1
            RF_O1Sel <= {1'b1, SREG1[1:0]};
            MuxCSel <= 0;
            sources <= {SREG1[2], sources[0]};    
        end

        // SREG2 from RF
        if ((D[0] || D[1] || D[3] || D[4]) 
            && T[3] && SREG2[2] == 0) begin
            // ALU_B <- SREG2
            RF_O2Sel <= {1'b1, SREG2[1:0]};
            sources <= {sources[1], SREG2[2]};    
        end

        // SREG1 from ARF
        if ((D[0] || D[1] || D[3] || D[4] || D[2] || D[5] || D[6] || D[7] || D[8])
            && T[3] && SREG1[2] == 1) begin
            // ALU_A <- SREG1
            MuxCSel <= 1;
            case (SREG1[1:0])
                2'b00: ARF_OutASel <= 2'b01; // ARF Output is SP
                2'b01: ARF_OutASel <= 2'b00; // ARF Output is AR
                2'b10: ARF_OutASel <= 2'b11; // ARF Output is PC
                2'b11: ARF_OutASel <= 2'b11; // ARF Output is PC
                default: ARF_OutASel <= 2'b11;
            endcase
            
            sources = {SREG1[2], sources[0]};
        end

        // SREG2 from ARF
        if ((D[0] || D[1] || D[3] || D[4]) 
            && T[3] && SREG2[2] == 1) begin
            // RF_T1 <- SREG2
            case (SREG2[1:0])
                2'b00: ARF_OutASel <= 2'b01; // ARF Output is SP
                2'b01: ARF_OutASel <= 2'b00; // ARF Output is AR
                2'b10: ARF_OutASel <= 2'b11; // ARF Output is PC
                2'b11: ARF_OutASel <= 2'b11; // ARF Output is PC
                default: ARF_OutASel <= 2'b11;
            endcase 
            MuxASel <= 2'b11;
            RF_FunSel <= 2'b01;
            RF_TSel <= 4'b1000;
            RF_O2Sel <= 3'b000;

            sources <= {sources[1], SREG2[2]};
        end

        if (T[4] && sources[0] == 1) begin
            // ALU_B <- T1
            RF_TSel <= 4'b0000;
            RF_FunSel <= 2'b00;
        end


        // DSTREG is in RF
        if (((T[3] && sources == 2'b00) || 
            (T[4] && sources == 2'b01) || 
            (T[3] && sources == 2'b10)) &&
            DSTREG[2] == 0 && !(D[9] || D[10] || D[12] || D[13] || D[14] || D[15])) 
        begin
            // DSTREG <- ALU_Out
            MuxASel <= 2'b00;
            RF_FunSel = 2'b01;
            case (DSTREG[1:0])
                2'b00 : RF_RegSel <= 4'b1000; // R1
                2'b01 : RF_RegSel <= 4'b0100; // R2
                2'b10 : RF_RegSel <= 4'b0010; // R3
                2'b11 : RF_RegSel <= 4'b0001; // R4
                default: RF_RegSel <= 4'bZZZZ;
            endcase
        end

        // DSTREG is in ARF
        if (((T[3] && sources == 2'b00) || 
            (T[4] && sources == 2'b01) || 
            (T[3] && sources == 2'b10)) &&
            DSTREG[2] == 1 && !(D[9] || D[10] || D[12] || D[13] || D[14] || D[15])) 
        begin
            // DSTREG <- ALU_Out
            MuxBSel <= 2'b00;
            ARF_FunSel <= 2'b01;
            case (DSTREG[1:0])
                2'b01: ARF_RegSel <= 4'b1000; // AR
                2'b00: ARF_RegSel <= 4'b0100; // SP
                2'b10: ARF_RegSel <= 4'b0001; // PC
                2'b11: ARF_RegSel <= 4'b0001; // PC
                default: ARF_RegSel <= 4'bZZZZ;
            endcase
        end

        // In case of increment, increment DSTREG, it's already swapped with SREG1
        if (((T[4] && sources == 2'b00) || 
            (T[5] && sources == 2'b01) || 
            (T[4] && sources == 2'b10)) &&
            D[7]) begin
            if (DSTREG[2] == 1) begin // If DSTREG is in ARF
                ARF_FunSel <= 2'b11; // Increment
            end else begin // If DSTREG is in RF
                RF_FunSel <= 2'b11; // Increment
            end
        end

        // In case of decrement, decrement DSTREG, it's already swapped with SREG1
        if (((T[4] && sources == 2'b00) || 
            (T[5] && sources == 2'b01) || 
            (T[4] && sources == 2'b10)) &&
            D[8]) begin
            if (DSTREG[2] == 1) begin // If DSTREG is in ARF
                ARF_FunSel <= 2'b10; // Decrement
            end else begin // If DSTREG is in RF
                RF_FunSel <= 2'b10; // Decrement
            end
        end


        //RF_O1Sel
        if(D[12] && T[4] && Dir)
        begin
            RF_O1Sel <= 3'b000;
        end
        
        if((D[13] && T[3] && Dir) || (D[15] && T[3]))
        begin
            RF_O1Sel <= {1'b1, SEL};
        end
                
        //RF_FunSel
        if((D[12] && T[3]) || (D[14] && T[4]))
        begin
            RF_FunSel <= 2'b01;
        end

        //RF_RegSel
        if((D[12] && T[3]) || (D[14] && T[4]))
        begin
            case (SEL)
            2'b00 : RF_RegSel <= 4'b1000;
            2'b01 : RF_RegSel <= 4'b0100;
            2'b10 : RF_RegSel <= 4'b0010;
            2'b11 : RF_RegSel <= 4'b0001; 
            endcase
        end

        //ALUFunSel
        if((D[12] && T[4] && Dir) || (D[15] && T[3]) || (D[13] && T[3] && Dir))
        begin
            ALU_FunSel <= 4'b0000;
        end
        
        //ARFOutBSel
        if((D[14] && T[4]) || (D[15] && T[3]))
        begin
            ARF_OutBSel <= 2'b01;
        end
        
        if((D[12] && T[3] && Dir) || (D[12] && T[5] && Dir) || (D[13] && T[4] && Dir) || (D[13] && T[3] && Dir))
        begin
            ARF_OutBSel <= 2'b00;
        end
        
        //ARFFunSel
        if(D[15] && T[4])
        begin
            ARF_FunSel <= 2'b10;
        end

        if(T[3])
        begin
            case (D)
                16'b0100_0000_0000_0000: ARF_FunSel = 2'b11;
                16'b0000_0010_0000_0000: begin
                    if(IM) begin
                        ARF_FunSel = 2'b01;
                    end
                end
                16'b0000_0100_0000_0000: begin
                    if(IM && !Z) begin
                        ARF_FunSel = 2'b01;
                    end
                end
            endcase
        end
        
        //ARF_RegSel
        if((D[15] && T[4]) || (D[14] && T[3]))
        begin
            ARF_RegSel <= 4'b0010;
        end

        if((D[9] && T[3] && IM) || (D[10] && T[3] && IM && !Z))
        begin
            ARF_RegSel <= 4'b1000;
        end
        
        //Mem_WR
        if((D[15] && T[3]) || (D[13] && T[3] && Dir))
        begin
            Mem_WR <= 1'b1;
        end
        
        if((D[14] && T[4]) || (D[13] && T[4] && Dir) || (D[12] && T[3] && Dir))
        begin
            Mem_WR <= 1'b0;
        end

        //Mem_CS
        if((D[13] && T[4] && Dir) || (D[15] && T[3]) || (D[14] && T[4]) || (D[13] && T[3] && Dir) || (D[12] && T[3] && Dir))
        begin
            Mem_CS <= 1'b0;
        end

        //MuxAsel
        if((D[14] && T[4]) || (D[12] && T[3] && Dir))
        begin
            MuxASel <= 2'b01;
        end
        
        if(D[12] && T[3] && IM)
        begin
            MuxASel <= 2'b10;
        end

        //MuxBSel
        if((D[9] && T[3] && IM) || (D[10] && T[3] && IM && !Z))
        begin
            MuxBSel <= 2'b10;
        end
        
        //MuxCSel
        if((D[15] && T[3]) || (D[12] && T[4] && Dir) || (D[13] && T[3] && Dir))
        begin
            MuxCSel <= 1'b0;
        end
        // Choose correct time to reset sequence counter, 
        //    set RF_FunSel and ARF_FunSel to ZZ, set RF_RegSel, RF_TSel and ARF_RegSel to ZZZZ

        /*
            D0  ends at T3
            D1  ends at T3
            D2  ends at T3
            D3  ends at T3
            D4  ends at T3
            D5  ends at T3
            D6  ends at T3
            D7  ends at T4
            D8  ends at T4
            D9  ends at T3 (IM)
            D10 ends at T4 (IM)
            D11 ends at T3
            D12 ends at T3 if it's D
            D12 ends at T3 if it's IM
            D13 ends at T3
            D14 ends at T4
            D15 ends at T4
        */
        // Clean up
        // If timer doesn't work, increment them by 1
        if ((T[4] && (D[0] || D[1] || D[2] || D[3] || D[4] || D[5] || D[6] || (D[9] && IM) || D[11] || (D[12] && (IM || Dir)) || D[13] || (D[10] && IM))) ||
            (T[5] && (D[7] || D[8] || D[14] || D[15]))) begin
            SC_Reset <= 1; // Reset the counter to zero
            RF_RegSel <= 4'bZZZZ;
            RF_TSel <= 4'bZZZZ;
            ARF_RegSel <= 4'bZZZZ; 
            RF_FunSel <= 2'bZZ;
            ARF_FunSel <= 2'bZZ;
            Mem_CS <= 1;
            Mem_WR <= 0;
            MuxASel <= 2'bZZ;
            MuxBSel <= 2'bZZ;
            MuxCSel <= 1'bZ;
        end
    end
    //I edited the IR_H to IROut which is 16 bits, everything above its the same with the previous code.
endmodule        

module CPUSystem(input wire Clock, input wire Reset, input wire [7:0] T);
    wire [2:0] RF_O1Sel;
    wire [2:0] RF_O2Sel;
    wire [1:0] RF_FunSel;
    wire [3:0] RF_RSel;
    wire [3:0] RF_TSel;
    wire [3:0] ALU_FunSel;
    wire [1:0] ARF_OutASel; 
    wire [1:0] ARF_OutBSel; 
    wire [1:0] ARF_FunSel; 
    wire [3:0] ARF_RSel;
    wire IR_LH; 
    wire IR_Enable;
    wire [1:0] IR_FunSel;
    wire [15:0] IROut;
    wire Mem_WR;
    wire Mem_CS;
    wire [1:0] MuxASel;
    wire [1:0] MuxBSel;
    wire MuxCSel;
    wire [3:0] ALU_FlagReg;

    ALUSystem ALU(
        .RF_O1Sel(RF_O1Sel), 
        .RF_O2Sel(RF_O2Sel), 
        .RF_FunSel(RF_FunSel),
        .RF_RSel(RF_RSel),
        .RF_TSel(RF_TSel),
        .ALU_FunSel(ALU_FunSel),
        .ARF_OutASel(ARF_OutASel), 
        .ARF_OutBSel(ARF_OutBSel), 
        .ARF_FunSel(ARF_FunSel),
        .ARF_RegSel(ARF_RSel),
        .IR_LH(IR_LH),
        .IR_Enable(IR_Enable),
        .IR_Funsel(IR_FunSel),
        .IROut(IROut),
        .Mem_WR(Mem_WR),
        .Mem_CS(Mem_CS),
        .MuxASel(MuxASel),
        .MuxBSel(MuxBSel),
        .MuxCSel(MuxCSel),
        .ALU_FlagReg(ALU_FlagReg),
        .Clock(Clock));
        
    control_unit CU(
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
        .IR_FunSel(IR_FunSel));
endmodule

module control_unit(clk,IROut,SC_reset,ARF_FunSel,ARF_RegSel,OutBSel,OutASel);    //add the outputs you need for enable, I added the ones I need, FUNSEL, REGSEL, ...........
    input wire clk;
    input wire SC_reset;        //this value is going to be changed from your final execution modules, also idk whether this should be input/output it depends on the way you guys code so change it if you see it suitable
    input wire [15:0] IROut;      //the high part of the IR used in the decoding process
    output wire [1:0] ARF_FunSel;
    output wire [3:0] ARF_RegSel;
    output wire [1:0] OutBSel;
    output wire [1:0] OutASel;
    // I added the main inputs and outputs of the module up, the wires and registers required for intermeadiate work is set near the call of the responsible module
    
    
    wire [15:0] T;
    wire [3:0] temp;    //temp wire to send data from counter to decoder
    //creating a counter that is then decoded to give me the times needed to make my instructions execute in orded
    counter SC(clk,SC_reset,1,temp);       //gave 1 to count continuously
    decoder_4to16 SC_decoder(1,temp,T);    //gave 1 to be always active
    
    
    //Dont forget to reset PC at the start of the last module to start it from 0
    
    //fetching the instructions in low indian order, needs two cylces as memory line is limited, they are different modules, fetch_L and fetch_H
    fetch_L step1(T[0],ARF_FunSel,ARF_RegSel,OutBSel,OutASel,cs,wr,E,L_H,IR_FunSel);
    fetch_H step2(T[1],ARF_FunSel,ARF_RegSel,OutBSel,OutASel,cs,wr,E,L_H,IR_FunSel);
    
    //decoding the instruction after it has been fully loaded to the instruction register
    wire [15:0] D;    //used to give out which instruction it is
    wire A;          //used to give out whether it is Direct/Indirect or ARF/RF related
    wire SEL;        //used in the selection of the register, if you forgot how i explained it ask me
    instruction_decoder step3(T[2], IROut[15:8], D, A, SEL);

    //I edited the IR_H to IROut which is 16 bits, everything above its the same with the previous�code.
endmodule

module control_unit_1(clk,IROut,SC_reset,ARF_FunSel,ARF_RegSel,OutBSel,OutASel);    //add the outputs you need for enable, I added the ones I need, FUNSEL, REGSEL, ...........
    input wire clk;
    input wire SC_reset;        //this value is going to be changed from your final execution modules, also idk whether this should be input/output it depends on the way you guys code so change it if you see it suitable
    input wire [15:0] IROut;      //the high part of the IR used in the decoding process
    output wire [1:0] ARF_FunSel;
    output wire [3:0] ARF_RegSel;
    output wire [1:0] OutBSel;
    output wire [1:0] OutASel;
    // I added the main inputs and outputs of the module up, the wires and registers required for intermeadiate work is set near the call of the responsible module
    
    
    wire [15:0] T;
    wire [3:0] temp;    //temp wire to send data from counter to decoder
    //creating a counter that is then decoded to give me the times needed to make my instructions execute in orded
    counter SC(clk,SC_reset,1,temp);       //gave 1 to count continuously
    decoder_4to16 SC_decoder(1,temp,T);    //gave 1 to be always active
    
    
    //Dont forget to reset PC at the start of the last module to start it from 0
    
    //fetching the instructions in low indian order, needs two cylces as memory line is limited, they are different modules, fetch_L and fetch_H
    fetch_L step1(T[0],ARF_FunSel,ARF_RegSel,OutBSel,OutASel,cs,wr,E,L_H,IR_FunSel);
    fetch_H step2(T[1],ARF_FunSel,ARF_RegSel,OutBSel,OutASel,cs,wr,E,L_H,IR_FunSel);
    
    //decoding the instruction after it has been fully loaded to the instruction register
    wire [15:0] D;    //used to give out which instruction it is
    wire A;          //used to give out whether it is Direct/Indirect or ARF/RF related
    wire SEL;        //used in the selection of the register, if you forgot how i explained it ask me
    instruction_decoder step3(T[2], IROut[15:8], D, A, SEL);

    //I edited the IR_H to IROut which is 16 bits, everything above its the same with the previous code.
endmodule
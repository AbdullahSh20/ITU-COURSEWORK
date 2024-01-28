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
                2'b00   :   IROut <= 0;
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
                2'b10   :   IROut <= IROut - 1;
                2'b11   :   IROut <= IROut + 1;
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
    reg Z = 0;
    reg C = 0;
    reg N = 0;
    reg O = 0; 
    // Zero|Carry|Negative|Overflow
    
    always @(*) begin
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

        default: // Return A
            begin
                OutALU = A;

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

    always@(*) begin
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

    always@(*) begin
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

module ALU_System (
    RF_OutASel, 
    RF_OutBSel, 
    RF_FunSel,
    RF_RSel,
    RF_TSel,
    ALU_FunSel,
    ARF_OutCSel, 
    ARF_OutDSel, 
    ARF_FunSel,
    ARF_RegSel,
    IR_LH,
    IR_Enable,
    IR_Funsel,
    Mem_WR,
    Mem_CS,
    MuxASel,
    MuxBSel,
    MuxCSel,
    Clock
);
     
    //RF
    input wire [2:0] RF_OutASel; // RF_O1Sel
    input wire [2:0] RF_OutBSel; // RF_O2Sel
    input wire [1:0] RF_FunSel; 
    input wire [3:0] RF_RSel;
    input wire [3:0] RF_TSel;
    wire [7:0] RF_O1; 
    wire [7:0] RF_O2;
    
    //ALU
    input wire [3:0] ALU_FunSel;
    wire [7:0] ALUOut;
    wire [3:0] ALUOutFlag;

    //ARF
    input wire [1:0] ARF_OutCSel; 
    input wire [1:0] ARF_OutDSel; 
    input wire [1:0] ARF_FunSel;
    input wire [3:0] ARF_RegSel;
    wire [7:0] AOut;
    wire [7:0] BOut;
    
    //IR
    input wire IR_LH;
    input wire IR_Enable;
    input wire [1:0] IR_Funsel;
    wire [15:0] IROut;

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

    register_file _RegisterFile(
        .clk(Clock),
        .I(MuxAOut), 
        .O1Sel(RF_OutASel), 
        .O2Sel(RF_OutBSel), 
        .FunSel(RF_FunSel), 
        .RSel(RF_RSel), 
        .TSel(RF_TSel), 
        .O1(RF_O1), 
        .O2(RF_O2)
    );
    
    address_register_file _ARF(
        .I(MuxBOut), 
        .OutASel(ARF_OutCSel), 
        .OutBSel(ARF_OutDSel), 
        .FunSel(ARF_FunSel), 
        .RSel(ARF_RegSel),
        .OutA(AOut), 
        .OutB(BOut), 
        .clk(Clock)
    );
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Abdullah Jafar Mansour Shamout 150200919
//Muhammed Yusuf Mermer 150220762
//////////////////////////////////////////////////////////////////////////////////


module Tristate_buffer(I,E,O);
    input wire [7:0] I;
    input wire E;
    output wire [7:0] O;
    assign O = E ? I : 8'bZ;
endmodule

module Bus_8bit(D1,D2,S,O);
    input wire [7:0] D1;
    input wire [7:0] D2;
    input wire S;
    output wire [7:0] O;
    Tristate_buffer buf1(D1,~S,O);
    Tristate_buffer buf2(D2,S,O);
endmodule

module Bus_8bit_with_2_outs(D1,D2,S,O1,O2);
    input wire [7:0] D1;
    input wire [7:0] D2;
    input wire S;
    output wire [7:0] O1;
    output wire [7:0] O2;

    Tristate_buffer buf1(D1,~S,O1);
    Tristate_buffer buf2(D2,S,O2);

endmodule


module part2_main(input [7:0] D1,input [7:0] D2, input S, output[7:0] O1, output[7:0] O2);
    wire[7:0] inter;
    Bus_8bit bus1(D1,D2, S, inter);
    Bus_8bit_with_2_outs bus2(inter, inter, S, O1,O2);
endmodule


module Memory_8bit(clk,I,select,read,write,reset,O);
    input wire [7:0] I;
    input wire select,clk,read,write,reset;
    output reg [7:0] O;
    reg [7:0] storage;
    
    always @(posedge clk) begin
        if(select && write) begin
            storage <= I;
        end
    end
    
    always @(negedge reset) begin
            storage <= 8'd0;
    end
    
    always @(*)begin
        if(select && read) begin
            O <= storage;
        end
        else begin
            O <= 8'bZ;
        end
    end
endmodule

module Memory_8byte(clk,I,address,chipselect,read,write,reset,O);
    input wire [7:0] I;
    input wire clk,read,write,reset;
    input wire chipselect;
    input wire [2:0] address;
    output wire [7:0] O;
    wire [7:0] ATS; //Address table selection
        generate
            for (genvar i = 0; i < 8; i = i + 1) begin
                assign ATS[i] = (i == address) ? 1'b1 : 1'b0;
                Memory_8bit N(
                    .clk(clk),
                    .I(I),
                    .select(ATS[i] & chipselect),
                    .read(read),
                    .write(write),
                    .reset(reset),
                    .O(O)
                );
            end
        endgenerate
endmodule

module Memory_32byte(input clk, input[7:0] I, input [4:0] address,input read,
input write,input reset ,output [7:0] O);

wire S0,S1,S2,S3;
and(S0,~address[4], ~address[3]);
and(S1,~address[4] , address[3]);
and(S2,address[4] , ~address[3]);
and(S3,address[4] , address[3]);

Memory_8byte mem1(clk,I,address[2:0], S0,read,write,reset,O );
Memory_8byte mem2(clk,I,address[2:0], S1,read,write,reset,O );
Memory_8byte mem3(clk,I,address[2:0], S2,read,write,reset,O );
Memory_8byte mem4(clk,I,address[2:0], S3,read,write,reset,O );

endmodule


module Memory_128byte(input clk,input [31:0] I,input[4:0] address, input reset, input read ,input write,  output[31:0] O);
    Memory_32byte mem0(clk, I[7:0]  , address,read, write, reset , O[7:0]  );
    Memory_32byte mem1(clk, I[15:8] , address,read, write, reset , O[15:8] );
    Memory_32byte mem2(clk, I[23:16], address,read, write, reset , O[23:16]);
    Memory_32byte mem3(clk, I[31:24], address,read, write, reset , O[31:24]);

endmodule
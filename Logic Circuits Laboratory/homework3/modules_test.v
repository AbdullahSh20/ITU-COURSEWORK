`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Abdullah Jafar Mansour Shamout 150200919
//Muhammed Yusuf Mermer 150220762
//////////////////////////////////////////////////////////////////////////////////


module Tristate_buffer_test();
reg [7:0]I;
reg E;
wire [7:0]O;

Tristate_buffer uut(I,E,O);

initial begin
    I=8'd14;     E=0;    #200;   
    I=8'd5;      E=1;    #200;   
    I=8'd17;     E=1;    #200;    
    I=8'd5;      E=0;    #200;
    I=8'd25;     E=1;    #200;
end

endmodule

module Bus_8bit_test();
    reg [7:0] D1; reg [7:0] D2; reg S; wire[7:0] O; 

    Bus_8bit uut(D1, D2, S, O);

    initial begin
        D1=8'b10100111; D2= 8'b01100010; S=0; #50;
        D1=8'b00100101; D2= 8'b11101000; #50;
        $finish;
    end
    always #5 S=~S;


endmodule

module part2_main_test();

reg [7:0] D1; reg [7:0] D2; reg S; wire[7:0] O1; wire[7:0] O2;


part2_main uut(D1, D2, S, O1, O2);

initial begin
    D1=8'b10100111; D2= 8'b01100010; S=0; #50;
    D1=8'b00100101; D2= 8'b11101000; #50;
    $finish;
end
always #5 S=~S;

endmodule

module Memory_8bit_test();
reg [7:0]I;
reg clk;
reg select;
reg read;
reg write;
reg reset;
wire [7:0]O;

Memory_8bit uut(clk,I,select,read,write,reset,O);

    initial begin
        clk=0; 
        forever #20 clk = ~clk;    
    end

initial begin
    I=8'd14;     select=0;  read=0;     write=1;    reset=1;    #100; //reset is active negedge     
    I=8'd5;      select=0;  read=0;     write=1;    reset=0;    #100; //reset is active negedge   
    I=8'd5;      select=1;  read=1;     write=1;    reset=1;    #100; //reset is active negedge
    I=8'd17;     select=1;  read=1;     write=0;    reset=1;    #100; //reset is active negedge  
    I=8'd25;     select=1;  read=0;     write=1;    reset=1;    #100; //reset is active negedge
    I=8'd14;     select=0;  read=0;     write=0;    reset=0;    #100; //reset is active negedge   
    I=8'd5;      select=1;  read=1;     write=0;    reset=0;    #100; //reset is active negedge   
    I=8'd17;     select=1;  read=1;     write=1;    reset=1;    #100; //reset is active negedge   
    I=8'd5;      select=1;  read=1;     write=1;    reset=1;    #100; //reset is active negedge
    I=8'd25;     select=1;  read=0;     write=0;    reset=0;    #100; //reset is active negedge
end

endmodule

module Memory_8byte_test();
reg [7:0]I;
reg clk;
reg [2:0]address;
reg chipselect;
reg read;
reg write;
reg reset;
wire [7:0]O;

Memory_8byte uut(clk,I,address,chipselect,read,write,reset,O);
    initial begin
        clk=0; 
        forever #20 clk = ~clk;    
    end

initial begin
    I=8'd15;    address=3'd0;    chipselect=1;    read=1;     write=0;    reset=1;    #100;
    I=8'd15;    address=3'd0;    chipselect=1;    read=1;     write=0;    reset=0;    #100; //reset all lines

    I=8'd25;    address=3'd3;    chipselect=1;    read=1;     write=1;    reset=1;    #100; //writing to address 3 <= 25 and reading from address 3

    I=8'd15;    address=3'd2;    chipselect=1;    read=0;     write=1;    reset=1;    #100; //writing to address 2 <= 15 and not reading anything "High impedence"

    I=8'd15;    address=3'd4;    chipselect=1;    read=1;     write=0;    reset=1;    #100; //reading the from address 4

    I=8'd18;    address=3'd5;    chipselect=1;    read=0;     write=1;    reset=1;    #100; //writing to address 5 <= 18 and not reading anything "High impedence"
    I=8'd18;    address=3'd6;    chipselect=1;    read=1;     write=0;    reset=1;    #100; //reading from address 6
    I=8'd18;    address=3'd5;    chipselect=1;    read=1;     write=0;    reset=1;    #100; //reading from address 5  
    I=8'd18;    address=3'd3;    chipselect=1;    read=1;     write=0;    reset=1;    #100; //reading from address 3   
end

endmodule


module Memory_32byte_test();


    reg clock; reg[7:0] I; reg [4:0] address; reg read;
    reg write; reg reset; wire [7:0] O;

    Memory_32byte uut( clock, I,address, read,write,reset,O);

    initial begin
    clock=0;  read=0;  write=0;
    reset=1;#1; reset=0; #20;//Reset all lines
    I=8'd25; address=5'd30; write=1;  #15;//Write 25 to Address 30
    I=8'd15; address=5'd20;  #15;  //Write 15 to Address 20
    write=0; address=5'd12; read=1; #15; //Read Address 12
    write=1; read=0; I=8'd18; address=5'd10;  #15; //Write 18 to Address 10
    write=0; read=1; address=5'd15;  #15; //Read Address 15
    address=5'd30;  #15; //Read Address 30
    address=5'd10; #15; //Read Address 10
    $finish;
    end
    always #1 clock=~clock;

endmodule


module Memory_128byte_test ();
    reg clock; 
    reg [31:0] I;
    reg[4:0] address; reg reset; reg read ; reg write;  wire[31:0] O;
    Memory_128byte uut(clock, I, address, reset, read ,  write, O);

    initial begin
    clock=0;  read=0;  write=0;
    reset=1;#1; reset=0; #20;//Reset all lines
    I=32'h74FF45FF; address=5'd30; write=1;  #15;//Write 25 to Address 30
    I=32'h2FAB45EF; address=5'd20;  #15;  //Write 15 to Address 20
    write=0; address=5'd12; read=1; #15; //Read Address 12
    write=1; read=0; I=32'h65FBF5EC; address=5'd10;  #15; //Write 18 to Address 10
    write=0; read=1; address=5'd15;  #15; //Read Address 15
    address=5'd30;  #15; //Read Address 30
    address=5'd10; #15; //Read Address 10
    $finish;
    end

    always #1 clock=~clock;
endmodule
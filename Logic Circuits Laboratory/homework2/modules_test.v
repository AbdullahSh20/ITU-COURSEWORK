`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Abdullah Jafar Mansour Shamout 150200919
//Muhammed Yusuf Mermer 150220762
//////////////////////////////////////////////////////////////////////////////////

module SR_latch_test();
    reg set;
    reg reset;
    
    wire Q, Qnot;
    
    SR_latch uut(set,reset,Q,Qnot);
    
    initial begin
        set=1; reset=1; #200;
        set=0; reset=0; #200;
        set=1; reset=0; #200;
        set=0; reset=1; #200;
        set=1; reset=1; #200;
    end
endmodule

module enabled_SR_latch_test();
    reg enabled,set,reset;
    wire Q,Qnot;
    
    enabled_SR_latch uut(enabled,set,reset,Q,Qnot);
    initial begin
        enabled= 0; set=0; reset=0; #150;
        enabled= 1; set=0; reset=0; #150;
        enabled= 1; set=0; reset=1; #150;
        enabled= 1; set=1; reset=0; #150;
        enabled= 1; set=0; reset=0; #150;
        enabled= 1; set=1; reset=1; #150;
    end   
endmodule

module enabled_D_latch_test();
    reg enabled, D;
    wire Q, Qnot;
    
    enabled_D_latch uut(enabled,D,Q,Qnot);
    initial begin
        enabled=0; D=0; #200;
        enabled=1; D=1; #200;
        enabled=0; D=1; #200;
        enabled=1; D=1; #200;
        enabled=1; D=0; #200;
    end 
endmodule

module D_flip_flop_test();
    reg clk, D;
    wire Q, Qnot;
    
    D_flip_flop uut(clk,D,Q,Qnot);
    initial begin
        clk=0; 
        forever #20 clk = ~clk;    
    end
    initial begin
        D=0; #100;
        D=1; #100;
        D=1; #100;
        D=0; #100;
        D=1; #100;
        D=0; #100;
        D=0; #100;
        D=1; #100;
        D=0; #100;
        D=1; #100;
    end
endmodule

module JK_flip_flop_test();
    reg J,K,clk;
    wire Q,Qnot;
    JK_flip_flop uut(clk,J,K,Q,Qnot);
    initial begin
        clk=0; 
        forever #20 clk = ~clk;   
    end
    initial begin
        J=0; K=0; #125;
        J=0; K=1; #125;
        J=1; K=0; #125;
        J=1; K=1; #125;
        J=1; K=0; #125;
        J=1; K=1; #125;
        J=0; K=0; #125;
        J=0; K=1; #125;
    end
endmodule

module asyncUpCounter_test();
reg clock;
reg[3:0]J;
reg[3:0] K;
wire[3:0] out;
asyncUpCounter uut(clock,J,K, out);
initial begin //30.000ns all jk flip-flops activated
clock=0; #1;
clock=1; #1;
clock=0; #1;
clock=1; #1;
clock=0; #1;
clock=1; #1;
clock=0; #1;
clock=1; #1;
clock=0; #1;
clock=1; #1;
clock=0; #1;
clock=1; #1;
clock=0; #1;
clock=1; #1;
clock=0; #1;
clock=1; #1;
clock=0; #1;
clock=1; #1;
clock=0; #1;
clock=1; #1;
clock=0; #1;
clock=1; #1;
clock=0; #1;
clock=1; #1;
clock=0; #1;
clock=1; #1;
clock=0; #1;
clock=1; #1;






clock=0; #22;
clock=1; #50;
clock=0; #50;
clock=1; #50;
clock=0; #50;
clock=1; #50;
clock=0; #50;
clock=1; #50;
clock=0; #50;
clock=1; #50;

clock=0; #50;
clock=1; #50;
clock=0; #50;
clock=1; #50;
clock=0; #50;
clock=1; #50;
clock=0; #50;
clock=1; #50;
clock=0; #50;
clock=1; #50;

clock=0; #50;
clock=1; #50;
clock=0; #50;
clock=1; #50;
clock=0; #50;
clock=1; #50;
clock=0; #50;
clock=1; #50;
clock=0; #50;
clock=1; #50;

clock=0; #50;
clock=1; #50;
clock=0; #50;
clock=1; #50;
clock=0; #50;
clock=1; #50;
clock=0; #50;
clock=1; #50;
clock=0; #50;
clock=1; #50;
end


initial begin
J[3]=0; K[3]=1; #5;
J[3]=1; K[3]=0; #5;
J[3]=0; K[3]=1; #5;
J[3]=1; K[3]=0; #5;
J[3]=0; K[3]=1; #5;
J[3]=1; K[3]=0; #5;


J[3]=1; K[3]=1;

end

initial begin
J[2]=0; K[2]=0; #4;
J[2]=0; K[2]=0; #4;
J[2]=0; K[2]=1; #4;
J[2]=1; K[2]=0; #4;
J[2]=0; K[2]=1; #4;
J[2]=1; K[2]=0; #4;
J[2]=0; K[2]=1; #4;

J[2]=1; K[2]=1;


end


initial begin
J[1]=0; K[1]=1; #3;
J[1]=1; K[1]=0; #3;
J[1]=0; K[1]=1; #3;
J[1]=1; K[1]=0; #3;
J[1]=0; K[1]=1; #3;
J[1]=1; K[1]=0; #3;
J[1]=0; K[1]=1; #3;
J[1]=1; K[1]=0; #3;
J[1]=0; K[1]=1; #3;


J[1]=1; K[1]=1;


end


initial begin
J[0]=0; K[0]=1; #2;
J[0]=1; K[0]=0; #2;
J[0]=0; K[0]=1; #2;
J[0]=1; K[0]=0; #2;
J[0]=0; K[0]=1; #2;
J[0]=1; K[0]=0; #2;
J[0]=0; K[0]=1; #2;
J[0]=1; K[0]=0; #2;
J[0]=0; K[0]=1; #2;
J[0]=1; K[0]=0; #2;
J[0]=0; K[0]=1; #2;
J[0]=1; K[0]=0; #2;
J[0]=0; K[0]=1; #2;
J[0]=1; K[0]=0; #2;
J[0]=0; K[0]=1; #2;

J[0]=1; K[0]=1;

end

endmodule


module syncUpCounter_test();
reg clock;
reg[3:0] J;
reg[3:0] K;
wire[3:0] out;
syncUpCounter uut(clock,J,K, out);

initial begin
clock=0;
clock=~clock; #2;
clock=~clock; #2;
clock=~clock; #2;
clock=~clock; #2;


clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;


clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
clock=~clock; #25;
end

initial begin
J=4'b0000; K=4'b1111; #8;
K=4'b0001; J=4'b0001;
end


endmodule


module pulse_generator_test_1_2_freq();

    reg[15:0] in;
    reg clock;
    reg load_flag;
    wire o;

    pulse_generator uut(in, clock, load_flag, o);

    initial begin
        in=16'b1010101010101010; //difference 
        clock =0;
        load_flag =1; #10; load_flag=0;

    end

    always #5 clock = ~clock;

endmodule


module pulse_generator_test_1_4_freq();

    reg[15:0] in;
    reg clock;
    reg load_flag;
    wire o;

    pulse_generator uut(in, clock, load_flag, o);

    initial begin
        in=16'b1100110011001100; //difference 
        clock =0;
        load_flag =1; #10; load_flag=0;
    end

    always #5 clock = ~clock;
    
endmodule

module pulse_generator_test_1_8_freq();

    reg[15:0] in;
    reg clock;
    reg load_flag;
    wire o;

    pulse_generator uut(in, clock, load_flag, o);

    initial begin
        in=16'b1111000011110000; //difference 
        clock =0;
        load_flag =1; #10; load_flag=0;
    end

    always #5 clock = ~clock;
    
endmodule

module pulse_generator_test_1_7_gap();

    reg[15:0] in;
    reg clock;
    reg load_flag;
    wire o;

    pulse_generator uut(in, clock, load_flag, o);

    initial begin
        in=16'b0000000100000001; //difference 
        clock =0;
        load_flag =1; #10; load_flag=0;
    end

    always #5 clock = ~clock;
    
endmodule


module pulse_generator_test_3_13_gap();

    reg[15:0] in;
    reg clock;
    reg load_flag;
    wire o;

    pulse_generator uut(in, clock, load_flag, o);

    initial begin
        in=16'b1110000000000000; //difference 
        clock =0;
        load_flag =1; #10; load_flag=0;
    end

    always #5 clock = ~clock;
    
endmodule

module pulse_generator_test_11_5_gap();

    reg[15:0] in;
    reg clock;
    reg load_flag;
    wire o;

    pulse_generator uut(in, clock, load_flag, o);

    initial begin
        in=16'b1111111111100000; //difference 
        clock =0;
        load_flag =1; #10; load_flag=0;
    end

    always #5 clock = ~clock;
    //end
endmodule
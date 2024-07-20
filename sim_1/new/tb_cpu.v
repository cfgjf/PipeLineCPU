`timescale 1ns / 1ps

module tb_cpu();

    reg reset, clk;
    wire [11 : 0] digits;

    PipeLineCPU TEST(
        .clk(clk),
        .reset(reset),
        .digi(digits)
    );

    initial begin
        reset   = 1;
		clk     = 1;
		#1000 reset = 0;
    end

    always #50 clk = ~clk;


endmodule

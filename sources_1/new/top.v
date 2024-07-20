`timescale 1ns / 1ps

module top(
    input sys_clk,
    input resetCPU,
    input resetPLL,
    output [11 : 0] digits
);

    wire required_clk;
    clk_wiz_0 clk_wiz_INST(
        .clk_out1(required_clk),
        .reset(resetPLL),
        .locked(),
        .clk_in1(sys_clk)
    );

    PipeLineCPU myCPU(
        .clk(required_clk),
        .reset(resetCPU),
        .digi(digits)
    );

endmodule

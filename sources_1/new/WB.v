module WB(
    input clk,
    input [31 : 0] wb_MemData_in,
    input [31 : 0] wb_ALUOut_in,
    input [31 : 0] wb_pc_plus_4_in,

    // 控制信号输入
    input [1 : 0] wb_MemToReg_in,

    // 数据输出
    output [31 : 0] wb_RegWriteData
);

    assign wb_RegWriteData = (wb_MemToReg_in == 2'b00) ? wb_ALUOut_in : 
        (wb_MemToReg_in == 2'b01) ? wb_MemData_in : wb_pc_plus_4_in;

endmodule
module MEM(
    input clk,
    input reset,
    input [31 : 0] mem_ALUOut_in,
    input [31 : 0] mem_DataBus2_in,
    input [4 : 0] mem_RegWriteAddr_in,
    input [31 : 0] mem_pc_plus_4_in,

    // 控制信号输入
    input mem_MemWr_in,
    input mem_MemRead_in,
    input [1 : 0] mem_MemToReg_in,
    input mem_RegWrite_in,

    // 级间寄存器输出
    output reg [1 : 0] mem_wb_MemToReg_out,
    output reg mem_wb_RegWrite_out, // 直接输出至RegFile

    output reg [31 : 0] mem_wb_MemData_out,
    output reg [31 : 0] mem_wb_ALUOut_out,
    output reg [4 : 0] mem_wb_RegWriteAddr_out, // 直接输出至RegFile
    output reg [31 : 0] mem_wb_pc_plus_4_out,

    // 输出数码管控制信号
    output [11 : 0] digi
);

    // 级内引线/reg
    wire [31 : 0] MemRead1;

    // 数据存储器
    DataMemory DataMem_INST(
        .reset(reset),
        .clk(clk),
        .MemRead(mem_MemRead_in),
        .MemWrite(mem_MemWr_in),
        .Address1(mem_ALUOut_in),
        .Write_data(mem_DataBus2_in),
        .Read_data1(MemRead1),
        .leds(digi)
    );

    // 级间寄存器输出
    always @(posedge clk) begin
        mem_wb_MemToReg_out <= mem_MemToReg_in;
        mem_wb_RegWrite_out <= mem_RegWrite_in;

        mem_wb_MemData_out <= MemRead1;
        mem_wb_ALUOut_out <= mem_ALUOut_in;
        mem_wb_RegWriteAddr_out <= mem_RegWriteAddr_in;
        mem_wb_pc_plus_4_out <= mem_pc_plus_4_in;
    end

endmodule
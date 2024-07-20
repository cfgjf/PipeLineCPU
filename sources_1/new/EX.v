module EX(
    input clk,
    input [31 : 0] ex_DataBus1_in,
    input [31 : 0] ex_DataBus2_in,
    input [31 : 0] ex_shamt_in,
    input [31 : 0] ex_mem_ALUOut_in, // 数据旁路
    input [31 : 0] mem_wb_RegWriteData_in, // 数据旁路
    input [31 : 0] ex_Imm_in,
    input [1 : 0] forwardA, // 数据旁路信号
    input [1 : 0] forwardB, // 数据旁路信号
    input [31 : 0] ex_pc_plus_4_in,
    input [4 : 0] ex_Rt_in,
    input [4 : 0] ex_Rd_in,
    // 控制信号输入
    input [1 : 0] regOption, // 决定级间寄存器更新
    input ex_Branch_in,
    input ex_ALUSrc1_in,
    input ex_ALUSrc2_in,
    input [1 : 0] ex_RegDst_in,
    input ex_MemWr_in,
    input ex_MemRead_in,
    input [1 : 0] ex_MemToReg_in,
    input ex_RegWrite_in,
    input [4 : 0] ex_ALUCtl_in,
    input ex_Sign_in,

    // 级间寄存器自身输入
    input ex_mem_MemWr_out_in,
    input ex_mem_MemRead_out_in,
    input [1 : 0] ex_mem_MemToReg_out_in,
    input ex_mem_RegWrite_out_in,

    // 分支指令相关，需要此周期内送至PC
    output ex_mem_activeBranch_out,
    output [31 : 0] Branch_addr,

    // 级间寄存器输出
    output reg ex_mem_MemWr_out,
    output reg ex_mem_MemRead_out,
    output reg [1 : 0] ex_mem_MemToReg_out,
    output reg ex_mem_RegWrite_out,

    output reg [31 : 0] ex_mem_pc_plus_4_out,
    output reg [31 : 0] ex_mem_ALUOut_out,
    output reg [31 : 0] ex_mem_DataBus2_out,
    output reg [4 : 0] ex_mem_RegWriteAddr_out
);

    // 级内使用引线/reg
    wire [31 : 0] forwardAOut, forwardBOut;
    wire [31 : 0] ALUIn1, ALUIn2, ALUOut;
    wire [31 : 0] RegWriteAddr;
    wire Zero;

    assign forwardAOut = (forwardA == 2'b00) ? ex_DataBus1_in :
        (forwardA == 2'b01) ? mem_wb_RegWriteData_in : ex_mem_ALUOut_in;
    assign forwardBOut = (forwardB == 2'b00) ? ex_DataBus2_in :
        (forwardB == 2'b01) ? mem_wb_RegWriteData_in : ex_mem_ALUOut_in;
    assign ALUIn1 = ex_ALUSrc1_in ? ex_shamt_in : forwardAOut;
    assign ALUIn2 = ex_ALUSrc2_in ? ex_Imm_in : forwardBOut;

    assign RegWriteAddr = (ex_RegDst_in == 2'b00) ? ex_Rt_in :
        (ex_RegDst_in == 2'b01) ? ex_Rd_in : 5'b11111;

    // 分支控制单元
    assign ex_mem_activeBranch_out = Zero & ex_Branch_in;
    assign Branch_addr = ex_pc_plus_4_in + {ex_Imm_in[29 : 0], 2'b00};

    // ALU单元
    ALU ALU_INST(
        .in1(ALUIn1),
        .in2(ALUIn2),
        .ALUCtl(ex_ALUCtl_in),
        .Sign(ex_Sign_in),
        .out(ALUOut),
        .zero(Zero)
    );

    // 级间寄存器输出
    always @(posedge clk) begin
        case(regOption)
            2'b00: begin
                ex_mem_MemWr_out <= ex_MemWr_in;
                ex_mem_MemRead_out <= ex_MemRead_in;
                ex_mem_MemToReg_out <= ex_MemToReg_in;
                ex_mem_RegWrite_out <= ex_RegWrite_in;
            end
            2'b01: begin
                ex_mem_MemWr_out <= 1'b0;
                ex_mem_MemRead_out <= 1'b0;
                ex_mem_MemToReg_out <= 2'b00;
                ex_mem_RegWrite_out <= 1'b0;
            end
            2'b10: begin
                ex_mem_MemWr_out <= ex_mem_MemWr_out_in;
                ex_mem_MemRead_out <= ex_mem_MemRead_out_in;
                ex_mem_MemToReg_out <= ex_mem_MemToReg_out_in;
                ex_mem_RegWrite_out <= ex_mem_RegWrite_out_in;
            end
        endcase
    end

    always @(posedge clk) begin
        ex_mem_pc_plus_4_out <= ex_pc_plus_4_in;
        ex_mem_ALUOut_out <= ALUOut;
        ex_mem_DataBus2_out <= forwardBOut; // sw forward
        ex_mem_RegWriteAddr_out <= RegWriteAddr;
    end


endmodule
module ID(
    input clk,
    input reset,
    input [31 : 0] id_inst_in,
    input [31 : 0] id_pc_plus_4_in,
    input regWrite, // WB带来的控制信号
    input [4 : 0] regWriteAddr, // WB带来的写入地址
    input [31 : 0] regWriteData, // WB带来的写入数据
    input [1 : 0] regOption, // 决定级间寄存器更新
    // 级间寄存器自身输入
    input id_ex_Branch_out_in,
    input id_ex_ALUSrc1_out_in,
    input id_ex_ALUSrc2_out_in,
    input [4 : 0] id_ex_ALUCtl_out_in,
    inout id_ex_Sign_out_in,
    input [1 : 0] id_ex_RegDst_out_in,
    input id_ex_MemWr_out_in,
    input id_ex_MemRead_out_in,
    input [1 : 0] id_ex_MemToReg_out_in,
    input id_ex_RegWrite_out_in,

    // PC更新相关，需要在此周期内送到PC
    output [1 : 0] id_ex_PCSrc1_out,
    output [31 : 0] Jump_addr,

    // 级间寄存器输出
    output reg id_ex_Branch_out,
    output reg id_ex_ALUSrc1_out,
    output reg id_ex_ALUSrc2_out,
    output reg [4 : 0] id_ex_ALUCtl_out,
    output reg id_ex_Sign_out,
    output reg [1 : 0] id_ex_RegDst_out,
    output reg id_ex_MemWr_out,
    output reg id_ex_MemRead_out,
    output reg [1 : 0] id_ex_MemToReg_out,
    output reg id_ex_RegWrite_out,

    output reg [31 : 0] id_ex_pc_plus_4_out,
    output reg [31 : 0] id_ex_DataBus1_out,
    output reg [31 : 0] id_ex_DataBus2_out,
    output reg [31 : 0] id_ex_ExtImm_out,
    output reg [4 : 0] id_ex_Rs_out,
    output reg [4 : 0] id_ex_Rt_out,
    output reg [4 : 0] id_ex_Rd_out,
    output reg [31 : 0] id_ex_shamt_out
);
    // 级内使用信号，reg
    wire ExtOp, LuOp;
    wire [3 : 0] ALUOp;
    // 级间寄存器引线
    wire Branch;
    wire ALUSrc1;
    wire ALUSrc2;
    wire [4 : 0] ALUCtl;
    wire Sign;
    wire [1 : 0] RegDst;
    wire MemWr;
    wire MemRead;
    wire [1 : 0] MemToReg;
    wire RegWrite;

    wire [31 : 0] DataBus1;
    wire [31 : 0] DataBus2;
    wire [31 : 0] ExtImm, FinalImm;

    // 连接控制单元
    Control CU_INST(
        .OpCode(id_inst_in[31 : 26]),
        .Funct(id_inst_in[5 : 0]),
        .PCSrc(id_ex_PCSrc1_out),
        .Branch(Branch),
        .RegWrite(RegWrite),
        .RegDst(RegDst),
        .MemRead(MemRead),
        .MemWrite(MemWr),
        .MemtoReg(MemToReg),
        .ALUSrc1(ALUSrc1),
        .ALUSrc2(ALUSrc2),
        .ExtOp(ExtOp),
        .LuOp(LuOp),
        .ALUOp(ALUOp)
    );

    ALUControl ALUCU_INST(
        .ALUOp(ALUOp),
        .Funct(id_inst_in[5 : 0]),
        .ALUCtl(ALUCtl),
        .Sign(Sign)
    );

    // 连接寄存器堆
    RegisterFile RF_INST(
        .reset(reset),
        .clk(clk),
        .RegWrite(regWrite),
        .Read_register1(id_inst_in[25 : 21]),
        .Read_register2(id_inst_in[20 : 16]),
        .Write_register(regWriteAddr),
        .Write_data(regWriteData),
        .Read_data1(DataBus1),
        .Read_data2(DataBus2)
    );

    // 立即数拓展单元
    assign ExtImm = ExtOp ? {{16{id_inst_in[15]}}, id_inst_in[15 : 0]} : {16'h0000, id_inst_in[15 : 0]};
    assign FinalImm = LuOp ? {id_inst_in[15 : 0], 16'h0000} : ExtImm;

    // Jump_addr计算单元，000010为j，000000为jr
    assign Jump_addr = (id_inst_in[31 : 26] == 6'b000010) ? {id_pc_plus_4_in[31 : 28], id_inst_in[25 : 0], 2'b00} : DataBus1;

    // 级间寄存器赋值
    always @(posedge clk) begin
        case(regOption)
            2'b00: begin
                id_ex_Branch_out <= Branch;
                id_ex_ALUSrc1_out <= ALUSrc1;
                id_ex_ALUSrc2_out <= ALUSrc2;
                id_ex_ALUCtl_out <= ALUCtl;
                id_ex_Sign_out <= Sign;
                id_ex_RegDst_out <= RegDst;
                id_ex_MemWr_out <= MemWr;
                id_ex_MemRead_out <= MemRead;
                id_ex_MemToReg_out <= MemToReg;
                id_ex_RegWrite_out <= RegWrite;
            end
            2'b01: begin
                id_ex_Branch_out <= 1'b0;
                id_ex_ALUSrc1_out <= 1'b0;
                id_ex_ALUSrc2_out <= 1'b0;
                id_ex_ALUCtl_out <= 5'b00000;
                id_ex_Sign_out <= 1'b0;
                id_ex_RegDst_out <= 2'b00;
                id_ex_MemWr_out <= 1'b0;
                id_ex_MemRead_out <= 1'b0;
                id_ex_MemToReg_out <= 2'b00;
                id_ex_RegWrite_out <= 1'b0;
            end
            2'b10: begin
                id_ex_Branch_out <= id_ex_Branch_out_in;
                id_ex_ALUSrc1_out <= id_ex_ALUSrc1_out_in;
                id_ex_ALUSrc2_out <= id_ex_ALUSrc2_out_in;
                id_ex_ALUCtl_out <= id_ex_ALUCtl_out_in;
                id_ex_Sign_out <= id_ex_Sign_out_in;
                id_ex_RegDst_out <= id_ex_RegDst_out_in;
                id_ex_MemWr_out <= id_ex_MemWr_out_in;
                id_ex_MemRead_out <= id_ex_MemRead_out_in;
                id_ex_MemToReg_out <= id_ex_MemToReg_out_in;
                id_ex_RegWrite_out <= id_ex_RegWrite_out_in;
            end
        endcase
    end
    
    always @(posedge clk) begin
        id_ex_pc_plus_4_out <= id_pc_plus_4_in;
        id_ex_DataBus1_out <= DataBus1;
        id_ex_DataBus2_out <= DataBus2;
        id_ex_ExtImm_out <= FinalImm;
        id_ex_Rs_out <= id_inst_in[25 : 21];
        id_ex_Rt_out <= id_inst_in[20 : 16];
        id_ex_Rd_out <= id_inst_in[15 : 11];
        id_ex_shamt_out <= {27'h00000, id_inst_in[10 : 6]};
    end


endmodule
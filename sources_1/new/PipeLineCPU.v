module PipeLineCPU(
    input clk,
    input reset,
    output [11 : 0] digi
);

    // region IF/ID
    wire [31 : 0] if_id_pc_plus_4;
    wire [31 : 0] if_id_inst;

    // end region

    // region ID/EX
    wire [1 : 0] id_ex_PCSrc1;
    wire [31 : 0] Jump_addr;

    wire id_ex_Branch;
    wire id_ex_ALUSrc1;
    wire id_ex_ALUSrc2;
    wire [4 : 0] id_ex_ALUCtl;
    wire id_ex_Sign;
    wire [1 : 0] id_ex_RegDst;
    wire id_ex_MemWr;
    wire id_ex_MemRead;
    wire [1 : 0] id_ex_MemToReg;
    wire id_ex_RegWrite;

    wire [31 : 0] id_ex_pc_plus_4;
    wire [31 : 0] id_ex_DataBus1;
    wire [31 : 0] id_ex_DataBus2;
    wire [31 : 0] id_ex_ExtImm;
    wire [4 : 0] id_ex_Rs;
    wire [4 : 0] id_ex_Rt;
    wire [4 : 0] id_ex_Rd;
    wire [31 : 0] id_ex_shamt;

    // end region

    // region EX/MEM
    wire ex_mem_activeBranch;
    wire [31 : 0] Branch_addr;

    wire ex_mem_MemWr;
    wire ex_mem_MemRead;
    wire [1 : 0] ex_mem_MemToReg;
    wire ex_mem_RegWrite;

    wire [31 : 0] ex_mem_pc_plus_4;
    wire [31 : 0] ex_mem_ALUOut;
    wire [31 : 0] ex_mem_DataBus2;
    wire [4 : 0] ex_mem_RegWriteAddr;

    // end region

    // region MEM/WB
    wire [1 : 0] mem_wb_MemToReg;
    wire mem_wb_RegWrite; // 直接输出至RegFile

    wire [31 : 0] mem_wb_MemData;
    wire [31 : 0] mem_wb_ALUOut;
    wire [4 : 0] mem_wb_RegWriteAddr; // 直接输出至RegFile
    wire [31 : 0] mem_wb_pc_plus_4;

    // end region

    // region WB output
    wire [31 : 0] wb_RegWriteData;

    // end region

    // region Forwarding Unit
    wire [1 : 0] forwardA;
    wire [1 : 0] forwardB;

    // end region

    // region Hazard Unit
    wire [1 : 0] if_id_regOption;
    wire [1 : 0] id_ex_regOption;
    wire [1 : 0] ex_mem_regOption;
    wire PCSrc2;

    // end region


    IF IF_INST(
        .clk(clk),
        .reset(reset),
        .PCSrc1(id_ex_PCSrc1),
        .PCSrc2(PCSrc2),
        .Jump_addr(Jump_addr),
        .Branch_addr(Branch_addr),
        .activeBranch(ex_mem_activeBranch),
        .regOption(if_id_regOption),

        .if_id_pc_plus_4_out_in(if_id_pc_plus_4),
        .if_id_inst_out_in(if_id_inst),

        .if_id_pc_plus_4_out(if_id_pc_plus_4),
        .if_id_inst_out(if_id_inst)
    );

    ID ID_INST(
        .clk(clk),
        .reset(reset),
        .id_inst_in(if_id_inst),
        .id_pc_plus_4_in(if_id_pc_plus_4),
        .regWrite(mem_wb_RegWrite),
        .regWriteAddr(mem_wb_RegWriteAddr),
        .regWriteData(wb_RegWriteData),
        .regOption(id_ex_regOption),

        .id_ex_Branch_out_in(id_ex_Branch),
        .id_ex_ALUSrc1_out_in(id_ex_ALUSrc1),
        .id_ex_ALUSrc2_out_in(id_ex_ALUSrc2),
        .id_ex_ALUCtl_out_in(id_ex_ALUCtl),
        .id_ex_Sign_out_in(id_ex_Sign),
        .id_ex_RegDst_out_in(id_ex_RegDst),
        .id_ex_MemWr_out_in(id_ex_MemWr),
        .id_ex_MemRead_out_in(id_ex_MemRead),
        .id_ex_MemToReg_out_in(id_ex_MemToReg),
        .id_ex_RegWrite_out_in(id_ex_RegWrite),

        .id_ex_PCSrc1_out(id_ex_PCSrc1),
        .Jump_addr(Jump_addr),

        .id_ex_Branch_out(id_ex_Branch),
        .id_ex_ALUSrc1_out(id_ex_ALUSrc1),
        .id_ex_ALUSrc2_out(id_ex_ALUSrc2),
        .id_ex_ALUCtl_out(id_ex_ALUCtl),
        .id_ex_Sign_out(id_ex_Sign),
        .id_ex_RegDst_out(id_ex_RegDst),
        .id_ex_MemWr_out(id_ex_MemWr),
        .id_ex_MemRead_out(id_ex_MemRead),
        .id_ex_MemToReg_out(id_ex_MemToReg),
        .id_ex_RegWrite_out(id_ex_RegWrite),

        .id_ex_pc_plus_4_out(id_ex_pc_plus_4),
        .id_ex_DataBus1_out(id_ex_DataBus1),
        .id_ex_DataBus2_out(id_ex_DataBus2),
        .id_ex_ExtImm_out(id_ex_ExtImm),
        .id_ex_Rs_out(id_ex_Rs),
        .id_ex_Rt_out(id_ex_Rt),
        .id_ex_Rd_out(id_ex_Rd),
        .id_ex_shamt_out(id_ex_shamt)
    );
    
    EX EX_INST(
        .clk(clk),
        .ex_DataBus1_in(id_ex_DataBus1),
        .ex_DataBus2_in(id_ex_DataBus2),
        .ex_shamt_in(id_ex_shamt),
        .ex_mem_ALUOut_in(ex_mem_ALUOut),
        .mem_wb_RegWriteData_in(wb_RegWriteData),
        .ex_Imm_in(id_ex_ExtImm),
        .forwardA(forwardA),
        .forwardB(forwardB),
        .ex_pc_plus_4_in(id_ex_pc_plus_4),
        .ex_Rt_in(id_ex_Rt),
        .ex_Rd_in(id_ex_Rd),

        .regOption(ex_mem_regOption),
        .ex_Branch_in(id_ex_Branch),
        .ex_ALUSrc1_in(id_ex_ALUSrc1),
        .ex_ALUSrc2_in(id_ex_ALUSrc2),
        .ex_RegDst_in(id_ex_RegDst),
        .ex_MemWr_in(id_ex_MemWr),
        .ex_MemRead_in(id_ex_MemRead),
        .ex_MemToReg_in(id_ex_MemToReg),
        .ex_RegWrite_in(id_ex_RegWrite),
        .ex_ALUCtl_in(id_ex_ALUCtl),
        .ex_Sign_in(id_ex_Sign),

        .ex_mem_MemWr_out_in(ex_mem_MemWr),
        .ex_mem_MemRead_out_in(ex_mem_MemRead),
        .ex_mem_MemToReg_out_in(ex_mem_MemToReg),
        .ex_mem_RegWrite_out_in(ex_mem_RegWrite),

        .ex_mem_activeBranch_out(ex_mem_activeBranch),
        .Branch_addr(Branch_addr),

        .ex_mem_MemWr_out(ex_mem_MemWr),
        .ex_mem_MemRead_out(ex_mem_MemRead),
        .ex_mem_MemToReg_out(ex_mem_MemToReg),
        .ex_mem_RegWrite_out(ex_mem_RegWrite),

        .ex_mem_pc_plus_4_out(ex_mem_pc_plus_4),
        .ex_mem_ALUOut_out(ex_mem_ALUOut),
        .ex_mem_DataBus2_out(ex_mem_DataBus2),
        .ex_mem_RegWriteAddr_out(ex_mem_RegWriteAddr)
    );

    MEM MEM_INST(
        .clk(clk),
        .reset(reset),
        .mem_ALUOut_in(ex_mem_ALUOut),
        .mem_DataBus2_in(ex_mem_DataBus2),
        .mem_RegWriteAddr_in(ex_mem_RegWriteAddr),
        .mem_pc_plus_4_in(ex_mem_pc_plus_4),

        .mem_MemWr_in(ex_mem_MemWr),
        .mem_MemRead_in(ex_mem_MemRead),
        .mem_MemToReg_in(ex_mem_MemToReg),
        .mem_RegWrite_in(ex_mem_RegWrite),

        .mem_wb_MemToReg_out(mem_wb_MemToReg),
        .mem_wb_RegWrite_out(mem_wb_RegWrite),

        .mem_wb_MemData_out(mem_wb_MemData),
        .mem_wb_ALUOut_out(mem_wb_ALUOut),
        .mem_wb_RegWriteAddr_out(mem_wb_RegWriteAddr),
        .mem_wb_pc_plus_4_out(mem_wb_pc_plus_4),

        .digi(digi)
    );

    WB WB_INST(
        .clk(clk),
        .wb_MemData_in(mem_wb_MemData),
        .wb_ALUOut_in(mem_wb_ALUOut),
        .wb_pc_plus_4_in(mem_wb_pc_plus_4),

        .wb_MemToReg_in(mem_wb_MemToReg),

        .wb_RegWriteData(wb_RegWriteData)
    );

    ForwardingUnit FWD_INST(
        .id_ex_Rs(id_ex_Rs),
        .id_ex_Rt(id_ex_Rt),

        .ex_mem_RegWrite(ex_mem_RegWrite),
        .ex_mem_RegWriteAddr(ex_mem_RegWriteAddr),

        .mem_wb_RegWrite(mem_wb_RegWrite),
        .mem_wb_RegWriteAddr(mem_wb_RegWriteAddr),

        .forwardA(forwardA),
        .forwardB(forwardB)
    );

    HazardUnit HZD_INST(
        .reset(reset),
        .id_ex_MemRead(id_ex_MemRead),
        .id_ex_Rt(id_ex_Rt),
        .if_id_Rs(if_id_inst[25 : 21]),
        .if_id_Rt(if_id_inst[20 : 16]),

        .ex_mem_activeBranch(ex_mem_activeBranch),

        .id_ex_PCSrc1(id_ex_PCSrc1),

        .if_id_regOption(if_id_regOption),
        .id_ex_regOption(id_ex_regOption),
        .ex_mem_regOption(ex_mem_regOption),
        .PCSrc2(PCSrc2)
    );


endmodule
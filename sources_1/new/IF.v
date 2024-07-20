module IF(
    input clk,
    input reset,
    input [1 : 0] PCSrc1, // ID带来，决定是普通、分支/跳转/31号寄存器
    input PCSrc2, // 0-正常更新， 1-PC保持
    input [31 : 0] Jump_addr, // 整合了31号寄存器值
    input [31 : 0] Branch_addr,
//  input [31 : 0] addr31, // 31号寄存器值
    input activeBranch, // 是否为有效跳转，MEM产生送入
    input [1 : 0] regOption, // 决定级间寄存器更新

    // 级间寄存器自身输入
    input [31 : 0] if_id_pc_plus_4_out_in,
    input [31 : 0] if_id_inst_out_in,

    output reg [31 : 0] if_id_pc_plus_4_out,
    output reg [31 : 0] if_id_inst_out
);

    wire [31 : 0] instruction;

    // 有关PC部分
    reg [31 : 0] pc;
    wire [31 : 0] pc_plus_4;
    wire [31 : 0] pc_next;
    assign pc_plus_4 = pc + 32'd4;
    assign pc_next = activeBranch ? Branch_addr : (
        PCSrc2 ? pc :
        (PCSrc1 == 2'b00) ? pc_plus_4 : Jump_addr
    );

    // 指令存储器
    InstructionMemory InstMem(
        .Address(pc),
        .Instruction(instruction)
    );

    always @(posedge clk) begin
        if (reset) begin
             pc <= 32'h0000_0000;
             if_id_inst_out <= 32'h0000_0000;
        end
        else begin pc <= pc_next;
        case(regOption)
            2'b00: begin
                if_id_pc_plus_4_out <= pc_plus_4;
                if_id_inst_out <= instruction;
            end
            2'b01: begin
                if_id_pc_plus_4_out <= 32'h0000_0000;
                if_id_inst_out <= 32'h0000_0000;
            end
            2'b10: begin
                if_id_pc_plus_4_out <= if_id_pc_plus_4_out_in;
                if_id_inst_out <= if_id_inst_out_in;
            end
        endcase
        end
    end


endmodule
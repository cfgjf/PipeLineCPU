module HazardUnit(
    input reset,
    // lw Hazard所需判断信号
    input id_ex_MemRead,
    input [4 : 0] id_ex_Rt,
    input [4 : 0] if_id_Rs, // 由if_id_inst读取
    input [4 : 0] if_id_Rt, // 由if_id_inst读取
    // 判断是否为分支
    input ex_mem_activeBranch,
    // 判断是否为J型指令
    input [1 : 0] id_ex_PCSrc1,

    // 输出控制信号，00为正常，01为清空，10为保持
    output reg [1 : 0] if_id_regOption,
    output reg [1 : 0] id_ex_regOption,
    output reg [1 : 0] ex_mem_regOption,
    // 0为照常、1为保持
    output reg PCSrc2
);

always @(*) begin
    if (reset) begin
        if_id_regOption = 2'b00;
        id_ex_regOption = 2'b00;
        ex_mem_regOption = 2'b00;
        PCSrc2 = 1'b0;
    end
    else begin
        if (ex_mem_activeBranch) begin
            if_id_regOption = 2'b01;
            id_ex_regOption = 2'b01;
            ex_mem_regOption = 2'b00;
            PCSrc2 = 1'b0;
        end
        else if (id_ex_PCSrc1[0] ^ id_ex_PCSrc1[1]) begin // 01 or 10
            if_id_regOption = 2'b01;
            id_ex_regOption = 2'b00;
            ex_mem_regOption = 2'b00;
            PCSrc2 = 1'b0;
        end
        else if (id_ex_MemRead &&
            (id_ex_Rt == if_id_Rs || id_ex_Rt == if_id_Rt)) begin
            if_id_regOption = 2'b10;
            id_ex_regOption = 2'b01;
            ex_mem_regOption = 2'b00;
            PCSrc2 = 1'b1;
        end
        else begin
            if_id_regOption = 2'b00;
            id_ex_regOption = 2'b00;
            ex_mem_regOption = 2'b00;
            PCSrc2 = 1'b0;
        end
    end
end

endmodule
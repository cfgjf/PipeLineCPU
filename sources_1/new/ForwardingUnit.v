module ForwardingUnit(
    input [4 : 0] id_ex_Rs,
    input [4 : 0] id_ex_Rt,

    input ex_mem_RegWrite,
    input [4 : 0] ex_mem_RegWriteAddr,

    input mem_wb_RegWrite,
    input [4 : 0] mem_wb_RegWriteAddr,

    output reg [1 : 0] forwardA,
    output reg [1 : 0] forwardB
);

always @(*) begin
    if (ex_mem_RegWrite && 
        ex_mem_RegWriteAddr != 5'b00000 &&
        ex_mem_RegWriteAddr == id_ex_Rs) forwardA = 2'b10;
    else if (mem_wb_RegWrite &&
        mem_wb_RegWriteAddr != 5'b00000 &&
        mem_wb_RegWriteAddr == id_ex_Rs) forwardA = 2'b01;
    else forwardA = 2'b00;

    if (ex_mem_RegWrite && 
        ex_mem_RegWriteAddr != 5'b00000 &&
        ex_mem_RegWriteAddr == id_ex_Rt) forwardB = 2'b10;
    else if (mem_wb_RegWrite &&
        mem_wb_RegWriteAddr != 5'b00000 &&
        mem_wb_RegWriteAddr == id_ex_Rt) forwardB = 2'b01;
    else forwardB = 2'b00;
end

endmodule
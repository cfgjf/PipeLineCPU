`timescale 1ns / 1ps

module Control(
	input  [6 -1:0] OpCode   ,
	input  [6 -1:0] Funct    ,
	output reg [2 -1:0] PCSrc    ,
	output reg Branch            ,
	output reg RegWrite          ,
	output reg [2 -1:0] RegDst   ,
	output reg MemRead           ,
	output reg MemWrite          ,
	output reg [2 -1:0] MemtoReg ,
	output reg ALUSrc1           ,
	output reg ALUSrc2           ,
	output reg ExtOp             ,
	output reg LuOp              ,
	output [4 -1:0] ALUOp
);
	


	always @(*) begin
	   if (OpCode == 6'd0) begin
	       case (Funct)
	           6'h20, 6'h21, 6'h22, 6'h23, 6'h24, 6'h25, 6'h26, 6'h27: begin
	               PCSrc = 2'b00; Branch = 0;
	               RegWrite = 1; RegDst = 2'b01;
	               MemRead = 0; MemWrite = 0; MemtoReg = 2'b00;
	               ALUSrc1 = 0; ALUSrc2 = 0;
	               ExtOp = 1; LuOp = 0;
	           end
	           6'h0, 6'h2, 6'h3: begin
	               PCSrc = 2'b00; Branch = 0;
                   RegWrite = 1; RegDst = 2'b01;
                   MemRead = 0; MemWrite = 0; MemtoReg = 2'b00;
                   ALUSrc1 = 1; ALUSrc2 = 0;
                   ExtOp = 1; LuOp = 0;
	           end
	           6'h2a, 6'h2b: begin
	               PCSrc = 2'b00; Branch = 0;
                   RegWrite = 1; RegDst = 2'b01;
                   MemRead = 0; MemWrite = 0; MemtoReg = 2'b00;
                   ALUSrc1 = 0; ALUSrc2 = 0;
                   ExtOp = 1; LuOp = 0;
	           end
	           6'h8: begin
	               PCSrc = 2'b10; Branch = 0;
                   RegWrite = 0; RegDst = 2'b01;
                   MemRead = 0; MemWrite = 0; MemtoReg = 2'b00;
                   ALUSrc1 = 0; ALUSrc2 = 0;
                   ExtOp = 1; LuOp = 0;
	           end endcase
	   end else begin
	       case(OpCode)
	           6'h23: begin
	               PCSrc = 2'b00; Branch = 0;
                   RegWrite = 1; RegDst = 2'b00;
                   MemRead = 1; MemWrite = 0; MemtoReg = 2'b01;
                   ALUSrc1 = 0; ALUSrc2 = 1;
                   ExtOp = 1; LuOp = 0;
	           end
	           6'h2b: begin
	               PCSrc = 2'b00; Branch = 0;
                   RegWrite = 0; RegDst = 2'b00;
                   MemRead = 0; MemWrite = 1; MemtoReg = 2'b01;
                   ALUSrc1 = 0; ALUSrc2 = 1;
                   ExtOp = 1; LuOp = 0;
	           end
	           6'h0f: begin
	               PCSrc = 2'b00; Branch = 0;
                   RegWrite = 1; RegDst = 2'b00;
                   MemRead = 0; MemWrite = 0; MemtoReg = 2'b00;
                   ALUSrc1 = 0; ALUSrc2 = 1;
                   ExtOp = 1; LuOp = 1;
	           end
	           6'h1c: begin
	               PCSrc = 2'b00; Branch = 0;
                   RegWrite = 1; RegDst = 2'b01;
                   MemRead = 0; MemWrite = 0; MemtoReg = 2'b00;
                   ALUSrc1 = 0; ALUSrc2 = 0;
                   ExtOp = 1; LuOp = 0;
	           end
	           6'h8, 6'h9: begin
	               PCSrc = 2'b00; Branch = 0;
                   RegWrite = 1; RegDst = 2'b00;
                   MemRead = 0; MemWrite = 0; MemtoReg = 2'b00;
                   ALUSrc1 = 0; ALUSrc2 = 1;
                   ExtOp = 1; LuOp = 0;	           
               end
               6'h0c: begin
                    PCSrc = 2'b00; Branch = 0;
                    RegWrite = 1; RegDst = 2'b00;
                    MemRead = 0; MemWrite = 0; MemtoReg = 2'b00;
                    ALUSrc1 = 0; ALUSrc2 = 1;
                    ExtOp = 0; LuOp = 0;
               end
               6'h0a, 6'h0b: begin
                    PCSrc = 2'b00; Branch = 0;
                    RegWrite = 1; RegDst = 2'b00;
                    MemRead = 0; MemWrite = 0; MemtoReg = 2'b00;
                    ALUSrc1 = 0; ALUSrc2 = 1;
                    ExtOp = 1; LuOp = 0;
               end
               6'h4: begin
                    PCSrc = 2'b00; Branch = 1;
                    RegWrite = 0; RegDst = 2'b00;
                    MemRead = 0; MemWrite = 0; MemtoReg = 2'b00;
                    ALUSrc1 = 0; ALUSrc2 = 0;
                    ExtOp = 0; LuOp = 0;
               end
               6'h2: begin
                    PCSrc = 2'b01; Branch = 0;
                    RegWrite = 0; RegDst = 2'b00;
                    MemRead = 0; MemWrite = 0; MemtoReg = 2'b00;
                    ALUSrc1 = 0; ALUSrc2 = 1;
                    ExtOp = 0; LuOp = 0;
               end
               6'h3: begin
                    PCSrc = 2'b01; Branch = 0;
                    RegWrite = 1; RegDst = 2'b10;
                    MemRead = 0; MemWrite = 0; MemtoReg = 2'b10;
                    ALUSrc1 = 0; ALUSrc2 = 1;
                    ExtOp = 0; LuOp = 0;
               end endcase
	   end
	end
	

	// set ALUOp
	assign ALUOp[2:0] = 
		(OpCode == 6'h00)? 3'b010: 
		(OpCode == 6'h04)? 3'b001: 
		(OpCode == 6'h0c)? 3'b100: 
		(OpCode == 6'h0a || OpCode == 6'h0b)? 3'b101: 
		(OpCode == 6'h1c && Funct == 6'h02)? 3'b110:
		3'b000; //mul
		
	assign ALUOp[3] = OpCode[0];

endmodule
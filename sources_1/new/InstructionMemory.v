module InstructionMemory( // Read Only Memory
	input      [32 -1:0] Address, 
	output reg [32 -1:0] Instruction
);
	
	always @(*)
		case (Address[9:2])

			8'd0:	Instruction <= 32'h8c040000;
			8'd1:	Instruction <= 32'h20100000;
			8'd2:	Instruction <= 32'h20050004;
			8'd3:	Instruction <= 32'h00042080;
			8'd4:	Instruction <= 32'h20840004;
			8'd5:	Instruction <= 32'h20030001;
			8'd6:	Instruction <= 32'h20a50004;
			8'd7:	Instruction <= 32'h10a40014;
			8'd8:	Instruction <= 32'h08100009;
			8'd9:	Instruction <= 32'h8ca80000;
			8'd10:	Instruction <= 32'h20aafffc;
			8'd11:	Instruction <= 32'h8d490000;
			8'd12:	Instruction <= 32'h22100001;
			8'd13:	Instruction <= 32'h0128582a;
			8'd14:	Instruction <= 32'h11630003;
			8'd15:	Instruction <= 32'h11400002;
			8'd16:	Instruction <= 32'h214afffc;
			8'd17:	Instruction <= 32'h0810000b;
			8'd18:	Instruction <= 32'h20abfffc;
			8'd19:	Instruction <= 32'h20ac0000;
			8'd20:	Instruction <= 32'h116a0005;
			8'd21:	Instruction <= 32'h8d6d0000;
			8'd22:	Instruction <= 32'h216bfffc;
			8'd23:	Instruction <= 32'had8d0000;
			8'd24:	Instruction <= 32'h218cfffc;
			8'd25:	Instruction <= 32'h08100014;
			8'd26:	Instruction <= 32'had880000;
			8'd27:	Instruction <= 32'h08100006;
			8'd28:	Instruction <= 32'hac100000;
			8'd29:	Instruction <= 32'h20850000;
			8'd30:	Instruction <= 32'h20040000;
			8'd31:	Instruction <= 32'h3c104000;
			8'd32:	Instruction <= 32'h22100010;
			8'd33:	Instruction <= 32'h20114000;
			8'd34:	Instruction <= 32'h20140080;
			8'd35:	Instruction <= 32'h2084fffc;
			8'd36:	Instruction <= 32'h20840004;
			8'd37:	Instruction <= 32'h1085002c;
			8'd38:	Instruction <= 32'h8c8c0000;
			8'd39:	Instruction <= 32'h20130000;
			8'd40:	Instruction <= 32'h3188000f;
			8'd41:	Instruction <= 32'h00084080;
			8'd42:	Instruction <= 32'h318900f0;
			8'd43:	Instruction <= 32'h00094882;
			8'd44:	Instruction <= 32'h318a0f00;
			8'd45:	Instruction <= 32'h000a5182;
			8'd46:	Instruction <= 32'h318bf000;
			8'd47:	Instruction <= 32'h000b5a82;
			8'd48:	Instruction <= 32'h01054020;
			8'd49:	Instruction <= 32'h8d080000;
			8'd50:	Instruction <= 32'h01254820;
			8'd51:	Instruction <= 32'h8d290000;
			8'd52:	Instruction <= 32'h01455020;
			8'd53:	Instruction <= 32'h8d4a0000;
			8'd54:	Instruction <= 32'h01655820;
			8'd55:	Instruction <= 32'h8d6b0000;
			8'd56:	Instruction <= 32'h21080100;
			8'd57:	Instruction <= 32'h21290200;
			8'd58:	Instruction <= 32'h214a0400;
			8'd59:	Instruction <= 32'h216b0800;
			8'd60:	Instruction <= 32'h22730001;
			8'd61:	Instruction <= 32'h1274ffe6;
			8'd62:	Instruction <= 32'h20120000;
			8'd63:	Instruction <= 32'hae080000;
			8'd64:	Instruction <= 32'h22520001;
			8'd65:	Instruction <= 32'h12510001;
			8'd66:	Instruction <= 32'h08100040;
			8'd67:	Instruction <= 32'h20120000;
			8'd68:	Instruction <= 32'hae090000;
			8'd69:	Instruction <= 32'h22520001;
			8'd70:	Instruction <= 32'h12510001;
			8'd71:	Instruction <= 32'h08100045;
			8'd72:	Instruction <= 32'h20120000;
			8'd73:	Instruction <= 32'hae0a0000;
			8'd74:	Instruction <= 32'h22520001;
			8'd75:	Instruction <= 32'h12510001;
			8'd76:	Instruction <= 32'h0810004a;
			8'd77:	Instruction <= 32'h20120000;
			8'd78:	Instruction <= 32'hae0b0000;
			8'd79:	Instruction <= 32'h22520001;
			8'd80:	Instruction <= 32'h1251ffeb;
			8'd81:	Instruction <= 32'h0810004f;
			8'd82:	Instruction <= 32'h20080000;
			8'd83:	Instruction <= 32'h20090471;
			8'd84:	Instruction <= 32'hae090000;
			8'd85:	Instruction <= 32'h21080001;
			8'd86:	Instruction <= 32'h11110001;
			8'd87:	Instruction <= 32'h08100055;
			8'd88:	Instruction <= 32'h20080000;
			8'd89:	Instruction <= 32'h20090206;
			8'd90:	Instruction <= 32'hae090000;
			8'd91:	Instruction <= 32'h21080001;
			8'd92:	Instruction <= 32'h11110001;
			8'd93:	Instruction <= 32'h0810005b;
			8'd94:	Instruction <= 32'h20080000;
			8'd95:	Instruction <= 32'h200901d4;
			8'd96:	Instruction <= 32'hae090000;
			8'd97:	Instruction <= 32'h21080001;
			8'd98:	Instruction <= 32'h1111ffef;
			8'd99:	Instruction <= 32'h08100061;
 
			// -------- Paste Binary Instruction Above
			
			default: Instruction <= 32'h00000000;
		endcase
		
endmodule

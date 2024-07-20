module DataMemory(
	input  reset    , 
	input  clk      ,  
	input  MemRead  ,
	input  MemWrite ,
	input  [32 -1:0] Address1   , // 流水线CPU用
	input  [32 -1:0] Write_data ,
	output [32 -1:0] Read_data1 , // 流水线CPU用
    output [11 : 0] leds   // 数码管控制信号
);
	
	// RAM size is 256 words, each word is 32 bits, valid address is 8 bits
	parameter RAM_SIZE      = 256;
	parameter RAM_SIZE_BIT  = 8;

	// RAM_data is an array of 256 32-bit registers
	reg [31:0] RAM_data [RAM_SIZE - 1: 0];
	// 数码管内存
	reg [11 : 0] digi;
	assign leds = digi;

	// read data from RAM_data as Read_data
	assign Read_data1 = MemRead? RAM_data[Address1[RAM_SIZE_BIT + 1:2]]: 32'h00000000;
	
	// write Write_data to RAM_data at clock posedge
	integer i;
	always @(posedge reset or posedge clk)begin
		if (reset) begin
			digi = 12'hf80;
			// -------- Paste Data Memory Configuration Below
			
			RAM_data[0] <= 32'h0000_0019; // 共25个数
			RAM_data[1] <= 32'h0000_0033;
			RAM_data[2] <= 32'h0000_0028;
			RAM_data[3] <= 32'h0000_0024;
			RAM_data[4] <= 32'h0000_001a;
			RAM_data[5] <= 32'h0000_0006;
			RAM_data[6] <= 32'h0000_0041;
			RAM_data[7] <= 32'h0000_1111;
			RAM_data[8] <= 32'h0000_2222;
			RAM_data[9] <= 32'h0000_22ff;
			RAM_data[10] <= 32'h0000_010c;
			RAM_data[11] <= 32'h0000_0936;
			RAM_data[12] <= 32'h0000_1025;
			RAM_data[13] <= 32'h0000_1888;
			RAM_data[14] <= 32'h0000_8848;
			RAM_data[15] <= 32'h0000_3333;
			RAM_data[16] <= 32'h0000_9876;
			RAM_data[17] <= 32'h0000_0500;
			RAM_data[18] <= 32'h0000_0829;
			RAM_data[19] <= 32'h0000_8888;
			RAM_data[20] <= 32'h0000_ffff;
			RAM_data[21] <= 32'h0000_6666;
			RAM_data[22] <= 32'h0000_0999;
			RAM_data[23] <= 32'h0000_2024;
			RAM_data[24] <= 32'h0000_2023;
			RAM_data[25] <= 32'h0000_2025;

			RAM_data[26] <= 32'h0000_003f;
			RAM_data[27] <= 32'h0000_0006;
			RAM_data[28] <= 32'h0000_005b;
			RAM_data[29] <= 32'h0000_004f;
			RAM_data[30] <= 32'h0000_0066;
			RAM_data[31] <= 32'h0000_006d;
			RAM_data[32] <= 32'h0000_007d;
			RAM_data[33] <= 32'h0000_0007;
			RAM_data[34] <= 32'h0000_007f;
			RAM_data[35] <= 32'h0000_006f;
			RAM_data[36] <= 32'h0000_0077;
			RAM_data[37] <= 32'h0000_007c;
			RAM_data[38] <= 32'h0000_0039;
			RAM_data[39] <= 32'h0000_005e;
			RAM_data[40] <= 32'h0000_0079;
			RAM_data[41] <= 32'h0000_0071;

			for (i = 42; i < RAM_SIZE; i = i + 1)
				RAM_data[i] <= 32'h00000000;


            // 记得初始化没有用到的空间
			// -------- Paste Data Memory Configuration Above
		end
		else if (MemWrite) begin
			if (Address1 == 32'h4000_0010) digi <= Write_data[11 : 0];
			else RAM_data[Address1[RAM_SIZE_BIT + 1:2]] <= Write_data;
		end
	end
			
endmodule

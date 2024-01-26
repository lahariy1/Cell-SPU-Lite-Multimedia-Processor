import definitions::*;

module odd_pipe(clock,reset,rt_addr_in,pc_in,opcode_op_in,ra_in,rb_in,rc_in,I7_in,I10_in,I16_in,I18_in,wr_en_rt_in,rt_addr,fw_op_02_addr,fw_op_03_addr,fw_op_04_addr,fw_op_05_addr,fw_op_06_addr,fw_op_07_addr,out_op_rt_addr,
fw_op_02_data,fw_op_03_data,fw_op_04_data,fw_op_05_data,fw_op_06_data,fw_op_07_data,out_op_rt_data,out_op_wr_en_rt,
fw_op_01_lat,fw_op_02_lat,fw_op_03_lat,fw_op_04_lat,fw_op_05_lat,fw_op_06_lat,fw_op_07_lat,uid_op_02,uid_op_03,uid_op_04,uid_op_05,uid_op_06,uid_op_07, uid_op_08,flush, pc_out,
ls_data_rd_in, ls_data_out, ls_addr_rd_out,ls_wr_en_op_in,ls_wr_en_op,wr_en_rt,wr_en_op_02,wr_en_op_03,wr_en_op_04,wr_en_op_05,wr_en_op_06,wr_en_op_07,


//Debug
rep_left_Bit_32_I10
);
	input clock,reset;
	input [0:6] rt_addr_in; 
	input opcode opcode_op_in;
	input [0:127] ra_in,rb_in,rc_in;
	input [0:31]pc_in; 
	input [0:6] I7_in;
	input [0:9] I10_in;
	input [0:15]I16_in;
	input [0:17]I18_in;
	input wr_en_rt_in;
	input ls_wr_en_op_in;
	output logic ls_wr_en_op;
	
	output logic [0:6] rt_addr;  
	opcode opcode_op; 
	logic [0:127] ra,rb,rc; 
	logic [0:31]pc; 
	logic [0:6] I7; 
	logic [0:9] I10; 
	logic [0:15]I16; 
	logic [0:17]I18; 
	output logic wr_en_rt;
	
	
	logic [0:WORD-1] rep_left_Bit_32_I16,rep_left_Bit_32_I16_1,rep_left_Bit_32_I16_2zero;
	output logic [0:WORD-1] rep_left_Bit_32_I10; 
	logic [0:HALF_WORD-1] rep_left_Bit_16_I10;
	logic [0:127] rt_data;
	//input wrbe[127:0];
	//logic [0:6] fw_op_01_addr;
	output logic [0:6] fw_op_02_addr,fw_op_03_addr,fw_op_04_addr,fw_op_05_addr,fw_op_06_addr,fw_op_07_addr,out_op_rt_addr;
	//logic [0:127] fw_op_01_data;
	output logic [0:127] fw_op_02_data,fw_op_03_data,fw_op_04_data,fw_op_05_data,fw_op_06_data,fw_op_07_data,out_op_rt_data;
	//logic wr_en_op_01;
	output logic wr_en_op_02,wr_en_op_03,wr_en_op_04,wr_en_op_05,wr_en_op_06,wr_en_op_07;
	output logic out_op_wr_en_rt;
	output logic [0:3] fw_op_01_lat,fw_op_02_lat,fw_op_03_lat,fw_op_04_lat,fw_op_05_lat,fw_op_06_lat,fw_op_07_lat;
	//output logic [0:3] out_op_unit_lat;
	logic [0:3] uid_op_01;
	output logic [0:3] uid_op_02,uid_op_03,uid_op_04,uid_op_05,uid_op_06,uid_op_07,uid_op_08;
	output logic [0:31] pc_out;
	input [0:127] ls_data_rd_in;
	output logic [0:127] ls_data_out;
	output logic [0:14] ls_addr_rd_out;
	output logic flush;
	logic [0:3] unit_lat;
	logic [0:3] uid;
	int s;
	logic temp_1;
	logic [0:31] temp_32;
	logic [0:15] temp_16;
    logic [0:3] temp_4;
	logic [0:7] temp_8;
	logic [0:255] temp_256;
 	logic [0:127] temp_128;
	assign rep_left_Bit_32_I16 = {{12{I16[0]}}, I16,4'b0000};
	assign rep_left_Bit_32_I16_1 = {{16{I16[0]}}, I16};
	assign rep_left_Bit_32_I10 = {{18{I10[0]}}, I10,4'b0000};
	assign rep_left_Bit_16_I10 = {{6{I10[0]}}, I10};
	assign rep_left_Bit_32_I16_2zero = {{14{I16[0]}}, I16,2'b00};
	
	parameter MASK1 = 32'hfffffff0;

	always_ff @(posedge clock) begin
		if(flush == 1) begin
			rt_addr   <= 0;
			opcode_op <= NOP_EXEC;
			ra		  <= 0;
			rb  	  <= 0;
			rc		  <= 0;
			I7        <= 0;
			I10       <= 0;
			I16       <= 0;
			I18		  <= 0;
			wr_en_rt  <= 0;
			ls_wr_en_op <=0;
			pc		  <= 0;
		end
		else begin
			rt_addr   <= rt_addr_in;
			opcode_op <= opcode_op_in;
			ra		  <= ra_in;
			rb  	  <= rb_in;
			rc		  <= rc_in;
			I7        <= I7_in;
			I10       <= I10_in;
			I16       <= I16_in;
			I18		  <= I18_in;
			wr_en_rt  <= wr_en_rt_in;
			ls_wr_en_op <=ls_wr_en_op_in;
			pc		  <= pc_in;
		end
	end
	
	always_ff @(posedge clock) begin
		if(reset == 1)begin
			uid_op_02	  <= 0;
			uid_op_03	  <= 0;
			uid_op_04	  <= 0;
			uid_op_05	  <= 0;
			uid_op_06	  <= 0;
			uid_op_07	  <= 0;
			uid_op_08     <= 0;
			
			fw_op_02_data <= 0;
			fw_op_03_data <= 0;
			fw_op_04_data <= 0;
			fw_op_05_data <= 0;
			fw_op_06_data <= 0;
			fw_op_07_data <= 0;
			out_op_rt_data<= 0;
			
			wr_en_op_02	  <= 0;
			wr_en_op_03	  <= 0;
			wr_en_op_04	  <= 0;
			wr_en_op_05	  <= 0;
			wr_en_op_06	  <= 0;
			wr_en_op_07	  <= 0;
			out_op_wr_en_rt  <= 0;
			
			fw_op_02_lat  <= 0;
			fw_op_03_lat  <= 0;
			fw_op_04_lat  <= 0;
			fw_op_05_lat  <= 0;
			fw_op_06_lat  <= 0;
			fw_op_07_lat  <= 0;
			//out_op_unit_lat  <= 0;
			
			fw_op_02_addr <= 0;
			fw_op_03_addr <= 0;
			fw_op_04_addr <= 0;
			fw_op_05_addr <= 0;
			fw_op_06_addr <= 0;
			fw_op_07_addr <= 0;
			out_op_rt_addr   <= 0;
		end
		else if(flush == 1) begin
			
			uid_op_02	  <= 0;
			uid_op_03	  <= uid_op_02;
			uid_op_04	  <= uid_op_03;
			uid_op_05	  <= uid_op_04;
			uid_op_06	  <= uid_op_05;
			uid_op_07	  <= uid_op_06;
			uid_op_08     <= uid_op_07;
			
			fw_op_02_data <= 0;
			fw_op_03_data <= fw_op_02_data;
			fw_op_04_data <= fw_op_03_data;
			fw_op_05_data <= fw_op_04_data;
			fw_op_06_data <= fw_op_05_data;
			fw_op_07_data <= fw_op_06_data;
			out_op_rt_data	  <= fw_op_07_data;
			
			
			wr_en_op_02	  <= 0;
			wr_en_op_03	  <= wr_en_op_02;
			wr_en_op_04	  <= wr_en_op_03;
			wr_en_op_05	  <= wr_en_op_04;
			wr_en_op_06	  <= wr_en_op_05;
			wr_en_op_07	  <= wr_en_op_06;
			out_op_wr_en_rt  <= wr_en_op_07;
			
			fw_op_02_lat  <= 0;
			fw_op_03_lat  <= fw_op_02_lat;
			fw_op_04_lat  <= fw_op_03_lat;
			fw_op_05_lat  <= fw_op_04_lat;
			fw_op_06_lat  <= fw_op_05_lat;
			fw_op_07_lat  <= fw_op_06_lat;
			//out_op_unit_lat  <= fw_op_07_lat;
			
			fw_op_02_addr <= 0;
			fw_op_03_addr <= fw_op_02_addr;
			fw_op_04_addr <= fw_op_03_addr;
			fw_op_05_addr <= fw_op_04_addr;
			fw_op_06_addr <= fw_op_05_addr;
			fw_op_07_addr <= fw_op_06_addr;
			out_op_rt_addr   <= fw_op_07_addr;
		
		end
		else begin
		
			uid_op_02	  <= uid;
			uid_op_03	  <= uid_op_02;
			uid_op_04	  <= uid_op_03;
			uid_op_05	  <= uid_op_04;
			uid_op_06	  <= uid_op_05;
			uid_op_07	  <= uid_op_06;
			uid_op_08     <= uid_op_07;

			
			fw_op_02_data <= rt_data;
			fw_op_03_data <= fw_op_02_data;
			fw_op_04_data <= fw_op_03_data;
			fw_op_05_data <= fw_op_04_data;
			fw_op_06_data <= fw_op_05_data;
			fw_op_07_data <= fw_op_06_data;
			out_op_rt_data	  <= fw_op_07_data;
			
			wr_en_op_02	  <= wr_en_rt;
			wr_en_op_03	  <= wr_en_op_02;
			wr_en_op_04	  <= wr_en_op_03;
			wr_en_op_05	  <= wr_en_op_04;
			wr_en_op_06	  <= wr_en_op_05;
			wr_en_op_07	  <= wr_en_op_06;
			out_op_wr_en_rt  <= wr_en_op_07;
			
			fw_op_01_lat  <= unit_lat;//decode
			fw_op_02_lat  <= fw_op_01_lat;
			fw_op_03_lat  <= fw_op_02_lat;
			fw_op_04_lat  <= fw_op_03_lat;
			fw_op_05_lat  <= fw_op_04_lat;
			fw_op_06_lat  <= fw_op_05_lat;
			fw_op_07_lat  <= fw_op_06_lat;
			//out_op_unit_lat  <= fw_op_07_lat;

			
			fw_op_02_addr <= rt_addr;
			fw_op_03_addr <= fw_op_02_addr;
			fw_op_04_addr <= fw_op_03_addr;
			fw_op_05_addr <= fw_op_04_addr;
			fw_op_06_addr <= fw_op_05_addr;
			fw_op_07_addr <= fw_op_06_addr;
			out_op_rt_addr   <= fw_op_07_addr;
			
		end
	end
	always_comb begin
		flush = 0;
		pc_out = 0;
		case(opcode_op)		
			LOAD_QUADWORD_DFORM:
				begin
//					$display($time," Inside LOAD_QUADWORD_DFORM Address = %h RA = %h \nMAsk = %h rep_left_Bit_32_I10 = %h ls_addr_rd_out = %h\n THing: %h",ls_addr_rd_out,$signed(ra[0:31]),MASK1,$signed(rep_left_Bit_32_I10),ls_addr_rd_out,$signed($signed(rep_left_Bit_32_I10) + $signed(ra[0:31])) );
					ls_addr_rd_out = $signed($signed(rep_left_Bit_32_I10) + $signed(ra[0:31])) & MASK1;
					rt_data	   = ls_data_rd_in;
					unit_lat   = 4'd7;
					uid 	   = 4'd7;
				end
			LOAD_QUADWORD_AFORM:
				begin
					//$display($time, "Inside LOAD_QUADWORD_AFORM
					ls_addr_rd_out = rep_left_Bit_32_I16_2zero & MASK1;
					rt_data	   = ls_data_rd_in;
					unit_lat   = 4'd7;
					uid 	   = 4'd7;
				end
			STORE_QUADWORD_DFORM:
				begin
					ls_addr_rd_out = $signed($signed(rep_left_Bit_32_I10) + $signed(ra[0:31])) & MASK1;
					ls_data_out = rc;
					unit_lat   = 4'd7;
					uid 	   = 4'd7;
				end
			STORE_QUADWORD_AFORM:
				begin
				$display($time, "Inside STORE_QUADWORD_AFORM  rep_left_Bit_32_I16_2zero %h %h %h",rep_left_Bit_32_I16_2zero, I16,{{14{I16[0]}}, I16,2'b00});
					ls_addr_rd_out = rep_left_Bit_32_I16_2zero & MASK1;
					ls_data_out = rc;
					unit_lat   = 4'd7;
					uid 	   = 4'd7;
				end
			IMMEDIATE_LOAD_HALFWORD:
				begin
					for(int i=0; i< 8;i++)	rt_data[i*HALF_WORD+:HALF_WORD] = I16;
					unit_lat   = 4'd7;
					uid 	   = 4'd7;
				end
			IMMEDIATE_LOAD_WORD:
				begin
					for(int i=0; i< 4;i++)	rt_data[i*WORD+:WORD] = rep_left_Bit_32_I16_1;
					unit_lat   = 4'd7;
					uid 	   = 4'd7;
				end
			IMMEDIATE_LOAD_ADDRESS:
				begin
					for(int i=0; i< 4;i++)	rt_data[i*WORD+:WORD] = {14'b00000000000000,{I18}};
					unit_lat   = 4'd7;
					uid 	   = 4'd7;
				end
			GATHER_BITS_FROM_WORDS:
				begin
				temp_4 = 0;
					for(int i=0;i < 4; i++) begin
						temp_4[i] = ra[i*WORD + WORD - 1]; 
					end
					rt_data[0*WORD +: WORD] = {28'b0, temp_4};
					rt_data[1*WORD +: WORD] = 0;
					rt_data[2*WORD +: WORD] = 0;
					rt_data[3*WORD +: WORD] = 0;
					unit_lat = 4'd4;
					uid = 4'd6;
				end
			GATHER_BITS_FROM_HALFWORDS:
				begin
				temp_8 = 0;
					for(int i=0;i < 8; i++) begin
						temp_8[i] = ra[i*HALF_WORD + HALF_WORD - 1]; 
					end
					rt_data[0*WORD +: WORD] = {24'b0, temp_8};
					rt_data[1*WORD +: WORD] = 0;
					rt_data[2*WORD +: WORD] = 0;
					rt_data[3*WORD +: WORD] = 0;
					unit_lat = 4'd4;
					uid = 4'd6;
					$display($time,"Inside GATHER_BITS_FROM_HALFWORDS");
				end
			SHUFFLE_BYTES:
				begin
				temp_256 = {ra, rb}; 
					for(int i = 0;i< WORD; i++) begin
						temp_8 = rc_in[i*BYTE+:BYTE];
						if(temp_8[0:1] == 2'b10) begin
							rt_data[i*BYTE +:BYTE] = 8'h0;
						end
						else if(temp_8[0:2] == 3'b110) begin
							rt_data[i*BYTE +:BYTE] = 8'hff;
						end 
						else if(temp_8[0:2] == 3'b111) begin
							rt_data[i*BYTE +:BYTE] = 8'h80;
						end 
						else begin
							temp_8 = temp_8 & 8'h1F;
							rt_data[i*BYTE +:BYTE] = temp_256[i*temp_8+:BYTE];
						end
					end
					unit_lat = 4'd4;
					uid = 4'd6;
				end
			SHIFT_LEFT_QUADWORD_BY_BITS:  
				begin	
					s = rb[29:31];
					for(int b=0; b<128; b++) begin	
						if(b+s < 128) begin 
							temp_128[b] = ra[b+s];
						end
						else begin
							temp_128[b] = 0;
						end
					end
					rt_data = temp_128;
					unit_lat = 4'd4;
					uid = 4'd6;
				end
			SHIFT_LEFT_QUADWORD_BY_BITS_IMMEDIATE:
				begin
					s = I7 & 8'h07;
					for(int b=0; b<128; b++) begin
						if(b+s < 128) begin 
							temp_128[b] = ra[b+s];
						end
						else begin
							temp_128[b] = 0;
						end
					end
					rt_data = temp_128;
					unit_lat = 4'd4;
					uid = 4'd6;
				end
			SHIFT_LEFT_QUADWORD_BY_BYTES:
				begin
					s = rb[27:31];
					for(int b=0; b<16; b++) begin
						if(b+s < 16) begin 
							temp_128[b*BYTE +:BYTE] = ra[(b+s)*BYTE +: BYTE];
						end
						else begin
							temp_128[b*BYTE +:BYTE] = 0;
						end
					end
					rt_data = temp_128;
					unit_lat = 4'd4;
					uid = 4'd6;
				end
			SHIFT_LEFT_QUADWORD_BY_BYTES_IMMEDIATE:
				begin
					s = I7 & 8'h1F;
					for(int b=0; b<16; b++) begin
						if(b+s < 16) begin 
							temp_128[b*BYTE +:BYTE] = ra[(b+s)*BYTE +: BYTE];
						end
						else begin
							temp_128[b*BYTE +:BYTE] = 0;
						end
					end
					rt_data = temp_128;
					unit_lat = 4'd4;
					uid = 4'd6;
				end
			ROTATE_QUADWORD_BY_BYTES:
				begin	
					s = rb[28:31];
					for(int b=0; b<16; b++) begin
						if(b+s < 16) begin 
							temp_128[b*BYTE +:BYTE] = ra[(b+s)*BYTE +: BYTE];
						end
						else begin
							temp_128[b*BYTE +:BYTE] = ra[(b+s-16)*BYTE +: BYTE];
						end
					end
					rt_data = temp_128;
					unit_lat = 4'd4;
					uid = 4'd6;
				end
						
			ROTATE_QUADWORD_BY_BYTES_IMMEDIATE: 
				begin	
					s = I7[3:6];
					for(int b=0; b<16; b++) begin
						if(b+s < 16) begin 
							temp_128[b*BYTE +:BYTE] = ra[(b+s)*BYTE +: BYTE];
						end
						else begin
							temp_128[b*BYTE +:BYTE] = ra[(b+s-16)*BYTE +: BYTE];
						end
					end
					rt_data = temp_128;
					unit_lat = 4'd4;
					uid = 4'd6;
				end
			
			BRANCH_RELATIVE:
				begin	
					pc_out = $signed(pc) + $signed(rep_left_Bit_32_I16_2zero);
					$display("pc value relative is %d", pc);
					$display("I16 value relative is %d",rep_left_Bit_32_I16_2zero);
					$display("signed pc value relative is %d", $signed(pc));
					$display("signed I16 value relative is %d",$signed(rep_left_Bit_32_I16_2zero));
					$display("pc_out relative is %d", pc_out);
					unit_lat = 4'd1;
					uid = 4'd8;
					flush = 1;
				end	
			BRANCH_ABSOLUTE:
				begin
					pc_out = rep_left_Bit_32_I16_2zero;
					$display($time,"pc_out absolute is %d", pc_out);
					unit_lat = 4'd1;
					uid = 4'd8;
					flush = 1;
					$display($time,"flush for br absolute is %d", flush);
				end
			BRANCH_IF_NOT_ZERO_WORD:
				begin	
					if(rc[0:31] != 32'd0) begin 
						pc_out = pc + $signed(rep_left_Bit_32_I16_2zero) & 32'hFFFFFFFC;
						flush = 1;
					end
					unit_lat = 4'd1;
					uid = 4'd8;
					//$display($time,"flush for br if n zero is %d", flush);
					
				end
			BRANCH_IF_ZERO_WORD:
				begin	
					if(rc[0:31] == 32'd0) begin 
						pc_out = pc + $signed(rep_left_Bit_32_I16_2zero) & 32'hFFFFFFFC;
						flush = 1;
					end
					unit_lat = 4'd1;
					uid = 4'd8;
					$display($time,"flush for br if  zero word is %d", flush);
				end
			BRANCH_IF_NOT_ZERO_HALFWORD:
				begin	
					if(rc[16:31] != 0) begin 
						pc_out = pc + $signed(rep_left_Bit_32_I16_2zero) & 32'hFFFFFFFC;
						flush = 1;
					end
					unit_lat = 4'd1;
					uid = 4'd8;
				end
			BRANCH_IF_ZERO_HALFWORD:
				begin	
					if(rc[2:3] == 0) begin 
						pc_out = pc + $signed(rep_left_Bit_32_I16_2zero) & 32'hFFFFFFFC;
						flush = 1;
					end
					unit_lat = 4'd1;
					uid = 4'd8;
				end
			NOP_LOAD:  
				begin
					rt_data = 0;
					unit_lat = 0;
					uid = 0;
				end
			STOP_AND_SIGNAL:   
				begin
					rt_data = 0;
					unit_lat = 0;
					uid = 0;
				end
		endcase
	end
endmodule

			
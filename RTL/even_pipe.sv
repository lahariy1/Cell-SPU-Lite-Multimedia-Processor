import definitions::*;

module even_pipe(clock,reset,clear_in,rt_addr_in, flush_in,opcode_ep_in,ra_in,rb_in,rc_in,I7_in,I10_in,I16_in,I18_in,wr_en_rt_in,
rt_addr,fw_ep_02_addr,fw_ep_03_addr,fw_ep_04_addr,fw_ep_05_addr,fw_ep_06_addr,fw_ep_07_addr,out_ep_rt_addr,
fw_ep_02_data,fw_ep_03_data,fw_ep_04_data,fw_ep_05_data,fw_ep_06_data,fw_ep_07_data, out_ep_rt_data,out_ep_wr_en_rt,
uid_ep_02, uid_ep_03, uid_ep_04, uid_ep_05, uid_ep_06, uid_ep_07,uid_ep_08,
fw_ep_01_lat,fw_ep_02_lat,fw_ep_03_lat,fw_ep_04_lat,fw_ep_05_lat,fw_ep_06_lat,fw_ep_07_lat,wr_en_rt,wr_en_ep_02,wr_en_ep_03,wr_en_ep_04,wr_en_ep_05,wr_en_ep_06,wr_en_ep_07
);
	input flush_in;
	input clock,reset;
	input clear_in;
	input [0:6] rt_addr_in; 
	input opcode opcode_ep_in;
	input [0:127] ra_in,rb_in,rc_in;
	input [0:6] I7_in;
	input [0:9] I10_in;
	input [0:15]I16_in;
	input [0:17]I18_in;
	input wr_en_rt_in;
	
	logic clear;
	output logic [0:6] rt_addr;  
	opcode opcode_ep; 
	logic [0:127] ra,rb,rc; 
	logic [0:6] I7; 
	logic [0:9] I10; 
	logic [0:15]I16; 
	logic [0:17]I18; 
	output logic wr_en_rt; 

	
	logic [0:WORD-1] rep_left_Bit_32_I7; 
	logic [0:HALF_WORD-1] rep_left_Bit_16_I7;	
	logic [0:WORD-1] rep_left_Bit_32_I16;
	logic [0:WORD-1] rep_left_Bit_32_I10;
	logic [0:HALF_WORD-1] rep_left_Bit_16_I10;
	logic [0:127] rt_data;
	logic [0:3] uid;
	//input wrbe[127:0];*/
	logic [0:6] fw_ep_01_addr;
	output logic [0:6] fw_ep_02_addr,fw_ep_03_addr,fw_ep_04_addr,fw_ep_05_addr,fw_ep_06_addr,fw_ep_07_addr,out_ep_rt_addr;
	logic [0:127] fw_ep_01_data;
	output logic [0:127] fw_ep_02_data,fw_ep_03_data,fw_ep_04_data,fw_ep_05_data,fw_ep_06_data,fw_ep_07_data, out_ep_rt_data;
	output logic wr_en_ep_02,wr_en_ep_03,wr_en_ep_04,wr_en_ep_05,wr_en_ep_06,wr_en_ep_07;
	output logic out_ep_wr_en_rt;
	output logic [0:3] fw_ep_01_lat,fw_ep_02_lat,fw_ep_03_lat,fw_ep_04_lat,fw_ep_05_lat,fw_ep_06_lat,fw_ep_07_lat;
	//output logic [0:3] out_ep_unit_lat;
	logic [0:3] uid_ep_01;
	output logic [0:3] uid_ep_02, uid_ep_03, uid_ep_04, uid_ep_05, uid_ep_06, uid_ep_07,uid_ep_08;
	//output logic [0:3] out_ep_uid;
	logic [0:3] unit_lat;
	

	logic temp_1;
	logic [0:31] temp_32, temp_32_1;	
	logic [0:15] temp_16, temp_16_1;
	logic [0:3] temp_4;
	logic [0:7] temp_8,temp_8_1; 		
	assign rep_left_Bit_32_I16 = {{16{I16[0]}}, I16};
	assign rep_left_Bit_32_I10 = {{22{I10[0]}}, I10};
	assign rep_left_Bit_16_I10 = {{6{I10[0]}}, I10};
	assign rep_left_Bit_16_I7  = {{9{I7[0]}}, I7}; 	
	assign rep_left_Bit_32_I7  = {{25{I7[0]}}, I7};

	real temp1_32_real,temp2_32_real,temp3_32_real,temp4_32_real;

	int s;
	
	always_ff @(posedge clock) begin
		
		rt_addr   <= rt_addr_in;
		opcode_ep <= opcode_ep_in;
		ra		  <= ra_in;
		rb  	  <= rb_in;
		rc		  <= rc_in;
		I7        <= I7_in;
		I10       <= I10_in;
		I16       <= I16_in;
		I18		  <= I18_in;
		wr_en_rt  <= wr_en_rt_in;
		clear     <= clear_in;
		
		// Clear stage 1 when flush occurs
		if(flush_in == 1) begin
		rt_addr   <= 0;
		opcode_ep <= NOP_EXEC;
		ra		  <= 0;
		rb  	  <= 0;
		rc		  <= 0;
		I7        <= 0;
		I10       <= 0;
		I16       <= 0;
		I18		  <= 0;
		wr_en_rt  <= 0;
		clear     <= 0;
		end
		
	end
	

	always_ff @(posedge clock) begin
		if(reset == 1)begin
			
			uid_ep_02	  <= 0;
			uid_ep_03	  <= 0;
			uid_ep_04	  <= 0;
			uid_ep_05	  <= 0;
			uid_ep_06	  <= 0;
			uid_ep_07	  <= 0;
			uid_ep_08	  <= 0;
			
			
			
			fw_ep_02_data <= 0;
			fw_ep_03_data <= 0;
			fw_ep_04_data <= 0;
			fw_ep_05_data <= 0;
			fw_ep_06_data <= 0;
			fw_ep_07_data <= 0;
			out_ep_rt_data   <= 0;
			
			
			wr_en_ep_02	  <= 0;
			wr_en_ep_03	  <= 0;
			wr_en_ep_04	  <= 0;
			wr_en_ep_05	  <= 0;
			wr_en_ep_06	  <= 0;
			wr_en_ep_07	  <= 0;
			out_ep_wr_en_rt  <= 0;
			
			
			fw_ep_02_lat  <= 0;
			fw_ep_03_lat  <= 0;
			fw_ep_04_lat  <= 0;
			fw_ep_05_lat  <= 0;
			fw_ep_06_lat  <= 0;
			fw_ep_07_lat  <= 0;
			

			fw_ep_02_addr <= 0;
			fw_ep_03_addr <= 0;
			fw_ep_04_addr <= 0;
			fw_ep_05_addr <= 0;
			fw_ep_06_addr <= 0;
			fw_ep_07_addr <= 0;
			out_ep_rt_addr   <= 0;
			
		end
		else if(flush_in == 1 && clear == 1) begin
			
			uid_ep_02	  <= 0;
			uid_ep_03	  <= uid_ep_02;
			uid_ep_04	  <= uid_ep_03;
			uid_ep_05	  <= uid_ep_04;
			uid_ep_06	  <= uid_ep_05;
			uid_ep_07	  <= uid_ep_06;
			uid_ep_08	  <= uid_ep_07;
			
			
			
			fw_ep_02_data <= 0;
			fw_ep_03_data <= fw_ep_02_data;
			fw_ep_04_data <= fw_ep_03_data;
			fw_ep_05_data <= fw_ep_04_data;
			fw_ep_06_data <= fw_ep_05_data;
			fw_ep_07_data <= fw_ep_06_data;
			out_ep_rt_data   <= fw_ep_07_data;
			
			
			wr_en_ep_02	  <= 0;
			wr_en_ep_03	  <= wr_en_ep_02;
			wr_en_ep_04	  <= wr_en_ep_03;
			wr_en_ep_05	  <= wr_en_ep_04;
			wr_en_ep_06	  <= wr_en_ep_05;
			wr_en_ep_07	  <= wr_en_ep_06;
			out_ep_wr_en_rt  <= wr_en_ep_07;
			
			
			fw_ep_02_lat  <= 0;
			fw_ep_03_lat  <= fw_ep_02_lat;
			fw_ep_04_lat  <= fw_ep_03_lat;
			fw_ep_05_lat  <= fw_ep_04_lat;
			fw_ep_06_lat  <= fw_ep_05_lat;
			fw_ep_07_lat  <= fw_ep_06_lat;
			

			
			fw_ep_02_addr <= 0;
			fw_ep_03_addr <= fw_ep_02_addr;
			fw_ep_04_addr <= fw_ep_03_addr;
			fw_ep_05_addr <= fw_ep_04_addr;
			fw_ep_06_addr <= fw_ep_05_addr;
			fw_ep_07_addr <= fw_ep_06_addr;
			out_ep_rt_addr   <= fw_ep_07_addr;
		end
		else begin
			
			uid_ep_02	  <= uid;
			uid_ep_03	  <= uid_ep_02;
			uid_ep_04	  <= uid_ep_03;
			uid_ep_05	  <= uid_ep_04;
			uid_ep_06	  <= uid_ep_05;
			uid_ep_07	  <= uid_ep_06;
			uid_ep_08	  <= uid_ep_07;
			
			
			
			fw_ep_02_data <= rt_data;
			fw_ep_03_data <= fw_ep_02_data;
			fw_ep_04_data <= fw_ep_03_data;
			fw_ep_05_data <= fw_ep_04_data;
			fw_ep_06_data <= fw_ep_05_data;
			fw_ep_07_data <= fw_ep_06_data;
			out_ep_rt_data   <= fw_ep_07_data;
			
			
			wr_en_ep_02	  <= wr_en_rt;
			wr_en_ep_03	  <= wr_en_ep_02;
			wr_en_ep_04	  <= wr_en_ep_03;
			wr_en_ep_05	  <= wr_en_ep_04;
			wr_en_ep_06	  <= wr_en_ep_05;
			wr_en_ep_07	  <= wr_en_ep_06;
			out_ep_wr_en_rt  <= wr_en_ep_07;
			
			
			fw_ep_02_lat  <= unit_lat;
			fw_ep_03_lat  <= fw_ep_02_lat;
			fw_ep_04_lat  <= fw_ep_03_lat;
			fw_ep_05_lat  <= fw_ep_04_lat;
			fw_ep_06_lat  <= fw_ep_05_lat;
			fw_ep_07_lat  <= fw_ep_06_lat;
			

			
			fw_ep_02_addr <= rt_addr;
			fw_ep_03_addr <= fw_ep_02_addr;
			fw_ep_04_addr <= fw_ep_03_addr;
			fw_ep_05_addr <= fw_ep_04_addr;
			fw_ep_06_addr <= fw_ep_05_addr;
			fw_ep_07_addr <= fw_ep_06_addr;
			out_ep_rt_addr   <= fw_ep_07_addr;
		end
	end


	always_comb begin
		case(opcode_ep)		
			ADD_HALFWORD:
				begin
					for(int i=0; i < 8; i++) begin
						rt_data[i*HALF_WORD +: HALF_WORD] = ra[i*HALF_WORD +: HALF_WORD] + rb[i*HALF_WORD +: HALF_WORD];
					end
					unit_lat = 4'd3;
					uid = 4'd1;
					$display($time,"Inside ADD_HALFWORD");
				end
				
			ADD_HALFWORD_IMMEDIATE:
				begin
					for(int i=0; i < 8; i++) begin
						rt_data[i*HALF_WORD +: HALF_WORD] = ra[i*HALF_WORD +: HALF_WORD] + rep_left_Bit_16_I10 ;
					end
					unit_lat = 4'd3;
					uid = 4'd1;
					$display($time,"Inside ADD_HALFWORD_IMMEDIATE");
				end
			ADD_WORD:
				begin
				$display($time,"Inside ADD_WORD");
					for(int i=0; i < 4; i++) begin
						rt_data[i*WORD +: WORD] = ra[i*WORD +: WORD] + rb[i*WORD +: WORD];
					end
					unit_lat = 4'd3;
					uid = 4'd1;
				end
			ADD_WORD_IMMEDIATE:
				begin
					for(int i=0; i < 4; i++) begin
						rt_data[i*WORD +: WORD] = ra[i*WORD +: WORD] + rep_left_Bit_32_I10 ;
					end
					unit_lat = 4'd3;
					uid = 4'd1;
				end
			SUB_FROM_HALFWORD:
				begin
				$display($time,"Inside SUB_FROM_HALFWORD");
					for(int i=0; i < 8; i++) begin
						rt_data[i*HALF_WORD +: HALF_WORD] = rb[i*HALF_WORD +: HALF_WORD] + ~(ra[i*HALF_WORD +: HALF_WORD]) + 1;
						$display($time,"Result = %d",rt_data[i*HALF_WORD +: HALF_WORD]);
						
					end
					unit_lat = 4'd3;
					uid = 4'd1;
				end
			SUB_FROM_HALFWORD_IMMEDIATE://new
                begin
				$display($time,"Inside SUB_FROM_HALFWORD_IMMEDIATE");
                    for(int i=0; i < 8; i++) begin
                        rt_data[i*HALF_WORD +: HALF_WORD] = rep_left_Bit_16_I10 + ~(ra[i*HALF_WORD +: HALF_WORD]) + 1;
						$display($time,"Result = %d",rt_data[i*HALF_WORD +: HALF_WORD]);
                    end
                    unit_lat = 4'd3;
                    uid = 4'd1;
                end
			SUB_FROM_WORD: //new change lah
				begin
					for(int i=0; i < 4; i++) begin
						//rt_data[i*WORD +: WORD] = rb[i*WORD +: WORD] + ~(ra[i*WORD +: WORD]) + 1;
						//$display($time,"rb[i*WORD +: WORD] = %d (ra[i*WORD +: WORD]) =%d",rb[i*WORD +: WORD] , ra[i*WORD +: WORD]);
						rt_data[i*WORD +: WORD] = rb[i*WORD +: WORD] - ra[i*WORD +: WORD];
						//$display($time,"Result = %d",rt_data[i*WORD +: WORD]);
						
					end
					unit_lat = 4'd3;
					uid = 4'd1;
				end
			SUB_FROM_WORD_IMMEDIATE://new
                 begin
				$display($time,"Inside SUB_FROM_WORD_IMMEDIATE");
                    for(int i=0; i < 4; i++) begin
						$display($time,"rep_left_Bit_32_I10 = %d (ra[i*WORD +: WORD]) =%d", rep_left_Bit_32_I10, ra[i*WORD +: WORD]);
                        //rt_data[i*WORD +: WORD] = rep_left_Bit_32_I10 + ~(ra[i*WORD +: WORD]) + 1;
						rt_data[i*WORD +: WORD] = rep_left_Bit_32_I10 - ra[i*WORD +: WORD];
						$display($time,"Result = %d",rt_data[i*WORD +: WORD]);
                    end
                    unit_lat = 4'd3;
					uid = 4'd1;
                end

			MULTIPLY: //check
                begin
				$display($time,"MULTIPLY");
                    for(int i=0; i < 4; i++) begin
                        rt_data[i*WORD +: WORD] = $signed(ra[((i*WORD)+HALF_WORD) +: HALF_WORD]) * $signed(rb[((i*WORD)+HALF_WORD) +: HALF_WORD]);
						$display($time,"Result = %d  op1 =%d op2 =%d ",rt_data[i*WORD +: WORD],$signed(ra[((i*WORD)+HALF_WORD) +: HALF_WORD]),$signed(rb[((i*WORD)+HALF_WORD) +: HALF_WORD]));
                    end
                    uid = 4'd4;
					unit_lat = 4'd8;
                end
			MULITPLY_UNSIGNED:
				begin
				$display($time,"Inside MULITPLY_UNSIGNED");
                    for(int i=0; i < 4; i++) begin
                        rt_data[i*WORD +: WORD] = $unsigned(ra[((i*WORD)+HALF_WORD) +: HALF_WORD]) * $unsigned(rb[((i*WORD)+HALF_WORD) +: HALF_WORD]);
						$display($time,"Result = %d  op1 =%d op2 =%d ",rt_data[i*WORD +: WORD],$unsigned(ra[((i*WORD)+HALF_WORD) +: HALF_WORD]),$unsigned(rb[((i*WORD)+HALF_WORD) +: HALF_WORD]));
					end
					
                    uid = 4'd4;
					unit_lat = 4'd8;
                end
            MULTIPLY_IMMEDIATE:
                begin
				$display($time,"Inside MULTIPLY_IMMEDIATE");
                    for(int i=0; i < 4; i++) begin
                        rt_data[i*WORD +: WORD] = $signed(ra[((i*WORD)+HALF_WORD) +: HALF_WORD]) * $signed(rep_left_Bit_16_I10);
						$display($time,"Result = %d  op1 =%d op2 =%d ",rt_data[i*WORD +: WORD],$signed(ra[((i*WORD)+HALF_WORD) +: HALF_WORD]),$signed(rep_left_Bit_16_I10));
                    end
                    uid = 4'd4;
					unit_lat = 4'd8;
                end

            MULTIPLY_AND_ADD:
                begin
				$display($time,"MULTIPLY_AND_ADD");
                    for(int i=0; i < 4; i++) begin
                        rt_data[i*WORD +: WORD] = $signed(ra[((i*WORD)+HALF_WORD) +: HALF_WORD]) * $signed(rb[((i*WORD)+HALF_WORD) +: HALF_WORD]) + $signed(rc[i*WORD +: WORD]);
						$display($time,"Result = %d  op1 =%d op2 =%d op3 =%d",rt_data[i*WORD +: WORD],$signed(ra[((i*WORD)+HALF_WORD) +: HALF_WORD]),$signed(rb[((i*WORD)+HALF_WORD) +: HALF_WORD]),rc[i*WORD +: WORD] );
                    end
                    uid = 4'd4;
					unit_lat = 4'd8;
                end
			COUNTING_LEADING_ZEROS:
				begin
                    for(int i=0; i < 4; i++) begin
                        temp_1 = 'd0;
                        temp_32 = ra[i*WORD +: WORD];
                        for(int j=0; j < WORD; j++) begin
                            if(temp_32[j] == 1 && temp_1 == 'd0) begin 
                                temp_1 = 'd1;
                                rt_data[i*WORD +: WORD] = j;
                            end
                        end
                        if(temp_1 == 'd0) rt_data[i*WORD +: WORD] = 32;
                    end
                    uid = 4'd1;
					unit_lat = 4'd3;
				end
			FORM_SELECT_MASK_BYTES://GMS extra
				begin
					temp_16 = ra[2*BYTE +:HALF_WORD];
					for(int i=0; i < HALF_WORD; i++) begin
						if(temp_16[i] == 0)begin
							rt_data[i*BYTE+:BYTE] = 8'd0;  
						end
						else begin
							rt_data[i*BYTE+:BYTE] = 8'hff; 
						end
					end
					uid = 4'd1;
					unit_lat = 4'd3;
				end
			FORM_SELECT_MASK_BYTES_IMMEDIATE://new
				begin
					for(int i=0; i < HALF_WORD; i++) begin
						if(I16[i] == 0)begin
							rt_data[i*BYTE+:BYTE] = 8'd0;  
						end
						else begin
							rt_data[i*BYTE+:BYTE] = 8'hff; 
						end
					end
					uid = 4'd1;
					unit_lat = 4'd3;
				end
			FORM_SELECT_MASK_HALFWORD://GMS
				begin
					temp_8 = ra[3*BYTE +:BYTE];
					for(int i=0; i < BYTE; i++) begin
						if(temp_8[i] == 0)begin
							rt_data[i*HALF_WORD+:HALF_WORD] = 16'd0;  
						end
						else begin
							rt_data[i*HALF_WORD+:HALF_WORD] =  16'hffff; 
						end
					end
					uid = 4'd1;
					unit_lat = 4'd3;
				end
			FORM_SELECT_MASK_WORD://GMS
				begin
					temp_4 = ra[28+:NIBBLE];
					for(int i=0; i < NIBBLE; i++) begin
						if(temp_4[i] == 0)begin
							rt_data[i*WORD+:WORD] = 32'd0;  
						end
						else begin
							rt_data[i*WORD+:WORD] =  32'hffffffff; 
						end
					end
					uid = 4'd1;
					unit_lat = 4'd3;
				end
			AND:
				begin
					for(int i=0; i < 4; i++) begin
						rt_data[i*WORD +: WORD] = ra[i*WORD +: WORD] & rb[i*WORD +: WORD];
					end
					$display($time,"rt %h ra %h rb %h", rt_data,ra,rb);
					uid = 4'd1;
					unit_lat = 4'd3;
				end
				
			AND_HALFWORD_IMMEDIATE:
				begin
					for(int i=0; i < 8; i++) begin
						rt_data[i*HALF_WORD +: HALF_WORD] = ra[i*HALF_WORD +: HALF_WORD] & rep_left_Bit_16_I10 ;
					end
					uid = 4'd1;
					unit_lat = 4'd3;
				end
			AND_WORD_IMMEDIATE:
				begin
					for(int i=0; i < 4; i++) begin
						rt_data[i*WORD +: WORD] = ra[i*WORD +: WORD] & rep_left_Bit_32_I10 ;
					end
					uid = 4'd1;
					unit_lat = 4'd3;
				end
			OR:
				begin
					for(int i=0; i < 4; i++) begin
						rt_data[i*WORD +: WORD] = ra[i*WORD +: WORD] | rb[i*WORD +: WORD];
					end
					uid = 4'd1;
					unit_lat = 4'd3;
				end
			OR_BYTE_IMMEDIATE://New
                begin
                    for(int i=0; i < 4; i++) begin
                        temp_8 = I10 & 16'h00ff;
                        temp_32 = {4{temp_8}};
                        rt_data[i*WORD +: WORD] = ra[i*WORD +: WORD] | temp_32;
                    end
                    uid = 4'd1;
                    unit_lat = 4'd3;
                end
			OR_HALFWORD_IMMEDIATE:
				begin
					for(int i=0; i < 8; i++) begin
						rt_data[i*HALF_WORD +: HALF_WORD] = ra[i*HALF_WORD +: HALF_WORD] | rep_left_Bit_16_I10 ;
					end
					uid = 4'd1;
					unit_lat = 4'd3;
				end
			OR_WORD_IMMEDIATE:
				begin
					for(int i=0; i < 4; i++) begin
						rt_data[i*WORD +: WORD] = ra[i*WORD +: WORD] | rep_left_Bit_32_I10 ;
					end
					uid = 4'd1;
					unit_lat = 4'd3;
				end
			NOR:
				begin
					for(int i=0; i < 4; i++) begin
						rt_data[i*WORD +: WORD] = ra[i*WORD +: WORD] | ~(rb[i*WORD +: WORD]);
					end
					uid = 4'd1;
					unit_lat = 4'd3;
				end
			XOR:
				begin
					for(int i=0; i < 4; i++) begin
						rt_data[i*WORD +: WORD] = ra[i*WORD +: WORD] ^ rb[i*WORD +: WORD];
					end
					uid = 4'd1;
					unit_lat = 4'd3;
				end
			XOR_BYTE_IMMEDIATE://new
                begin
                    for(int i=0; i < 4; i++) begin
                        temp_8 = I10 & 16'h00ff;
                        temp_32 = {4{temp_8}};
                        rt_data[i*WORD +: WORD] = ra[i*WORD +: WORD] ^ temp_32;
                    end
                    uid = 4'd1;
                    unit_lat = 4'd3;
                end
			XOR_HALFWORD_IMMEDIATE:
				begin
					for(int i=0; i < 8; i++) begin
						rt_data[i*HALF_WORD +: HALF_WORD] = ra[i*HALF_WORD +: HALF_WORD] ^ rep_left_Bit_16_I10 ;
					end
					uid = 4'd1;
					unit_lat = 4'd3;
				end
			XOR_WORD_IMMEDIATE:
				begin
					for(int i=0; i < 4; i++) begin
						rt_data[i*WORD +: WORD] = ra[i*WORD +: WORD] ^ rep_left_Bit_32_I10 ;
					end
					uid = 4'd1;
					unit_lat = 4'd3;
				end
			 FLOATING_ADD://new
                begin
                    for(int i=0; i < 4; i++) begin
                        temp1_32_real = $bitstoshortreal(ra[i*WORD +: WORD]);
                        temp2_32_real = $bitstoshortreal(ra[i*WORD +: WORD]);
                        temp3_32_real = temp1_32_real + temp2_32_real;
                        if (temp3_32_real < -SMAX)                         rt_data[i*WORD +: WORD] = -$shortrealtobits(SMAX);
                        else if (temp3_32_real > SMAX)                     rt_data[i*WORD +: WORD] =  $shortrealtobits(SMAX);
                        else if (temp3_32_real > -SMIN && temp3_32_real < SMIN) rt_data[i*WORD +: WORD] =  0;
                        else                                         rt_data[i*WORD +: WORD] =  $shortrealtobits(temp3_32_real);
                    end
                    uid = 4'd3;
					unit_lat = 4'd7;
                end

            FLOATING_SUBTRACT://new
                begin
                    for(int i=0; i < 4; i++) begin
                        temp1_32_real = $bitstoshortreal(ra[i*WORD +: WORD]);
                        temp2_32_real = $bitstoshortreal(rb[i*WORD +: WORD]);
                        temp3_32_real = temp1_32_real - temp2_32_real;
                        if (temp3_32_real < -SMAX)                         rt_data[i*WORD +: WORD] = -$shortrealtobits(SMAX);
                        else if (temp3_32_real > SMAX)                     rt_data[i*WORD +: WORD] =  $shortrealtobits(SMAX);
                        else if (temp3_32_real > -SMIN && temp3_32_real < SMIN)  rt_data[i*WORD +: WORD] =  0;
                        else                                         rt_data[i*WORD +: WORD] =  $shortrealtobits(temp3_32_real);
                    end
                    uid = 4'd3;
					unit_lat = 4'd7;
                end
			
			FLOATING_MULTIPLY:
                begin
				$display($time,"FLOATING_MULTIPLY -SMAX = %d SMAX = %d \n -SMIN = %d SMIN %d",-SMAX,SMAX,-SMIN,SMIN);
                    for(int i=0; i < 4; i++) begin
					temp1_32_real = $bitstoshortreal(ra[i*WORD +: WORD]); 
					temp2_32_real = $bitstoshortreal(rb[i*WORD +: WORD]);
					temp3_32_real = temp1_32_real * temp2_32_real;
					if (temp3_32_real < -SMAX)                         	  		rt_data[i*WORD +: WORD] = -$shortrealtobits(SMAX);
                        else if (temp3_32_real > SMAX)                    		rt_data[i*WORD +: WORD] =  $shortrealtobits(SMAX);
                        else if (temp3_32_real > -SMIN && temp3_32_real < SMIN) rt_data[i*WORD +: WORD] =  0;
                        else                                           	  		rt_data[i*WORD +: WORD] =  $shortrealtobits(temp3_32_real);
                    uid = 4'd3;
					unit_lat = 4'd7;
					end
                end
			FLOATING_MULTIPLY_AND_ADD:
				begin
                    for(int i=0; i < 4; i++) begin
					temp1_32_real = $bitstoshortreal(ra[i*WORD +: WORD]); 
					temp2_32_real = $bitstoshortreal(rb[i*WORD +: WORD]);
					temp3_32_real = $bitstoshortreal(rc[i*WORD +: WORD]);
					temp4_32_real = temp1_32_real * temp2_32_real + temp3_32_real;
					$display(" temp1_32_real %d temp2_32_real %d temp3_32_real %d",temp1_32_real,temp2_32_real,temp3_32_real);
					
					if (temp4_32_real < -SMAX)                         	  		rt_data[i*WORD +: WORD] = -$shortrealtobits(SMAX);
                        else if (temp4_32_real > SMAX)                    		rt_data[i*WORD +: WORD] =  $shortrealtobits(SMAX);
                        else if (temp4_32_real > -SMIN && temp4_32_real < SMIN) rt_data[i*WORD +: WORD] =  0;
                        else                                           	  		rt_data[i*WORD +: WORD] =  $shortrealtobits(temp4_32_real);
                    uid = 4'd3;
					unit_lat = 4'd7;
					end
                end
			FLOATING_MULTIPLY_AND_SUBTRACT:
				begin
                    for(int i=0; i < 4; i++) begin
					temp1_32_real = $bitstoshortreal(ra[i*WORD +: WORD]); 
					temp2_32_real = $bitstoshortreal(rb[i*WORD +: WORD]);
					temp3_32_real = $bitstoshortreal(rc[i*WORD +: WORD]);
					temp4_32_real = temp1_32_real * temp2_32_real - temp3_32_real;
					if (temp4_32_real < -SMAX)                         	  		rt_data[i*WORD +: WORD] = -$shortrealtobits(SMAX);
                        else if (temp4_32_real > SMAX)                    		rt_data[i*WORD +: WORD] =  $shortrealtobits(SMAX);
                        else if (temp4_32_real > -SMIN && temp4_32_real < SMIN) rt_data[i*WORD +: WORD] =  0;
                        else                                           	  		rt_data[i*WORD +: WORD] =  $shortrealtobits(temp4_32_real);
                    uid = 4'd3;
					unit_lat = 4'd7;
					end
                end	
			EQUIVALENT: 
				begin
                    for(int i=0; i < 4; i++) begin
                        rt_data[i*WORD +: WORD] = ra[((i*WORD)+HALF_WORD) +: HALF_WORD] ^ (~rb[((i*WORD)+HALF_WORD) +: HALF_WORD]);
                    end
                    uid = 4'd1;
					unit_lat = 4'd3;
                end
			SHIFT_LEFT_HALFWORD:
				begin
					for(int i=0; i < 8; i++) begin
						s = rb[i*HALF_WORD +: HALF_WORD] & 16'h001F;
						//$display("s value is for even instr1 : %d, rb value is %h rb3 = %b,rb4 = %b,rb5 = %b,",s, rb[20:31],rb[3],rb[4],rb[5]);
						temp_16 = ra[i*HALF_WORD +: HALF_WORD];
						for(int b=0; b < 16; b++) begin
							if (b+s < 16)begin
								temp_16_1[b] = temp_16[b + s];
							end
							else begin
								temp_16_1[b] = 0;
							end
						end
						rt_data[i*HALF_WORD +: HALF_WORD] = temp_16_1;
					end
					unit_lat = 4'd4;
					uid = 4'd2;
				end
			SHIFT_LEFT_HALFWORD_IMMEDIATE:
				begin
					s = rep_left_Bit_16_I7 & 16'h001F;
					for(int i=0; i < 8; i++) begin
						temp_16 = ra[i*HALF_WORD +: HALF_WORD];
						//$display("temp_16 value is for even instr1 : %d",temp_16);
						for(int b=0; b < 16; b++) begin
							if (b+s < 16)begin
								temp_16_1[b] = temp_16[b + s];
							end
							else begin
								temp_16_1[b] = 0;
							end
						end
						rt_data[i*HALF_WORD +: HALF_WORD] = temp_16_1;
					end
					unit_lat = 4'd4;
					uid = 4'd2;
				end
			SHIFT_LEFT_WORD:
				begin
					for(int i=0;i<4;i++) begin
						s = rb[i*WORD +: WORD] & 32'h0000003F;
						//$display("s value is for even instr1 : %d",s);
						temp_32 = ra[i*WORD +: WORD];
						//$display("ra value is for even instr1 : %d",ra);
						//$display("temp_32 value is for even instr1 : %d",temp_32);
						for(int b=0;b<32;b++) begin
							if (b+s < 32) begin
								temp_32_1[b] = temp_32[b + s];
							end
							else begin
								temp_32_1[b] = 0;
							end
						end
						rt_data[i*WORD +: WORD] = temp_32_1;
						//$display("rt_data value is for even instr1 : %d",rt_data);
					end
					unit_lat = 4'd4;
					uid = 4'd2;
				end
			SHIFT_LEFT_WORD_IMMEDIATE:
				begin
					s = rep_left_Bit_32_I7 & 32'h0000003F;
					//$display("s value is for even instr2 : %d",s);
					for(int i=0;i<4;i++) begin
						temp_32 = ra[i*WORD +: WORD];
						for(int b=0;b<32;b++) begin
							if (b+s < 32) begin
								temp_32_1[b] = temp_32[b + s];
							end
							else begin
								temp_32_1[b] = 0;
							end
						end
						rt_data[i*WORD +: WORD] = temp_32_1;
					end
					unit_lat = 4'd4;
					uid = 4'd2;
				end
			ROTATE_HALFWORD:
				begin
					for(int i=0;i<8;i++) begin
						s = rb[i*HALF_WORD +: HALF_WORD] & 16'h000F;
						temp_16 = ra[i*HALF_WORD +: HALF_WORD];
						for(int b=0;b<16;b++) begin
							if (b+s < 16) begin
								temp_16_1[b] = temp_16[b + s];
							end
							else begin
								temp_16_1[b] = temp_16[b + s - 16];
							end
						end
						rt_data[i*HALF_WORD +: HALF_WORD] = temp_16_1;
					end
					unit_lat = 4'd4;
					uid = 4'd2;
				end
			ROTATE_HALFWORD_IMMEDIATE:
				begin
					for(int i=0;i<8;i++) begin
						s = rep_left_Bit_16_I7 & 16'h000F;
						temp_16 = ra[i*HALF_WORD +: HALF_WORD];
						for(int b=0;b<16;b++) begin
							if (b+s < 16) begin
								temp_16_1[b] = temp_16[b + s];
							end
							else begin
								temp_16_1[b] = temp_16[b + s - 16];
							end
						end
						rt_data[i*HALF_WORD +: HALF_WORD] = temp_16_1;
					end
					unit_lat = 4'd4;
					uid = 4'd2;
				end
			ROTATE_WORD:
				begin
					for(int i=0;i<4;i++) begin
						s = rb[i*WORD +: WORD] & 32'h0000001F;
						temp_32[0+:WORD] = ra[i*WORD +: WORD];
						for(int b=0;b<32;b++) begin
							if (b+s < 32) begin
								temp_32_1[b] = temp_32[b + s];
							end
							else begin
								temp_32_1[b] = temp_32[b + s - 32];
							end
						end
						rt_data[i*WORD +: WORD] = temp_32_1;
					end
					unit_lat = 4'd4;
					uid = 4'd2;
				end
			ROTATE_WORD_IMMEDIATE:
				begin
					s = rep_left_Bit_32_I7 & 32'h0000001F;
					for(int i=0;i<4;i++) begin
						temp_32[0+:WORD] = ra[i*WORD +: WORD];
						for(int b=0;b<32;b++) begin
							if (b+s < 32) begin
								temp_32_1[b] = temp_32[b + s];
							end
							else begin
								temp_32_1[b] = temp_32[b + s - 32];
							end
						end
						rt_data[i*WORD +: WORD] = temp_32_1;
					end
					unit_lat = 4'd4;
					uid = 4'd2;
				end
			ROTATE_AND_MASK_HALFWORD:   	//did prof ask us to remove rotate mask instr?
				begin
					 for(int i=0;i<8;i++) begin
						s = (0 - rb[i*HALF_WORD +: HALF_WORD]) & 16'h001F;
						temp_16 = ra[i*HALF_WORD +: HALF_WORD];
						//$display("s value is for even rotate  instr2 : %d",s);
						//$display("ra value is for even rotate  instr2 : %h",ra);
						for(int b=0;b<16;b++) begin
							if (b >= s) begin
								temp_16_1[b] = temp_16[b - s];
							end
							else begin
								temp_16_1[b] = 0;
							end
						end
						rt_data[i*HALF_WORD +: HALF_WORD] = temp_16_1;
						//$display("rt value is for even rotate  instr2 : %h",rt_data);
					end
					unit_lat = 4'd4;
					uid = 4'd2;
				end
			ROTATE_AND_MASK_HALFWORD_IMMEDIATE:
				begin
					for(int i=0;i<8;i++) begin
						s = (0 - rep_left_Bit_32_I7) & 16'h001F;
						temp_16 = ra[i*HALF_WORD +: HALF_WORD];
						//$display("s value is for even rotate Imm instr2 : %d",s);
						//$display("ra value is for even rotate Imm  instr2 : %h",ra);
						for(int b=0;b<16;b++) begin
							if (b >= s) begin
								temp_16_1[b] = temp_16[b - s];
							end
							else begin
								temp_16_1[b] = 0;
							end
						end
						rt_data[i*HALF_WORD +: HALF_WORD] = temp_16_1;
						//$display("rt value is for even rotate Imm instr2 : %h",rt_data);
					end
					unit_lat = 4'd4;
					uid = 4'd2;
				end
			COUNT_ONES_IN_BYTES:
				begin
					for(int i=0;i<16;i++) begin
						temp_8_1 = 0;
						temp_8 = ra[i*BYTE +: BYTE];
						for(int b=0;b<8;b++) begin
							if(temp_8[b] == 1) begin
								temp_8_1 = temp_8_1+1;
							end
						end
						rt_data[i*BYTE +: BYTE] = temp_8_1;
					end
					unit_lat = 4;
					uid = 5;
				end
			AVERAGE_BYTES:
				begin
					for(int i=0;i<16;i++) begin
						rt_data[i*BYTE +: BYTE] = ({8'd0,ra[i*BYTE +: BYTE]} + {8'd0,rb[i*BYTE +: BYTE]} + 1); //check the code with spu instr pdf
					end
					unit_lat = 4;
					uid = 5;
				end
			ABSOLUTE_DIFFERENCE_OF_BYTES:
				begin
					for(int i=0;i<16;i++) begin
						if($unsigned(ra[i*BYTE +: BYTE]) > $unsigned(rb[i*BYTE +: BYTE])) begin
							rt_data[i*BYTE +: BYTE] = ra[i*BYTE +: BYTE] - rb[i*BYTE +: BYTE];
						end
						else begin
							rt_data[i*BYTE +: BYTE] = rb[i*BYTE +: BYTE] - ra[i*BYTE +: BYTE];
						end
					end
					unit_lat = 4;
					uid = 5;
				end
			SUM_BYTES_INTO_HALFWORDS:
				begin
					for(int i=0;i<4;i++) begin
						rt_data[2*i*HALF_WORD +: HALF_WORD] = rb[4*i*BYTE +: BYTE] + rb[(4*i + 1)*BYTE +: BYTE] + rb[(4*i + 2)*BYTE +: BYTE] + rb[(4*i + 3)*BYTE +: BYTE];
						rt_data[(2*i+1)*HALF_WORD +: HALF_WORD] = ra[4*i*BYTE +: BYTE] + ra[(4*i + 1)*BYTE +: BYTE] + ra[(4*i + 2)*BYTE +: BYTE] + ra[(4*i + 3)*BYTE +: BYTE];
					end
					unit_lat = 4;
					uid = 5;
				end
			COMPARE_EQUAL_HALFWORD:
				begin
					for(int i=0;i<8;i++) begin
						if(ra[i*HALF_WORD +: HALF_WORD] == rb[i*HALF_WORD +: HALF_WORD]) begin
							rt_data[i*HALF_WORD +: HALF_WORD] = 16'hFFFF;
						end
						else begin
							rt_data[i*HALF_WORD +: HALF_WORD] = 16'h0000;
						end
					end
					unit_lat = 3;
					uid = 1;
				end
			COMPARE_EQUAL_HALFWORD_IMMEDIATE:
				begin
					for(int i=0;i<8;i++) begin
						if(ra[i*HALF_WORD +: HALF_WORD] == rep_left_Bit_16_I10) begin
							rt_data[i*HALF_WORD +: HALF_WORD] = 16'hFFFF;
						end
						else begin
							rt_data[i*HALF_WORD +: HALF_WORD] = 16'h0000;
						end
					end
					unit_lat = 3;
					uid = 1;
				end
			COMPARE_EQUAL_WORD:
				begin
					for(int i=0;i<4;i++) begin
						if(ra[i*WORD +: WORD] == rb[i*WORD +: WORD]) begin
							rt_data[i*WORD +: WORD] = 32'hFFFFFFFF;
						end
						else begin
							rt_data[i*WORD +: WORD] = 32'h00000000;
						end
					end
					unit_lat = 3;
					uid = 1;
				end
			COMPARE_EQUAL_WORD_IMMEDIATE:
				begin
					for(int i=0;i<4;i++) begin
						if(ra[i*WORD +: WORD] == rep_left_Bit_32_I10) begin
							rt_data[i*WORD +: WORD] = 32'hFFFFFFFF;
						end
						else begin
							rt_data[i*WORD +: WORD] = 32'h00000000;
						end
					end
					unit_lat = 3;
					uid = 1;
				end
			COMPARE_GREATER_THAN_HALFWORD:
				begin
					for(int i=0;i<8;i++) begin
						if($signed(ra[i*HALF_WORD +: HALF_WORD]) > $signed(rb[i*HALF_WORD +: HALF_WORD])) begin
							rt_data[i*HALF_WORD +: HALF_WORD] = 16'hFFFF;
						end
						else begin
							rt_data[i*HALF_WORD +: HALF_WORD] = 16'h0000;
						end
					end
					unit_lat = 3;
					uid = 1;
				end
			COMPARE_GREATER_THAN_HALFWORD_IMMEDIATE:
				begin
					for(int i=0;i<8;i++) begin
						if($signed(ra[i*HALF_WORD +: HALF_WORD]) > rep_left_Bit_16_I10) begin
							rt_data[i*HALF_WORD +: HALF_WORD] = 16'hFFFF;
						end
						else begin
							rt_data[i*HALF_WORD +: HALF_WORD] = 16'h0000;
						end
					end
					unit_lat = 3;
					uid = 1;
				end
			COMPARE_GREATER_THAN_WORD:
				begin
					for(int i=0;i<4;i++) begin
						if($signed(ra[i*WORD +: WORD]) > $signed(rb[i*WORD +: WORD])) begin
							rt_data[i*WORD +: WORD] = 32'hFFFFFFFF;
						end
						else begin
							rt_data[i*WORD +: WORD] = 32'h00000000;
						end
					end
					unit_lat = 3;
					uid = 1;
				end
			COMPARE_GREATER_THAN_WORD_IMMEDIATE:
				begin
					for(int i=0;i<4;i++) begin
						if($signed(ra[i*WORD +: WORD]) > rep_left_Bit_32_I10) begin
							rt_data[i*WORD +: WORD] = 32'hFFFFFFFF;
						end
						else begin
							rt_data[i*WORD +: WORD] = 32'h00000000;
						end
					end
					unit_lat = 3;
					uid = 1;
				end
			
			// additional instructions added from other than the instruction set
			COMPARE_LOGICAL_GREATER_THAN_WORD:
				begin
					for(int i=0;i<4;i++) begin
						if(ra[i*WORD +: WORD] > rb[i*WORD +: WORD]) begin
							rt_data[i*WORD +: WORD] = 32'hFFFFFFFF;
						end
						else begin
							rt_data[i*WORD +: WORD] = 32'h00000000;
						end
					end
					unit_lat = 3;
					uid = 1;
				end
			COMPARE_LOGICAL_GREATER_THAN_WORD_IMMEDIATE:
				begin
					for(int i=0;i<4;i++) begin
						if(ra[i*WORD +: WORD] > rep_left_Bit_32_I10) begin
							rt_data[i*WORD +: WORD] = 32'hFFFFFFFF;
						end
						else begin
							rt_data[i*WORD +: WORD] = 32'h00000000;
						end
					end
					unit_lat = 3;
					uid = 1;
				end
			COMPARE_LOGICAL_GREATER_THAN_HALFWORD:
				begin
					for(int i=0;i<8;i++) begin
						if(ra[i*HALF_WORD +: HALF_WORD] > rb[i*HALF_WORD +: HALF_WORD]) begin
							rt_data[i*HALF_WORD +: HALF_WORD] = 16'hFFFF;
						end
						else begin
							rt_data[i*HALF_WORD +: HALF_WORD] = 16'h0000;
						end
					end
					unit_lat = 3;
					uid = 1;
				end
			COMPARE_LOGICAL_GREATER_THAN_HALFWORD_IMMEDIATE:
				begin
					for(int i=0;i<8;i++) begin
						if(ra[i*HALF_WORD +: HALF_WORD] > rep_left_Bit_16_I10) begin
							rt_data[i*HALF_WORD +: HALF_WORD] = 16'hFFFF;
						end
						else begin
							rt_data[i*HALF_WORD +: HALF_WORD] = 16'h0000;
						end
					//$display("rt value is for even comp instr2 : %h",rt_data[i*HALF_WORD +: HALF_WORD]);
					end
					unit_lat = 3;
					uid = 1;
				end
			CARRY_GENERATE:
				begin
					for(int i=0;i<4;i++) begin
						temp_32 = ra[i*WORD +: WORD] + rb[i*WORD +: WORD];   
						rt_data[i*WORD +: WORD] = {31'b0,temp_32[0]};
					end
					unit_lat = 2;
					uid = 1;
				end
			ADD_EXTENDED:
				begin
					for(int i=0;i<4;i++) begin
						rt_data[i*WORD +: WORD] = ra[i*WORD +: WORD] + rb[i*WORD +: WORD] + rc[31 + i*WORD];   
					end
					unit_lat = 2;
					uid = 1;
				end
			
			BORROW_GENERATE:
				begin
					for(int i=0;i<4;i++) begin
						if($unsigned(rb[i*WORD +: WORD]) >= $unsigned(ra[i*WORD +: WORD])) begin
							rt_data[i*WORD +: WORD] = 1;
						end
						else begin
							rt_data[i*WORD +: WORD] = 0;
						end
					end
					unit_lat = 2;
					uid = 1;
				end
			SUBTRACT_FROM_EXTENDED:
				begin
					for(int i=0;i<4;i++) begin
						rt_data[i*WORD +: WORD] = ra[i*WORD +: WORD] - rb[i*WORD +: WORD] + rc[31 + i*WORD];   
					end
					unit_lat = 2;
					uid = 1;
				end
			NOP_EXEC:  //code change
				begin
					rt_data = 0;
					unit_lat = 0;
					uid = 0;
				end
			/*STOP_AND_SIGNAL:   //code change
				begin
					$finish;
				end*/
		
		endcase
	end
			
endmodule
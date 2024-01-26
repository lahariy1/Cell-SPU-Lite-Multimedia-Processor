

import definitions::*;

module rf_fw(clock,reset,clear,wr_en_rt_ep, wr_en_rt_op, flush,pc,opcode_ep,ra_addr_ep,rb_addr_ep,rc_addr_ep,rt_addr_ep,I7_ep,I10_ep,I16_ep,I18_ep,opcode_op,ra_addr_op,rb_addr_op,rc_addr_op,rt_addr_op,I7_op,I10_op,I16_op,I18_op,
ra_rf_data_ep, rb_rf_data_ep, rc_rf_data_ep, ra_rf_data_op,rb_rf_data_op,rc_rf_data_op,opcode_ep_r, rt_addr_ep_r,I7_ep_r,I10_ep_r,I16_ep_r,I18_ep_r,opcode_op_r,rt_addr_op_r,I7_op_r,I10_op_r,I16_op_r,I18_op_r,
fw_ep_02_addr,fw_ep_03_addr,fw_ep_04_addr,fw_ep_05_addr,fw_ep_06_addr,fw_ep_07_addr,out_ep_rt_addr,fw_ep_02_data,fw_ep_03_data,fw_ep_04_data,fw_ep_05_data,fw_ep_06_data,fw_ep_07_data,out_ep_rt_data,
fw_uid_ep_02, fw_uid_ep_03, fw_uid_ep_04, fw_uid_ep_05, fw_uid_ep_06, fw_uid_ep_07,fw_uid_ep_08,fw_op_02_addr,fw_op_03_addr,fw_op_04_addr,fw_op_05_addr,fw_op_06_addr,fw_op_07_addr,out_op_rt_addr,
fw_op_02_data,fw_op_03_data,fw_op_04_data,fw_op_05_data,fw_op_06_data,fw_op_07_data,out_op_rt_data,fw_uid_op_02,fw_uid_op_03,fw_uid_op_04,fw_uid_op_05,fw_uid_op_06,fw_uid_op_07,fw_uid_op_08,out_ep_wr_en_rt, 
ra_fw_data_ep,rb_fw_data_ep,rc_fw_data_ep, ra_fw_data_op,rb_fw_data_op,rc_fw_data_op, pc_out, wr_en_rt_ep_r, wr_en_rt_op_r,ls_wr_en_op,ls_wr_en_op_r,
wr_en_op_02,wr_en_op_03,wr_en_op_04,wr_en_op_05,wr_en_op_06,wr_en_op_07,out_op_wr_en_rt,wr_en_ep_01,wr_en_ep_02,wr_en_ep_03,wr_en_ep_04,wr_en_ep_05,wr_en_ep_06,wr_en_ep_07,clear_r,
ra_addr_op_r,rb_addr_op_r,rc_addr_op_r,ra_addr_ep_r,rb_addr_ep_r,rc_addr_ep_r

);
	parameter UNIT_1 = 4'd1;
	parameter UNIT_2 = 4'd2;
	parameter UNIT_3 = 4'd3;
	parameter UNIT_4 = 4'd4; 
	parameter UNIT_5 = 4'd5; 
	parameter UNIT_6 = 4'd6; 
	parameter UNIT_7 = 4'd7; 
	parameter UNIT_8 = 4'd8;
	input flush;
	input clear;
	input clock,reset;
	input [0:31] pc; //?
	input opcode opcode_ep;
 	input [0:6] ra_addr_ep;
	input [0:6] rb_addr_ep;
	input [0:6] rc_addr_ep;
	input [0:6] rt_addr_ep;
	input [0:6] I7_ep;
	input [0:9] I10_ep;
	input [0:15]I16_ep;
	input [0:17]I18_ep;
	input wr_en_rt_ep, wr_en_rt_op;
	input ls_wr_en_op;
	output logic ls_wr_en_op_r;
	
	
	input opcode opcode_op;
 	input [0:6] ra_addr_op;
	input [0:6] rb_addr_op,rc_addr_op;
	//input [0:6] rc_addr_op;
	input [0:6] rt_addr_op;
	input [0:6] I7_op;
	input [0:9] I10_op;
	input [0:15]I16_op;
	input [0:17]I18_op;
	input [0:127]ra_rf_data_ep, rb_rf_data_ep, rc_rf_data_ep, ra_rf_data_op,rb_rf_data_op,rc_rf_data_op;  //inputs from reg file 
	
	output opcode opcode_ep_r;
 	output logic [0:6] ra_addr_ep_r;
	output logic [0:6] rb_addr_ep_r;
	output logic [0:6] rc_addr_ep_r;
	output logic wr_en_rt_ep_r, wr_en_rt_op_r;
	output logic [0:6] rt_addr_ep_r;
	output logic [0:6] I7_ep_r;
	output logic [0:9] I10_ep_r;
	output logic [0:15]I16_ep_r;
	output logic [0:17]I18_ep_r;
	
	output opcode opcode_op_r;
	output logic [0:6] ra_addr_op_r;
	output logic [0:6] rb_addr_op_r;
	output logic [6:0] rc_addr_op_r;
	output logic [0:6] rt_addr_op_r;
	output logic [0:6] I7_op_r;
	output logic [0:9] I10_op_r;
	output logic [0:15]I16_op_r;
	output logic [0:17]I18_op_r;
	output logic clear_r;
	
	input logic [0:6] fw_ep_02_addr,fw_ep_03_addr,fw_ep_04_addr,fw_ep_05_addr,fw_ep_06_addr,fw_ep_07_addr,out_ep_rt_addr;
	input logic [0:127] fw_ep_02_data,fw_ep_03_data,fw_ep_04_data,fw_ep_05_data,fw_ep_06_data,fw_ep_07_data,out_ep_rt_data;
	input logic [0:3]  fw_uid_ep_02, fw_uid_ep_03, fw_uid_ep_04, fw_uid_ep_05, fw_uid_ep_06, fw_uid_ep_07,fw_uid_ep_08;
	
	input logic [0:6] fw_op_02_addr,fw_op_03_addr,fw_op_04_addr,fw_op_05_addr,fw_op_06_addr,fw_op_07_addr,out_op_rt_addr;
	input logic [0:127] fw_op_02_data,fw_op_03_data,fw_op_04_data,fw_op_05_data,fw_op_06_data,fw_op_07_data,out_op_rt_data;
	input logic [0:3] fw_uid_op_02,fw_uid_op_03,fw_uid_op_04,fw_uid_op_05,fw_uid_op_06,fw_uid_op_07,fw_uid_op_08;

	input  logic wr_en_op_02,wr_en_op_03,wr_en_op_04,wr_en_op_05,wr_en_op_06,wr_en_op_07,out_op_wr_en_rt;
	input  logic wr_en_ep_01,wr_en_ep_02,wr_en_ep_03,wr_en_ep_04,wr_en_ep_05,wr_en_ep_06,wr_en_ep_07,out_ep_wr_en_rt;
	
	output logic [0:127] ra_fw_data_ep,rb_fw_data_ep,rc_fw_data_ep, ra_fw_data_op,rb_fw_data_op,rc_fw_data_op; 
	output logic [0:31] pc_out;
	logic flush_r;
	
	always_ff @(posedge clock) begin
		//flush_r <= flush;
		if(reset == 1 || flush == 1)begin
			opcode_ep_r  <= NOP_EXEC;
			ra_addr_ep_r <= 0;
	        rb_addr_ep_r <= 0;
			rc_addr_ep_r <= 0;
			rt_addr_ep_r <= 0;
			I7_ep_r		 <= 0;
			I10_ep_r     <= 0;
			I16_ep_r     <= 0;
			I18_ep_r     <= 0;
			
			//opcode_op_r  <= NOP_EXEC; //Change 
			opcode_op_r  <= NOP_LOAD;	
			ra_addr_op_r <= 0;
	        rb_addr_op_r <= 0;
			rc_addr_op_r <= 0;
			rt_addr_op_r <= 0;
			I7_op_r		 <= 0;
			I10_op_r     <= 0;
			I16_op_r     <= 0;
			I18_op_r     <= 0;
			pc_out		 <= 0;
			wr_en_rt_ep_r<= 0;
			wr_en_rt_op_r<= 0;
			ls_wr_en_op_r<= 0;
			clear_r      <= 0;
			
		end
		else begin
			opcode_ep_r  <= opcode_ep;
			ra_addr_ep_r <= ra_addr_ep;
	        rb_addr_ep_r <= rb_addr_ep;
			rc_addr_ep_r <= rc_addr_ep;
			rt_addr_ep_r <= rt_addr_ep;
			I7_ep_r		 <= I7_ep;
			I10_ep_r     <= I10_ep;
			I16_ep_r     <= I16_ep;
			I18_ep_r     <= I18_ep;
		
			opcode_op_r  <= opcode_op;
			ra_addr_op_r <= ra_addr_op;
	        rb_addr_op_r <= rb_addr_op;
	        rc_addr_op_r <= rc_addr_op;
			rt_addr_op_r <= rt_addr_op;
			I7_op_r		 <= I7_op;
			I10_op_r     <= I10_op;
			I16_op_r     <= I16_op;
			I18_op_r     <= I18_op;
			pc_out		 <= pc;
			wr_en_rt_ep_r<= wr_en_rt_ep;
			wr_en_rt_op_r<= wr_en_rt_op;
			ls_wr_en_op_r<= ls_wr_en_op;
			clear_r      <= clear;
		
		end
		
	
	
	end		
	
	always_comb begin
	
		if 		((ra_addr_ep_r == fw_ep_03_addr) && (fw_uid_ep_03 == UNIT_1) && wr_en_ep_03 == 1) ra_fw_data_ep = fw_ep_03_data;
		else if ((ra_addr_ep_r == fw_ep_04_addr) && ((fw_uid_ep_04 == UNIT_1) || fw_uid_ep_04 == UNIT_2 || fw_uid_ep_04 == UNIT_5) && wr_en_ep_04 == 1) ra_fw_data_ep = fw_ep_04_data;
		else if ((ra_addr_ep_r == fw_ep_05_addr) && ((fw_uid_ep_05 == UNIT_1) || fw_uid_ep_05 == UNIT_2 || fw_uid_ep_05 == UNIT_5) && wr_en_ep_05 == 1) ra_fw_data_ep = fw_ep_05_data;
		else if ((ra_addr_ep_r == fw_ep_06_addr) && ((fw_uid_ep_06 == UNIT_1) || fw_uid_ep_06 == UNIT_2 || fw_uid_ep_06 == UNIT_5) && wr_en_ep_06 == 1) ra_fw_data_ep = fw_ep_06_data;
		else if ((ra_addr_ep_r == fw_ep_07_addr) && ((fw_uid_ep_07 == UNIT_1) || fw_uid_ep_07 == UNIT_2 || fw_uid_ep_07 == UNIT_3 || fw_uid_ep_07 == UNIT_5) && wr_en_ep_07 == 1)  ra_fw_data_ep = fw_ep_07_data;
		else if ((ra_addr_ep_r == out_ep_rt_addr) && ((fw_uid_ep_08 == UNIT_1) || fw_uid_ep_08 == UNIT_2 || fw_uid_ep_08 == UNIT_3 || fw_uid_ep_08 == UNIT_5 || fw_uid_ep_08 == UNIT_4) && out_ep_wr_en_rt == 1)  ra_fw_data_ep = out_ep_rt_data;
		else if ((ra_addr_ep_r == fw_op_04_addr)  && (fw_uid_op_04 == UNIT_6) && wr_en_op_04 == 1) ra_fw_data_ep = fw_op_04_data;
		else if ((ra_addr_ep_r == fw_op_05_addr)  && (fw_uid_op_05 == UNIT_6) && wr_en_op_05 == 1) ra_fw_data_ep = fw_op_05_data;
		else if ((ra_addr_ep_r == fw_op_06_addr)  && (fw_uid_op_06 == UNIT_6) && wr_en_op_06 == 1) ra_fw_data_ep = fw_op_06_data;
		else if ((ra_addr_ep_r == fw_op_07_addr)  && (fw_uid_op_07 == UNIT_6 || fw_uid_op_07 == UNIT_7) && wr_en_op_07 == 1) ra_fw_data_ep = fw_op_07_data;
		else if ((ra_addr_ep_r == out_op_rt_addr)  && (fw_uid_op_08 == UNIT_6 || fw_uid_op_08 == UNIT_7) && out_op_wr_en_rt == 1) ra_fw_data_ep = out_op_rt_data;
		else ra_fw_data_ep = ra_rf_data_ep;
		
		
		if 		((rb_addr_ep_r == fw_ep_03_addr) && (fw_uid_ep_03 == UNIT_1) && wr_en_ep_03 == 1) rb_fw_data_ep = fw_ep_03_data;
		else if ((rb_addr_ep_r == fw_ep_04_addr) && ((fw_uid_ep_04 == UNIT_1) || fw_uid_ep_04 == UNIT_2 || fw_uid_ep_04 == UNIT_5) && wr_en_ep_04 == 1) rb_fw_data_ep = fw_ep_04_data;
		else if ((rb_addr_ep_r == fw_ep_05_addr) && ((fw_uid_ep_05 == UNIT_1) || fw_uid_ep_05 == UNIT_2 || fw_uid_ep_05 == UNIT_5) && wr_en_ep_05 == 1) rb_fw_data_ep = fw_ep_05_data;
		else if ((rb_addr_ep_r == fw_ep_06_addr) && ((fw_uid_ep_06 == UNIT_1) || fw_uid_ep_06 == UNIT_2 || fw_uid_ep_06 == UNIT_5) && wr_en_ep_06 == 1) rb_fw_data_ep = fw_ep_06_data;
		else if ((rb_addr_ep_r == fw_ep_07_addr) && ((fw_uid_ep_07 == UNIT_1) || fw_uid_ep_07 == UNIT_2 || fw_uid_ep_07 == UNIT_3 || fw_uid_ep_07 == UNIT_5) && wr_en_ep_07 == 1)  rb_fw_data_ep = fw_ep_07_data;
		else if ((rb_addr_ep_r == out_ep_rt_addr) && ((fw_uid_ep_08 == UNIT_1) || fw_uid_ep_08 == UNIT_2 || fw_uid_ep_08 == UNIT_3 || fw_uid_ep_08 == UNIT_5 || fw_uid_ep_08 == UNIT_4) && out_ep_wr_en_rt == 1)  rb_fw_data_ep = out_ep_rt_data;
		else if ((rb_addr_ep_r == fw_op_04_addr)  && (fw_uid_op_04 == UNIT_6) && wr_en_op_04 == 1) rb_fw_data_ep = fw_op_04_data;
		else if ((rb_addr_ep_r == fw_op_05_addr)  && (fw_uid_op_05 == UNIT_6) && wr_en_op_05 == 1) rb_fw_data_ep = fw_op_05_data;
		else if ((rb_addr_ep_r == fw_op_06_addr)  && (fw_uid_op_06 == UNIT_6) && wr_en_op_06 == 1) rb_fw_data_ep = fw_op_06_data;
		else if ((rb_addr_ep_r == fw_op_07_addr)  && (fw_uid_op_07 == UNIT_6 || fw_uid_op_07 == UNIT_7) && wr_en_op_07 == 1) rb_fw_data_ep = fw_op_07_data;
		else if ((rb_addr_ep_r == out_op_rt_addr)  && (fw_uid_op_08 == UNIT_6 || fw_uid_op_08 == UNIT_7) && out_op_wr_en_rt == 1) rb_fw_data_ep = out_op_rt_data;
		else rb_fw_data_ep = rb_rf_data_ep;
		
		if 		((rc_addr_ep_r == fw_ep_03_addr) && (fw_uid_ep_03 == UNIT_1) && wr_en_ep_03 == 1) rc_fw_data_ep = fw_ep_03_data;
		else if ((rc_addr_ep_r == fw_ep_04_addr) && ((fw_uid_ep_04 == UNIT_1) || fw_uid_ep_04 == UNIT_2 || fw_uid_ep_04 == UNIT_5) && wr_en_ep_04 == 1) rc_fw_data_ep = fw_ep_04_data;
		else if ((rc_addr_ep_r == fw_ep_05_addr) && ((fw_uid_ep_05 == UNIT_1) || fw_uid_ep_05 == UNIT_2 || fw_uid_ep_05 == UNIT_5) && wr_en_ep_05 == 1) rc_fw_data_ep = fw_ep_05_data;
		else if ((rc_addr_ep_r == fw_ep_06_addr) && ((fw_uid_ep_06 == UNIT_1) || fw_uid_ep_06 == UNIT_2 || fw_uid_ep_06 == UNIT_5) && wr_en_ep_06 == 1) rc_fw_data_ep = fw_ep_06_data;
		else if ((rc_addr_ep_r == fw_ep_07_addr) && ((fw_uid_ep_07 == UNIT_1) || fw_uid_ep_07 == UNIT_2 || fw_uid_ep_07 == UNIT_3 || fw_uid_ep_07 == UNIT_5) && wr_en_ep_07 == 1)  rc_fw_data_ep = fw_ep_07_data;
		else if ((rc_addr_ep_r == out_ep_rt_addr) && ((fw_uid_ep_08 == UNIT_1) || fw_uid_ep_08 == UNIT_2 || fw_uid_ep_08 == UNIT_3 || fw_uid_ep_08 == UNIT_5 || fw_uid_ep_08 == UNIT_4) && out_ep_wr_en_rt == 1)  rc_fw_data_ep = out_ep_rt_data;
		else if ((rc_addr_ep_r == fw_op_04_addr)  && (fw_uid_op_04 == UNIT_6) && wr_en_op_04 == 1) rc_fw_data_ep = fw_op_04_data;
		else if ((rc_addr_ep_r == fw_op_05_addr)  && (fw_uid_op_05 == UNIT_6) && wr_en_op_05 == 1) rc_fw_data_ep = fw_op_05_data;
		else if ((rc_addr_ep_r == fw_op_06_addr)  && (fw_uid_op_06 == UNIT_6) && wr_en_op_06 == 1) rc_fw_data_ep = fw_op_06_data;
		else if ((rc_addr_ep_r == fw_op_07_addr)  && (fw_uid_op_07 == UNIT_6 || fw_uid_op_07 == UNIT_7) && wr_en_op_07 == 1) rc_fw_data_ep = fw_op_07_data;
		else if ((rc_addr_ep_r == out_op_rt_addr)  && (fw_uid_op_08 == UNIT_6 || fw_uid_op_08 == UNIT_7) && out_op_wr_en_rt == 1) rc_fw_data_ep = out_op_rt_data;
		else rc_fw_data_ep = rc_rf_data_ep;
		
		
		if 		((ra_addr_op_r == fw_ep_03_addr) && (fw_uid_ep_03 == UNIT_1) && wr_en_ep_03 == 1) ra_fw_data_op = fw_ep_03_data;
		else if ((ra_addr_op_r == fw_ep_04_addr) && ((fw_uid_ep_04 == UNIT_1) || fw_uid_ep_04 == UNIT_2 || fw_uid_ep_04 == UNIT_5) && wr_en_ep_04 == 1) ra_fw_data_op = fw_ep_04_data;
		else if ((ra_addr_op_r == fw_ep_05_addr) && ((fw_uid_ep_05 == UNIT_1) || fw_uid_ep_05 == UNIT_2 || fw_uid_ep_05 == UNIT_5) && wr_en_ep_05 == 1) ra_fw_data_op = fw_ep_05_data;
		else if ((ra_addr_op_r == fw_ep_06_addr) && ((fw_uid_ep_06 == UNIT_1) || fw_uid_ep_06 == UNIT_2 || fw_uid_ep_06 == UNIT_5) && wr_en_ep_06 == 1) ra_fw_data_op = fw_ep_06_data;
		else if ((ra_addr_op_r == fw_ep_07_addr) && ((fw_uid_ep_07 == UNIT_1) || fw_uid_ep_07 == UNIT_2 || fw_uid_ep_07 == UNIT_3 || fw_uid_ep_07 == UNIT_5) && wr_en_ep_07 == 1)  ra_fw_data_op = fw_ep_07_data;
		else if ((ra_addr_op_r == out_op_rt_addr) && ((fw_uid_ep_08 == UNIT_1) || fw_uid_ep_08 == UNIT_2 || fw_uid_ep_08 == UNIT_3 || fw_uid_ep_08 == UNIT_5 || fw_uid_ep_08 == UNIT_4) && out_ep_wr_en_rt == 1)  ra_fw_data_op = out_op_rt_data;
		else if ((ra_addr_op_r == fw_op_04_addr)  && (fw_uid_op_04 == UNIT_6) && wr_en_op_04 == 1) ra_fw_data_op = fw_op_04_data;
		else if ((ra_addr_op_r == fw_op_05_addr)  && (fw_uid_op_05 == UNIT_6) && wr_en_op_05 == 1) ra_fw_data_op = fw_op_05_data;
		else if ((ra_addr_op_r == fw_op_06_addr)  && (fw_uid_op_06 == UNIT_6) && wr_en_op_06 == 1) ra_fw_data_op = fw_op_06_data;
		else if ((ra_addr_op_r == fw_op_07_addr)  && (fw_uid_op_07 == UNIT_6 || fw_uid_op_07 == UNIT_7) && wr_en_op_07 == 1) ra_fw_data_op = fw_op_07_data;
		else if ((ra_addr_op_r == out_op_rt_addr)  && (fw_uid_op_08 == UNIT_6 || fw_uid_op_08 == UNIT_7) && out_op_wr_en_rt == 1) ra_fw_data_op = out_op_rt_data;
		else ra_fw_data_op = ra_rf_data_op;
		
		if 		((rb_addr_op_r == fw_ep_03_addr) && (fw_uid_ep_03 == UNIT_1) && wr_en_ep_03 == 1) rb_fw_data_op = fw_ep_03_data;
		else if ((rb_addr_op_r == fw_ep_04_addr) && ((fw_uid_ep_04 == UNIT_1) || fw_uid_ep_04 == UNIT_2 || fw_uid_ep_04 == UNIT_5) && wr_en_ep_04 == 1) rb_fw_data_op = fw_ep_04_data;
		else if ((rb_addr_op_r == fw_ep_05_addr) && ((fw_uid_ep_05 == UNIT_1) || fw_uid_ep_05 == UNIT_2 || fw_uid_ep_05 == UNIT_5) && wr_en_ep_05 == 1) rb_fw_data_op = fw_ep_05_data;
		else if ((rb_addr_op_r == fw_ep_06_addr) && ((fw_uid_ep_06 == UNIT_1) || fw_uid_ep_06 == UNIT_2 || fw_uid_ep_06 == UNIT_5) && wr_en_ep_06 == 1) rb_fw_data_op = fw_ep_06_data;
		else if ((rb_addr_op_r == fw_ep_07_addr) && ((fw_uid_ep_07 == UNIT_1) || fw_uid_ep_07 == UNIT_2 || fw_uid_ep_07 == UNIT_3 || fw_uid_ep_07 == UNIT_5) && wr_en_ep_07 == 1)  rb_fw_data_op = fw_ep_07_data;
		else if ((rb_addr_op_r == out_op_rt_addr) && ((fw_uid_ep_08 == UNIT_1) || fw_uid_ep_08 == UNIT_2 || fw_uid_ep_08 == UNIT_3 || fw_uid_ep_08 == UNIT_5 || fw_uid_ep_08 == UNIT_4) && out_ep_wr_en_rt == 1)  rb_fw_data_op = out_op_rt_data;
		else if ((rb_addr_op_r == fw_op_04_addr)  && (fw_uid_op_04 == UNIT_6) && wr_en_op_04 == 1) rb_fw_data_op = fw_op_04_data;
		else if ((rb_addr_op_r == fw_op_05_addr)  && (fw_uid_op_05 == UNIT_6) && wr_en_op_05 == 1) rb_fw_data_op = fw_op_05_data;
		else if ((rb_addr_op_r == fw_op_06_addr)  && (fw_uid_op_06 == UNIT_6) && wr_en_op_06 == 1) rb_fw_data_op = fw_op_06_data;
		else if ((rb_addr_op_r == fw_op_07_addr)  && (fw_uid_op_07 == UNIT_6 || fw_uid_op_07 == UNIT_7) && wr_en_op_07 == 1) rb_fw_data_op = fw_op_07_data;
		else if ((rb_addr_op_r == out_op_rt_addr)  && (fw_uid_op_08 == UNIT_6 || fw_uid_op_08 == UNIT_7) && out_op_wr_en_rt == 1) rb_fw_data_op = out_op_rt_data;
		else rb_fw_data_op = rb_rf_data_op;
		
		
		if 		((rc_addr_op_r == fw_ep_03_addr) && (fw_uid_ep_03 == UNIT_1) && wr_en_ep_03 == 1) rc_fw_data_op = fw_ep_03_data;
		else if ((rc_addr_op_r == fw_ep_04_addr) && ((fw_uid_ep_04 == UNIT_1) || fw_uid_ep_04 == UNIT_2 || fw_uid_ep_04 == UNIT_5) && wr_en_ep_04 == 1) rc_fw_data_op = fw_ep_04_data;
		else if ((rc_addr_op_r == fw_ep_05_addr) && ((fw_uid_ep_05 == UNIT_1) || fw_uid_ep_05 == UNIT_2 || fw_uid_ep_05 == UNIT_5) && wr_en_ep_05 == 1) rc_fw_data_op = fw_ep_05_data;
		else if ((rc_addr_op_r == fw_ep_06_addr) && ((fw_uid_ep_06 == UNIT_1) || fw_uid_ep_06 == UNIT_2 || fw_uid_ep_06 == UNIT_5) && wr_en_ep_06 == 1) rc_fw_data_op = fw_ep_06_data;
		else if ((rc_addr_op_r == fw_ep_07_addr) && ((fw_uid_ep_07 == UNIT_1) || fw_uid_ep_07 == UNIT_2 || fw_uid_ep_07 == UNIT_3 || fw_uid_ep_07 == UNIT_5) && wr_en_ep_07 == 1)  rc_fw_data_op = fw_ep_07_data;
		else if ((rc_addr_op_r == out_op_rt_addr) && ((fw_uid_ep_08 == UNIT_1) || fw_uid_ep_08 == UNIT_2 || fw_uid_ep_08 == UNIT_3 || fw_uid_ep_08 == UNIT_5 || fw_uid_ep_08 == UNIT_4) && out_ep_wr_en_rt == 1)  rc_fw_data_op = out_op_rt_data;
		else if ((rc_addr_op_r == fw_op_04_addr)  && (fw_uid_op_04 == UNIT_6) && wr_en_op_04 == 1) rc_fw_data_op = fw_op_04_data;
		else if ((rc_addr_op_r == fw_op_05_addr)  && (fw_uid_op_05 == UNIT_6) && wr_en_op_05 == 1) rc_fw_data_op = fw_op_05_data;
		else if ((rc_addr_op_r == fw_op_06_addr)  && (fw_uid_op_06 == UNIT_6) && wr_en_op_06 == 1) rc_fw_data_op = fw_op_06_data;
		else if ((rc_addr_op_r == fw_op_07_addr)  && (fw_uid_op_07 == UNIT_6 || fw_uid_op_07 == UNIT_7) && wr_en_op_07 == 1) rc_fw_data_op = fw_op_07_data;
		else if ((rc_addr_op_r == out_op_rt_addr)  && (fw_uid_op_08 == UNIT_6 || fw_uid_op_08 == UNIT_7) && out_op_wr_en_rt == 1) rc_fw_data_op = out_op_rt_data;
		else rc_fw_data_op = rc_rf_data_op;
		
		
	end
	
endmodule


import definitions::*;


module topmodule_part2(clock,reset);

	input clock,reset;	
	opcode opcode_ep;
	
	logic ls_wr_en_op_in;
	
	
	logic [0:31] pc_out;
	
	logic flush,flush_fetch;
	logic [0:127] ra_rf_data_ep, rb_rf_data_ep, rc_rf_data_ep, ra_rf_data_op, rb_rf_data_op,rc_rf_data_op;//DRO
	opcode opcode_ep_r, opcode_op_r;
	logic [0:6] I7_ep_r, I7_op_r;
	logic [0:9] I10_ep_r, I10_op_r;
	logic [0:15] I16_ep_r, I16_op_r;
	logic [0:17] I18_ep_r, I18_op_r;
	logic [0:3] fw_uid_ep_02, fw_uid_ep_03, fw_uid_ep_04, fw_uid_ep_05, fw_uid_ep_06, fw_uid_ep_07,fw_uid_ep_08; //DRO
	logic [0:127] fw_ep_02_data, fw_ep_03_data, fw_ep_04_data, fw_ep_05_data, fw_ep_06_data, fw_ep_07_data; //DRO
	
	logic [0:3] fw_uid_op_02, fw_uid_op_03, fw_uid_op_04, fw_uid_op_05, fw_uid_op_06, fw_uid_op_07,fw_uid_op_08; //DRO
	logic [0:127] fw_op_02_data, fw_op_03_data, fw_op_04_data, fw_op_05_data, fw_op_06_data, fw_op_07_data; //DRO
	
	logic [0:31] pc_r;
	
	logic [0:127] ra_fw_data_ep, rb_fw_data_ep, rc_fw_data_ep, ra_fw_data_op, rb_fw_data_op,rc_fw_data_op; //DRO
	logic wr_en_rt_ep_r, wr_en_rt_op_r;
	logic [0:127] out_ep_rt_data,out_op_rt_data; //DRO
	logic out_ep_wr_en_rt, out_op_wr_en_rt; //DRO
	logic [0:3] fw_ep_01_lat, fw_ep_02_lat, fw_ep_03_lat, fw_ep_04_lat, fw_ep_05_lat, fw_ep_06_lat, fw_ep_07_lat;
	logic [0:3] fw_op_01_lat, fw_op_02_lat, fw_op_03_lat, fw_op_04_lat, fw_op_05_lat, fw_op_06_lat, fw_op_07_lat;
	logic [0:127] ls_data_rd_in,ls_data_out; // DRO
	logic [0:14]  ls_addr_rd_out; //DRO
	logic ls_wr_en_op_r,ls_wr_en_op;
	logic [0:6] rt_addr_ep_r,rt_addr_op_r;
	logic [0:6] rt_addr_in;
	
	
	logic wr_en_op_01,wr_en_op_02,wr_en_op_03,wr_en_op_04,wr_en_op_05,wr_en_op_06,wr_en_op_07;
	logic wr_en_ep_01,wr_en_ep_02,wr_en_ep_03,wr_en_ep_04,wr_en_ep_05,wr_en_ep_06,wr_en_ep_07;
	
	
	//Debug
	logic [0:127]reg_file_mem [128];
	logic [0:7] ls_mem [LS_SIZE];
	logic [0:31] rep_left_Bit_32_I10;
	
	
	logic stall; 
	logic [0:31] pc_out_fetch;
	logic [0:31] ins1, ins2;
	logic [0:31] pc_in;
	logic clear;
	logic [0:6] I7_ep;
	logic [0:9] I10_ep;
	logic [0:15]I16_ep;
	logic [0:17]I18_ep;
	logic wr_en_rt_ep;
	opcode opcode_op;
	//input [0:31]pc_op; 
	logic [0:6] I7_op;
	logic [0:9] I10_op;
	logic [0:15]I16_op;
	logic [0:17]I18_op;
	logic wr_en_rt_op;
	logic [0:6] ra_addr_ep;
	logic [0:6] rb_addr_ep;
	logic [0:6] rc_addr_ep;
	logic [0:6] rt_addr_ep;
	logic [0:6] ra_addr_op;
	logic [0:6] rb_addr_op,rc_addr_op;
	logic [0:6] rt_addr_op;
	logic [0:6] fw_ep_01_addr,fw_ep_02_addr,fw_ep_03_addr,fw_ep_04_addr,fw_ep_05_addr,fw_ep_06_addr,fw_ep_07_addr,out_ep_rt_addr;
	logic [0:6] fw_op_01_addr,fw_op_02_addr,fw_op_03_addr,fw_op_04_addr,fw_op_05_addr,fw_op_06_addr,fw_op_07_addr,out_op_rt_addr;
	logic [0:6] ra_addr_ep_r;
	logic [0:6] rb_addr_ep_r;
	logic [0:6] rc_addr_ep_r;
	logic [0:6] ra_addr_op_r;
	logic [0:6] rb_addr_op_r;
	logic [0:6] rc_addr_op_r;
		
	fetch	fetch1(.clock(clock),
			.reset(reset),
			.stall(stall),
			.flush(flush),
			.pc_in(pc_out),
			.pc_out(pc_out_fetch),
			.ins1(ins1),
			.ins2(ins2),
			.flush_fetch(flush_fetch)
			);
	decode	decode1(.clock(clock),
			.reset(reset),
			.pc_in(pc_out_fetch),
			.ins1(ins1),
			.ins2(ins2),
			.flush_fetch(flush_fetch),
			.flush(flush),
			.pc_out(pc_in),
			.opcode_ep(opcode_ep),
			.I7_ep(I7_ep),
			.I10_ep(I10_ep),
			.I16_ep(I16_ep),
			.I18_ep(I18_ep),
			.wr_en_rt_ep(wr_en_rt_ep),
			.opcode_op(opcode_op),
			.I7_op(I7_op),
			.I10_op(I10_op),
			.I16_op(I16_op),
			.I18_op(I18_op),
			.wr_en_rt_op(wr_en_rt_op),
			.ra_addr_ep(ra_addr_ep),
			.rb_addr_ep(rb_addr_ep),
			.rc_addr_ep(rc_addr_ep),
			.rt_addr_ep(rt_addr_ep),
			.ra_addr_op(ra_addr_op),
			.rb_addr_op(rb_addr_op),
			.rc_addr_op(rc_addr_op),
			.rt_addr_op(rt_addr_op),
			.clear(clear),
			.fw_ep_01_addr(fw_ep_01_addr),
			.fw_ep_02_addr(fw_ep_02_addr),
			.fw_ep_03_addr(fw_ep_03_addr),
			.fw_ep_04_addr(fw_ep_04_addr),
			.fw_ep_05_addr(fw_ep_05_addr),
			.fw_ep_06_addr(fw_ep_06_addr),
			.fw_ep_07_addr(fw_ep_07_addr),
			.out_ep_rt_addr(out_ep_rt_addr),
			.fw_op_01_addr(fw_op_01_addr),
			.fw_op_02_addr(fw_op_02_addr),
			.fw_op_03_addr(fw_op_03_addr),
			.fw_op_04_addr(fw_op_04_addr),
			.fw_op_05_addr(fw_op_05_addr),
			.fw_op_06_addr(fw_op_06_addr),
			.fw_op_07_addr(fw_op_07_addr),
			.out_op_rt_addr(out_op_rt_addr),
			.rf_addr_ep_r(rt_addr_ep_r),
			.rf_addr_op_r(rt_addr_op_r),
			.wr_en_rt_ep_r(wr_en_rt_ep_r), 
			.wr_en_rt_op_r(wr_en_rt_op_r),
			.wr_en_ep_01(wr_en_ep_01),
			.wr_en_ep_02(wr_en_ep_02),
			.wr_en_ep_03(wr_en_ep_03),
			.wr_en_ep_04(wr_en_ep_04),
			.wr_en_ep_05(wr_en_ep_05),
			.wr_en_ep_06(wr_en_ep_06),
			.wr_en_ep_07(wr_en_ep_07),
			.wr_en_op_01(wr_en_op_01),
			.wr_en_op_02(wr_en_op_02),
			.wr_en_op_03(wr_en_op_03),
			.wr_en_op_04(wr_en_op_04),
			.wr_en_op_05(wr_en_op_05),
			.wr_en_op_06(wr_en_op_06),
			.fw_uid_ep_02(fw_uid_ep_02),
			.fw_uid_ep_03(fw_uid_ep_03),
			.fw_uid_ep_04(fw_uid_ep_04),
			.fw_uid_ep_05(fw_uid_ep_05),
			.fw_uid_ep_06(fw_uid_ep_06),
			.fw_uid_ep_07(fw_uid_ep_07),
			.fw_uid_op_02(fw_uid_op_02),
			.fw_uid_op_03(fw_uid_op_03),
			.fw_uid_op_04(fw_uid_op_04),
			.fw_uid_op_05(fw_uid_op_05),
			.fw_uid_op_06(fw_uid_op_06),
			.fw_uid_op_07(fw_uid_op_07), 
			.stall(stall)
 
);

	rf_fw rf1(	.clock(clock),
				.reset(reset),
				.clear(clear),
				.wr_en_rt_ep(wr_en_rt_ep),
				.wr_en_rt_op(wr_en_rt_op),
				.ls_wr_en_op(ls_wr_en_op_in),
				.flush(flush),
				.pc(pc_in),
				.opcode_ep(opcode_ep),
				.ra_addr_ep_r(ra_addr_ep_r),
				.rb_addr_ep_r(rb_addr_ep_r),
				.rc_addr_ep_r(rc_addr_ep_r),
				.ra_addr_op_r(ra_addr_op_r),
				.rb_addr_op_r(rb_addr_op_r),
				.rc_addr_op_r(rc_addr_op_r),
				.ra_addr_ep(ra_addr_ep),
				.rb_addr_ep(rb_addr_ep),
				.rc_addr_ep(rc_addr_ep),
				.rt_addr_ep(rt_addr_ep),
				.I7_ep(I7_ep),
				.I10_ep(I10_ep),
				.I16_ep(I16_ep),
				.I18_ep(I18_ep),
				.opcode_op(opcode_op),
				.ra_addr_op(ra_addr_op),
				.rb_addr_op(rb_addr_op),
				.rc_addr_op(rc_addr_op),
				.rt_addr_op(rt_addr_op),
				.I7_op(I7_op),
				.I10_op(I10_op),
				.I16_op(I16_op),
				.I18_op(I18_op),
				.ra_rf_data_ep(ra_rf_data_ep),
				.rb_rf_data_ep(rb_rf_data_ep),
				.rc_rf_data_ep(rc_rf_data_ep), 
				.ra_rf_data_op(ra_rf_data_op),
				.rb_rf_data_op(rb_rf_data_op),
				.rc_rf_data_op(rc_rf_data_op),
				.opcode_ep_r(opcode_ep_r), 
				.rt_addr_ep_r(rt_addr_ep_r),
				.I7_ep_r(I7_ep_r),
				.I10_ep_r(I10_ep_r),
				.I16_ep_r(I16_ep_r),
				.I18_ep_r(I18_ep_r),
				.opcode_op_r(opcode_op_r),
				.rt_addr_op_r(rt_addr_op_r),
				.I7_op_r(I7_op_r),
				.I10_op_r(I10_op_r),
				.I16_op_r(I16_op_r),
				.I18_op_r(I18_op_r),
				.fw_ep_02_addr(fw_ep_02_addr),
				.fw_ep_03_addr(fw_ep_03_addr),
				.fw_ep_04_addr(fw_ep_04_addr),
				.fw_ep_05_addr(fw_ep_05_addr),
				.fw_ep_06_addr(fw_ep_06_addr),
				.fw_ep_07_addr(fw_ep_07_addr),
				.out_ep_rt_addr(out_ep_rt_addr),
				.fw_ep_02_data(fw_ep_02_data),
				.fw_ep_03_data(fw_ep_03_data),
				.fw_ep_04_data(fw_ep_04_data),
				.fw_ep_05_data(fw_ep_05_data),
				.fw_ep_06_data(fw_ep_06_data),
				.fw_ep_07_data(fw_ep_07_data),
				.out_ep_rt_data(out_ep_rt_data),
				.fw_uid_ep_02(fw_uid_ep_02),
				.fw_uid_ep_03(fw_uid_ep_03),
				.fw_uid_ep_04(fw_uid_ep_04),
				.fw_uid_ep_05(fw_uid_ep_05),
				.fw_uid_ep_06(fw_uid_ep_06),
				.fw_uid_ep_07(fw_uid_ep_07),
				.fw_uid_ep_08(fw_uid_ep_08),
				.fw_op_02_addr(fw_op_02_addr),
				.fw_op_03_addr(fw_op_03_addr),
				.fw_op_04_addr(fw_op_04_addr),
				.fw_op_05_addr(fw_op_05_addr),
				.fw_op_06_addr(fw_op_06_addr),
				.fw_op_07_addr(fw_op_07_addr),
				.out_op_rt_addr(out_op_rt_addr),
				.fw_op_02_data(fw_op_02_data),
				.fw_op_03_data(fw_op_03_data),
				.fw_op_04_data(fw_op_04_data),
				.fw_op_05_data(fw_op_05_data),
				.fw_op_06_data(fw_op_06_data),
				.fw_op_07_data(fw_op_07_data),
				.out_op_rt_data(out_op_rt_data),
				.fw_uid_op_02(fw_uid_op_02),
				.fw_uid_op_03(fw_uid_op_03),
				.fw_uid_op_04(fw_uid_op_04),
				.fw_uid_op_05(fw_uid_op_05),
				.fw_uid_op_06(fw_uid_op_06),
				.fw_uid_op_07(fw_uid_op_07),
				.fw_uid_op_08(fw_uid_op_08), 				
				.ra_fw_data_ep(ra_fw_data_ep),
				.rb_fw_data_ep(rb_fw_data_ep),
				.rc_fw_data_ep(rc_fw_data_ep),
				.ra_fw_data_op(ra_fw_data_op),
				.rb_fw_data_op(rb_fw_data_op),
				.rc_fw_data_op(rc_fw_data_op),
				.pc_out(pc_r),
				.wr_en_rt_ep_r(wr_en_rt_ep_r),
				.wr_en_rt_op_r(wr_en_rt_op_r),
				.ls_wr_en_op_r(ls_wr_en_op_r),
				.wr_en_op_02(wr_en_op_02),
				.wr_en_op_03(wr_en_op_03),
				.wr_en_op_04(wr_en_op_04),
				.wr_en_op_05(wr_en_op_05),
				.wr_en_op_06(wr_en_op_06),
				.wr_en_op_07(wr_en_op_07),
				.wr_en_ep_01(wr_en_ep_01),
				.wr_en_ep_02(wr_en_ep_02),
				.wr_en_ep_03(wr_en_ep_03),
				.wr_en_ep_04(wr_en_ep_04),
				.wr_en_ep_05(wr_en_ep_05),
				.wr_en_ep_06(wr_en_ep_06),
				.wr_en_ep_07(wr_en_ep_07),
				.out_ep_wr_en_rt(out_ep_wr_en_rt),
				.out_op_wr_en_rt(out_op_wr_en_rt),
				.clear_r(clear_r));
	
	even_pipe e1(.clock(clock),
				.reset(reset),
				.clear_in(clear_r),
				.rt_addr_in(rt_addr_ep_r), 
				.flush_in(flush), 
				.opcode_ep_in(opcode_ep_r),
				.ra_in(ra_fw_data_ep),
				.rb_in(rb_fw_data_ep),
				.rc_in(rc_fw_data_ep),
				.I7_in(I7_ep_r),
				.I10_in(I10_ep_r),
				.I16_in(I16_ep_r),
				.I18_in(I18_ep_r),
				.wr_en_rt_in(wr_en_rt_ep_r),
				.rt_addr(fw_ep_01_addr),
				.fw_ep_02_addr(fw_ep_02_addr),
				.fw_ep_03_addr(fw_ep_03_addr),
				.fw_ep_04_addr(fw_ep_04_addr),
				.fw_ep_05_addr(fw_ep_05_addr),
				.fw_ep_06_addr(fw_ep_06_addr),
				.fw_ep_07_addr(fw_ep_07_addr),
				.out_ep_rt_addr(out_ep_rt_addr),
				.fw_ep_02_data(fw_ep_02_data),
				.fw_ep_03_data(fw_ep_03_data),
				.fw_ep_04_data(fw_ep_04_data),
				.fw_ep_05_data(fw_ep_05_data),
				.fw_ep_06_data(fw_ep_06_data),
				.fw_ep_07_data(fw_ep_07_data), 
				.out_ep_rt_data(out_ep_rt_data),
				.out_ep_wr_en_rt(out_ep_wr_en_rt),
				.uid_ep_02(fw_uid_ep_02), 
				.uid_ep_03(fw_uid_ep_03), 
				.uid_ep_04(fw_uid_ep_04), 
				.uid_ep_05(fw_uid_ep_05), 
				.uid_ep_06(fw_uid_ep_06), 
				.uid_ep_07(fw_uid_ep_07),
				.uid_ep_08(fw_uid_ep_08), 				
				.fw_ep_01_lat(fw_ep_01_lat),
				.fw_ep_02_lat(fw_ep_02_lat),
				.fw_ep_03_lat(fw_ep_03_lat),
				.fw_ep_04_lat(fw_ep_04_lat),
				.fw_ep_05_lat(fw_ep_05_lat),
				.fw_ep_06_lat(fw_ep_06_lat),
				.fw_ep_07_lat(fw_ep_07_lat),
				.wr_en_rt(wr_en_ep_01),
				.wr_en_ep_02(wr_en_ep_02),
				.wr_en_ep_03(wr_en_ep_03),
				.wr_en_ep_04(wr_en_ep_04),
				.wr_en_ep_05(wr_en_ep_05),
				.wr_en_ep_06(wr_en_ep_06),
				.wr_en_ep_07(wr_en_ep_07));
				
	odd_pipe o1(.clock(clock),
				.reset(reset),
				.rt_addr_in(rt_addr_op_r),
				.pc_in(pc_r),
				.opcode_op_in(opcode_op_r),
				.ra_in(ra_fw_data_op),
				.rb_in(rb_fw_data_op),
				.rc_in(rc_fw_data_op),
				.I7_in(I7_op_r),
				.I10_in(I10_op_r),
				.I16_in(I16_op_r),
				.I18_in(I18_op_r),
				.wr_en_rt_in(wr_en_rt_op_r),
				.ls_wr_en_op_in(ls_wr_en_op_r),
				.rt_addr(fw_op_01_addr),
				.fw_op_02_addr(fw_op_02_addr),
				.fw_op_03_addr(fw_op_03_addr),
				.fw_op_04_addr(fw_op_04_addr),
				.fw_op_05_addr(fw_op_05_addr),
				.fw_op_06_addr(fw_op_06_addr),
				.fw_op_07_addr(fw_op_07_addr),
				.out_op_rt_addr(out_op_rt_addr),
				.fw_op_02_data(fw_op_02_data),
				.fw_op_03_data(fw_op_03_data),
				.fw_op_04_data(fw_op_04_data),
				.fw_op_05_data(fw_op_05_data),
				.fw_op_06_data(fw_op_06_data),
				.fw_op_07_data(fw_op_07_data),
				.out_op_rt_data(out_op_rt_data),
				.out_op_wr_en_rt(out_op_wr_en_rt),
				.fw_op_01_lat(fw_op_01_lat),
				.fw_op_02_lat(fw_op_02_lat),
				.fw_op_03_lat(fw_op_03_lat),
				.fw_op_04_lat(fw_op_04_lat),
				.fw_op_05_lat(fw_op_05_lat),
				.fw_op_06_lat(fw_op_06_lat),
				.fw_op_07_lat(fw_op_07_lat),
				.uid_op_02(fw_uid_op_02), 
				.uid_op_03(fw_uid_op_03),
				.uid_op_04(fw_uid_op_04), 
				.uid_op_05(fw_uid_op_05), 
				.uid_op_06(fw_uid_op_06), 
				.uid_op_07(fw_uid_op_07),
				.uid_op_08(fw_uid_op_08),
				.flush(flush), 
				.pc_out(pc_out),
				.ls_data_rd_in(ls_data_rd_in), 
				.ls_data_out(ls_data_out), 
				.ls_addr_rd_out(ls_addr_rd_out),
				.ls_wr_en_op(ls_wr_en_op),
				.wr_en_op_07(wr_en_op_07),
				//Debug
				.rep_left_Bit_32_I10(rep_left_Bit_32_I10),
				.wr_en_rt(wr_en_op_01),
				.wr_en_op_02(wr_en_op_02),
				.wr_en_op_03(wr_en_op_03),
				.wr_en_op_04(wr_en_op_04),
				.wr_en_op_05(wr_en_op_05),
				.wr_en_op_06(wr_en_op_06)
				);
				
	reg_file r1(.clock(clock),
				.reset(reset),
				.ra_addr_ep(ra_addr_ep_r),
				.rb_addr_ep(rb_addr_ep_r),
				.rc_addr_ep(rc_addr_ep_r),
				.ra_addr_op(ra_addr_op_r),
				.rb_addr_op(rb_addr_op_r),
				.rc_addr_op(rc_addr_op_r),
				.rt_addr_ep(out_ep_rt_addr), // RF change
				.rt_addr_op(out_op_rt_addr), // RF change
				.rt_data_ep(out_ep_rt_data), // RF change
				.rt_data_op(out_op_rt_data), // RF change
				.wrbe_ep(out_ep_wr_en_rt),
				.wrbe_op(out_op_wr_en_rt),
				.o_ra_data_ep(ra_rf_data_ep),
				.o_rb_data_ep(rb_rf_data_ep),
				.o_rc_data_ep(rc_rf_data_ep),
				.o_ra_data_op(ra_rf_data_op),
				.o_rb_data_op(rb_rf_data_op),
				.o_rc_data_op(rc_rf_data_op),
				.reg_file_mem(reg_file_mem));// Debug
				
	 local_store l1(.clock(clock),
					.lsa_addr(ls_addr_rd_out),
					.lsa_data_in(ls_data_out),
					.lsa_data_out(ls_data_rd_in),
					.ls_wr_en(ls_wr_en_op),
					.ls_mem(ls_mem));
				
endmodule
				
	



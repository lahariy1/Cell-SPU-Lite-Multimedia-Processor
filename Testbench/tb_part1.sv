
import definitions::*;
module tb_part1();

	logic clock, reset;
	opcode opcode_ep;
	logic ls_wr_en_op_in;
	logic [0:6] I7_ep;
	logic [0:9] I10_ep;
	logic [0:15]I16_ep;
	logic [0:17]I18_ep;
	logic wr_en_rt_ep;
	opcode opcode_op;
	logic [0:6] I7_op;
	logic [0:9] I10_op;
	logic [0:15]I16_op;
	logic [0:17]I18_op;
	logic wr_en_rt_op;
	logic [0:31] pc_in;
	logic [0:6] ra_addr_ep;
	logic [0:6] rb_addr_ep;
	logic [0:6] rc_addr_ep;
	logic [0:6] rt_addr_ep;
	logic [0:6] ra_addr_op;
	logic [0:6] rb_addr_op,rc_addr_op;
	logic [0:6] rt_addr_op;
	logic [0:31] pc_out;
	logic flush;
	
	//Debug
	logic [0:127]reg_file_mem [128];
	logic [0:7] ls_mem [LS_SIZE];
	logic [0:127] out_ep_rt_data,out_op_rt_data; //DRO
	logic [0:127] ls_data_rd_in,ls_data_out; // DRO
	logic [0:14]  ls_addr_rd_out; //DRO
	logic [0:6] out_ep_rt_addr,out_op_rt_addr; // DRO
	logic [0:31] rep_left_Bit_32_I10;
	logic [0:127] ra_rf_data_ep, rb_rf_data_ep, rc_rf_data_ep, ra_rf_data_op, rb_rf_data_op,rc_rf_data_op;
	logic [0:127] ra_fw_data_ep, rb_fw_data_ep, rc_fw_data_ep, ra_fw_data_op, rb_fw_data_op,rc_fw_data_op; //DRO
	logic [0:3] fw_uid_op_02, fw_uid_op_03, fw_uid_op_04, fw_uid_op_05, fw_uid_op_06, fw_uid_op_07; //DRO
	logic [0:3] fw_uid_ep_02, fw_uid_ep_03, fw_uid_ep_04, fw_uid_ep_05, fw_uid_ep_06, fw_uid_ep_07; //DRO
	logic [0:127] fw_ep_02_data, fw_ep_03_data, fw_ep_04_data, fw_ep_05_data, fw_ep_06_data, fw_ep_07_data; //DRO
	logic [0:6] fw_ep_02_addr, fw_ep_03_addr, fw_ep_04_addr, fw_ep_05_addr, fw_ep_06_addr, fw_ep_07_addr; //DRO
	logic [0:127] fw_op_02_data, fw_op_03_data, fw_op_04_data, fw_op_05_data, fw_op_06_data, fw_op_07_data; //DRO
	logic [0:6] fw_op_02_addr, fw_op_03_addr, fw_op_04_addr, fw_op_05_addr, fw_op_06_addr, fw_op_07_addr; //DRO
	logic out_ep_wr_en_rt, out_op_wr_en_rt; //DRO
	
   topmodule_part1 dut(.clock(clock),
					   .reset(reset),
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
					   .pc_in(pc_in),
					   .pc_out(pc_out),
					   .ra_addr_ep(ra_addr_ep),
					   .rb_addr_ep(rb_addr_ep),
					   .rc_addr_ep(rc_addr_ep),
					   .rt_addr_ep(rt_addr_ep),
					   .ra_addr_op(ra_addr_op),
					   .rb_addr_op(rb_addr_op),
					   .rc_addr_op(rc_addr_op),
					   .rt_addr_op(rt_addr_op),
					   .ls_wr_en_op_in(ls_wr_en_op_in),
					   .reg_file_mem(reg_file_mem),
					   .flush(flush),
					   
					   
					   //Debug
					   .ls_mem(ls_mem),
					   .out_ep_rt_data(out_ep_rt_data),
					   .out_op_rt_data(out_op_rt_data),
					   .ls_data_rd_in(ls_data_rd_in),
					   .ls_data_out(ls_data_out),
					   .ls_addr_rd_out(ls_addr_rd_out),
					   .out_ep_rt_addr(out_ep_rt_addr),
					   .out_op_rt_addr(out_op_rt_addr),
					   .rep_left_Bit_32_I10(rep_left_Bit_32_I10),
					   .ra_rf_data_ep(ra_rf_data_ep), 
					   .rb_rf_data_ep(rb_rf_data_ep), 
					   .rc_rf_data_ep(rc_rf_data_ep), 
					   .ra_rf_data_op(ra_rf_data_op), 
					   .rb_rf_data_op(rb_rf_data_op),
					   .rc_rf_data_op(rc_rf_data_op),
					   .ra_fw_data_ep(ra_fw_data_ep), 
					   .rb_fw_data_ep(rb_fw_data_ep), 
					   .rc_fw_data_ep(rc_fw_data_ep), 
					   .ra_fw_data_op(ra_fw_data_op), 
					   .rb_fw_data_op(rb_fw_data_op),
					   .rc_fw_data_op(rc_fw_data_op),
					   .fw_uid_op_02(fw_uid_op_02),
					   .fw_uid_op_03(fw_uid_op_03),
					   .fw_uid_op_04(fw_uid_op_04),
					   .fw_uid_op_05(fw_uid_op_05), 
					   .fw_uid_op_06(fw_uid_op_06), 
					   .fw_uid_op_07(fw_uid_op_07),
					   .fw_uid_ep_02(fw_uid_ep_02), 
					   .fw_uid_ep_03(fw_uid_ep_03), 
					   .fw_uid_ep_04(fw_uid_ep_04), 
					   .fw_uid_ep_05(fw_uid_ep_05), 
					   .fw_uid_ep_06(fw_uid_ep_06), 
					   .fw_uid_ep_07(fw_uid_ep_07),
					   .fw_ep_02_data(fw_ep_02_data), 
					   .fw_ep_03_data(fw_ep_03_data), 
					   .fw_ep_04_data(fw_ep_04_data), 
					   .fw_ep_05_data(fw_ep_05_data), 
					   .fw_ep_06_data(fw_ep_06_data), 
					   .fw_ep_07_data(fw_ep_07_data),
					   .fw_ep_02_addr(fw_ep_02_addr), 
					   .fw_ep_03_addr(fw_ep_03_addr), 
					   .fw_ep_04_addr(fw_ep_04_addr), 
					   .fw_ep_05_addr(fw_ep_05_addr), 
					   .fw_ep_06_addr(fw_ep_06_addr), 
					   .fw_ep_07_addr(fw_ep_07_addr),
					   .fw_op_02_data(fw_op_02_data), 
					   .fw_op_03_data(fw_op_03_data), 
					   .fw_op_04_data(fw_op_04_data), 
					   .fw_op_05_data(fw_op_05_data), 
					   .fw_op_06_data(fw_op_06_data), 
					   .fw_op_07_data(fw_op_07_data),
					   .fw_op_02_addr(fw_op_02_addr), 
					   .fw_op_03_addr(fw_op_03_addr), 
					   .fw_op_04_addr(fw_op_04_addr), 
					   .fw_op_05_addr(fw_op_05_addr), 
					   .fw_op_06_addr(fw_op_06_addr), 
					   .fw_op_07_addr(fw_op_07_addr),
					   .out_ep_wr_en_rt(out_ep_wr_en_rt), 
					   .out_op_wr_en_rt(out_op_wr_en_rt)
					   );
   

   initial clock = 0;
   always #5 clock = ~clock;


	initial begin
		$monitor($time,"ra_rf_data_ep =%h , rb_rf_data_ep =%h,\n rc_rf_data_ep=%h, ra_rf_data_op =%h, rb_rf_data_op=%h\n",ra_rf_data_ep, rb_rf_data_ep, rc_rf_data_ep, ra_rf_data_op, rb_rf_data_op);
		$monitor($time,"fw_uid_op_02=%h, fw_uid_op_03=%h, fw_uid_op_04=%h, fw_uid_op_05=%h, fw_uid_op_06=%h, fw_uid_op_07=%h\n",fw_uid_op_02, fw_uid_op_03, fw_uid_op_04, fw_uid_op_05, fw_uid_op_06, fw_uid_op_07);
		$monitor($time,"fw_uid_ep_02=%h, fw_uid_ep_03=%h, fw_uid_ep_04=%h, fw_uid_ep_05=%h, fw_uid_ep_06=%h, fw_uid_ep_07\n",fw_uid_ep_02, fw_uid_ep_03, fw_uid_ep_04, fw_uid_ep_05, fw_uid_ep_06, fw_uid_ep_07);
		$monitor($time,"fw_ep_02_data=%h, fw_ep_03_data=%h, fw_ep_04_data=%h, fw_ep_05_data=%h, fw_ep_06_data=%h, fw_ep_07_data=%h\n",fw_ep_02_data, fw_ep_03_data, fw_ep_04_data, fw_ep_05_data, fw_ep_06_data, fw_ep_07_data);
		$monitor($time,"fw_ep_02_addr=%h, fw_ep_03_addr=%h, fw_ep_04_addr=%h, fw_ep_05_addr=%h, fw_ep_06_addr=%h, fw_ep_07_addr=%h\n",fw_ep_02_addr, fw_ep_03_addr, fw_ep_04_addr, fw_ep_05_addr, fw_ep_06_addr, fw_ep_07_addr);
		$monitor($time,"fw_op_02_data=%h, fw_op_03_data=%h, fw_op_04_data=%h, fw_op_05_data=%h, fw_op_06_data=%h, fw_op_07_data=%h\n",fw_op_02_data, fw_op_03_data, fw_op_04_data, fw_op_05_data, fw_op_06_data, fw_op_07_data);
		$monitor($time,"fw_op_02_addr=%h, fw_op_03_addr=%h, fw_op_04_addr=%h, fw_op_05_addr=%h, fw_op_06_addr=%h, fw_op_07_addr=%h\n",fw_op_02_addr, fw_op_03_addr, fw_op_04_addr, fw_op_05_addr, fw_op_06_addr, fw_op_07_addr);

 
		// Before first clock edge, initialize
		reset = 1;
		@(posedge clock);
		reset = 0;
		@(posedge clock);
		//Load RA 
		opcode_op = LOAD_QUADWORD_DFORM;
		I10_op = 10'd0;
		wr_en_rt_op = 1;
		pc_in = 0;
		ra_addr_op = 7'd100; // Reg 100 has zero value
		rt_addr_op = 7'd0;
			
		
		
		@(posedge clock);
		//Load RB
		opcode_op = LOAD_QUADWORD_DFORM;
		I10_op = 10'd1;
		wr_en_rt_op = 1;
		pc_in = 0;
		ra_addr_op = 7'd100; // Reg 100 has zero value
		rt_addr_op = 7'd1; 
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;	
		@(posedge clock);	
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
			//Dual Instructions
		// Instruction 1: ADD halfword
		opcode_ep = ADD_HALFWORD;
		//ls_wr_en_op_in;
		//I7_ep;
		//I10_ep;
		//I16_ep;
		//I18_ep;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd0;
		rb_addr_ep = 7'd1;
		//rc_addr_ep = 7'd0;
		rt_addr_ep = 7'd2; 
		
		// Instruction2: Load qword d form
		opcode_op = LOAD_QUADWORD_DFORM;
		//I7_op;
		I10_op = 10'd2;
		//I16_op;
		//I18_op;
		wr_en_rt_op = 1;
		//pc_in = 0;
		ra_addr_op = 7'd100; // At 100 RF has 0
		//rb_addr_op;
		rt_addr_op = 7'd3; 
		//pc_out = ;
		@(posedge clock);
		//Prereq:
			//1st instruction: None
			//2nd instruction:
			//1)Load hex value 0001 0000 0001 0000 0001 0000 0001 0000(line number 49) in Loc store at address 3 
			//2)Load data at address 3 from Loc Store to RF at address 5
			//Load RA 
			opcode_op = LOAD_QUADWORD_DFORM;
			I10_op = 10'd3;
			wr_en_rt_op = 1;
			pc_in = 0;
			ra_addr_op = 7'd100; //At 100 RF has 0
			rt_addr_op = 7'd5;
			//wait for RF to get updated
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;	
		@(posedge clock);
			
		// Instruction 1: ADD halfword immediate
		opcode_ep = ADD_HALFWORD_IMMEDIATE;
		I10_ep = 10'd9;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd0;
		rt_addr_ep = 7'd6;//Store the result at address 6 of RF 
		
		// Instruction2: Gather bits from Halfword
		opcode_op = GATHER_BITS_FROM_HALFWORDS;
		I10_op = 10'd2;
		wr_en_rt_op = 1;
		ra_addr_op = 7'd5;
		rt_addr_op = 7'd7;//Store the result at address 7 of RF 
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;	
		@(posedge clock);
		
		//Prereq:
			//1st instruction: None
			//Load immediate word
			opcode_op = IMMEDIATE_LOAD_WORD;
			I16_op = 16'd7;
			wr_en_rt_op = 1;
			rt_addr_op = 7'd9; //Load word to address 9 of RF
			
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;	
		@(posedge clock);
			
			//2nd instruction:
			//1)Load hex value 0000 0001 0000 0001 0000 0001 0000 0001(line number 49) in Loc store at address 4 
			//2)Load data at address 4 from Loc Store to RF at address 10
			//Load RA 
			opcode_op = LOAD_QUADWORD_DFORM;
			I10_op = 10'd4;
			wr_en_rt_op = 1;
			pc_in = 0;
			ra_addr_op = 7'd100; //At 100 RF has 0
			rt_addr_op = 7'd10;
			
			
		//wait for RF to get updated
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;	
		@(posedge clock);
			
		// Instruction 1: ADD halfword immediate
		opcode_ep = ADD_WORD;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd9;// from address 9 
		rb_addr_ep = 7'd9;// from address 9 
		rt_addr_ep = 7'd11;//Store the result at address 11 of RF 
		
		// Instruction2: Gather bits from word
		opcode_op = GATHER_BITS_FROM_WORDS;
		I10_op = 10'd2;
		wr_en_rt_op = 1;
		ra_addr_op = 7'd10;
		rt_addr_op = 7'd12;//Store the result at address 12 of RF 
		
		@(posedge clock);
		opcode_ep = ADD_WORD_IMMEDIATE;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd9;// from address 9
		I10_ep = 10'd3;
		rt_addr_ep = 7'd13;//Store the result at address 13 of RF 
		
		@(posedge clock);
		opcode_ep = SUB_FROM_HALFWORD;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd1;
		rb_addr_ep = 7'd0;
		//rc_addr_ep = 7'd0;
		rt_addr_ep = 7'd14; //Store the result at address 14 of RF 
		
		@(posedge clock);
		opcode_ep = SUB_FROM_WORD;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd9;// from address 9 
		rb_addr_ep = 7'd9;// from address 9 
		rt_addr_ep = 7'd11;//Store the result at address 15 of RF 
		
		
		//Pre-req for mult operation
		//Load immediate word
			opcode_op = IMMEDIATE_LOAD_WORD;
			I16_op = 16'h2;// 2
			wr_en_rt_op = 1;
			rt_addr_op = 7'd8; //Load word to address 8 of RF
			
		@(posedge clock);	

		//Load immediate word
			opcode_op = IMMEDIATE_LOAD_WORD;
			I16_op = 16'h8001; // -1
			wr_en_rt_op = 1;
			rt_addr_op = 7'd17; //Load word to address 17 of RF
			
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;	
		@(posedge clock);
		
		@(posedge clock);
		opcode_ep = MULTIPLY;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd8;// from address 8 
		rb_addr_ep = 7'd17;// from address 17 
		rt_addr_ep = 7'd11;//Store the result at address 18 of RF 
		
		
		@(posedge clock);
		opcode_ep = MULITPLY_UNSIGNED;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd8;// from address 8 
		rb_addr_ep = 7'd17;// from address 17
		rt_addr_ep = 7'd11;//Store the result at address 19 of RF 
		
		@(posedge clock);
		opcode_ep = MULTIPLY_IMMEDIATE;
		wr_en_rt_ep = 1;
		I10_ep      = 10'h201;// -1
		ra_addr_ep = 7'd8;// from address 8 
		rt_addr_ep = 7'd11;//Store the result at address 20 of RF 
		
		@(posedge clock);
		opcode_ep = MULTIPLY_AND_ADD;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd8;// from address 8 
		rt_addr_ep = 7'd11;//Store the result at address 21 of RF 
		rc_addr_ep = 7'd9;//from address 9
		
		
		
		//Pre-req for floating mult operation
		
		//1)Load hex value h40200000(value 2.5) line number 81) in Loc store at address 5 
		//2)Load hex value h40600000(value 3.5) line number 97 in Loc store  at address 6
		//3)Load data at address 5 from Loc Store to RF at address 22
		//4)Load data at address 6 from Loc Store to RF at address 23
		@(posedge clock);
		opcode_op = LOAD_QUADWORD_DFORM;
		I10_op = 10'd5; // data  h40200000(value 2.5) is store starting from 80th index to 85th in LS
		wr_en_rt_op = 1;
		pc_in = 0;
		ra_addr_op = 7'd100; // At 100 RF has 0
		rt_addr_op = 7'd22;
		
		@(posedge clock);
		opcode_op = LOAD_QUADWORD_DFORM;
		I10_op = 10'd6;
		wr_en_rt_op = 1;
		pc_in = 0;
		ra_addr_op = 7'd100; //At 100 RF has 0
		rt_addr_op = 7'd23;
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;	
		
		@(posedge clock);
		
		opcode_ep = FLOATING_MULTIPLY;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd22;// from address 22 
		rb_addr_ep = 7'd23; // from address 23
		rt_addr_ep = 7'd24;//Store the result at address 24 of RF 
		
		@(posedge clock);
		opcode_ep = FLOATING_MULTIPLY_AND_ADD;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd22;// from address 22 
		rb_addr_ep = 7'd22; // from address 22
		rc_addr_ep = 7'd23;// from address 23
		rt_addr_ep = 7'd25;//Store the result at address 25 of RF 
		
		@(posedge clock);
		opcode_ep = FLOATING_MULTIPLY_AND_SUBTRACT;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd22;// from address 22 
		rb_addr_ep = 7'd22; // from address 22
		rc_addr_ep = 7'd23;// from address 23
		rt_addr_ep = 7'd26;//Store the result at address 26 of RF 
			
		@(posedge clock);	
		opcode_ep = COUNTING_LEADING_ZEROS;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd9;// from address 22 
		rt_addr_ep = 7'd27;//Store the result at address 24 of RF 
		
		
		//Pre-req for mult operation
		//Load immediate word
		opcode_op = IMMEDIATE_LOAD_HALFWORD;
		I16_op = 16'b1010101010101010;// 
		wr_en_rt_op = 1;
		rt_addr_op = 7'd28; //Load word to address 28 of RF
		@(posedge clock);
		
		opcode_op = IMMEDIATE_LOAD_HALFWORD;
		I16_op = 16'b1000100000000010;// 
		wr_en_rt_op = 1;
		rt_addr_op = 7'd29; //Load word to address 29 of RF
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		
		@(posedge clock);	
		opcode_ep = AND;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd28;// from address 28
		rb_addr_ep = 7'd29;// from address 29
		rt_addr_ep = 7'd30;//Store the result at address 30 of RF 
		
		@(posedge clock);	
		opcode_ep = AND_HALFWORD_IMMEDIATE;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd28;// from address 28
		I10_ep = 10'b1000000010;
		rt_addr_ep = 7'd31;//Store the result at address 31 of RF 
		
		@(posedge clock);	
		opcode_ep = AND_WORD_IMMEDIATE;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd28;// from address 28
		I10_ep = 10'b1000000010;
		rt_addr_ep = 7'd32;//Store the result at address 32 of RF 
		
		@(posedge clock);	
		opcode_ep = OR;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd28;// from address 28
		rb_addr_ep = 7'd29;// from address 29 
		rt_addr_ep = 7'd33;//Store the result at address 33 of RF 
		
		@(posedge clock);	
		opcode_ep = OR_HALFWORD_IMMEDIATE;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd28;// from address 28
		I10_ep = 10'b1000000010;
		rt_addr_ep = 7'd34;//Store the result at address 34 of RF
		
		
		@(posedge clock);	
		opcode_ep = OR_WORD_IMMEDIATE;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd28;// from address 28
		I10_ep = 10'b1000000010; 
		rt_addr_ep = 7'd35;//Store the result at address 35 of RF
		
		@(posedge clock);	
		opcode_ep = NOR;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd28;// from address 28
		rb_addr_ep = 7'd29;// from address 29 
		rt_addr_ep = 7'd36;//Store the result at address 36 of RF
		
		@(posedge clock);	
		opcode_ep = XOR;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd28;// from address 28
		rb_addr_ep = 7'd29;// from address 29 
		rt_addr_ep = 7'd37;//Store the result at address 37 of RF
		
		@(posedge clock);	
		opcode_ep = XOR_HALFWORD_IMMEDIATE;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd28;// from address 28
		I10_ep = 10'b1000000010;
		rt_addr_ep = 7'd38;//Store the result at address 38 of RF
		
		@(posedge clock);	
		opcode_ep = XOR_WORD_IMMEDIATE;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd28;// from address 28
		I10_ep = 10'b1000000010; 
		rt_addr_ep = 7'd39;//Store the result at address 39 of RF
		
		
		@(posedge clock);	
		opcode_ep = FORM_SELECT_MASK_BYTES;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd28;// from address 28
		rt_addr_ep = 7'd40;//Store the result at address 40 of RF
		
		@(posedge clock);	
		opcode_ep = FORM_SELECT_MASK_HALFWORD;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd28;// from address 28
		rt_addr_ep = 7'd41;//Store the result at address 41 of RF
		
		@(posedge clock);	
		opcode_ep = FORM_SELECT_MASK_WORD;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd28;// from address 28
		rt_addr_ep = 7'd42;//Store the result at address 42 of RF
		
		opcode_op = IMMEDIATE_LOAD_WORD;
		I16_op = 16'h80C0;//1000 0000 1100 0000 
		wr_en_rt_op = 1;
		rt_addr_op = 7'd43; //Load word to address 43 of RF
		
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		
		@(posedge clock);
		opcode_op = SHUFFLE_BYTES;
		wr_en_rt_op = 1;
		ra_addr_op = 7'd28;// from address 28
		rb_addr_op = 7'd29;// from address 29
		rc_addr_op = 7'd43;// from address 43
		rt_addr_op = 7'd44;//Store the result at address 44 of RF
		
		@(posedge clock);
		opcode_ep = EQUIVALENT;
		ra_addr_ep = 7'd28;// from address 28 of RF
		rb_addr_ep = 7'd28;// from address 28 of RF
		wr_en_rt_ep = 1;
		rt_addr_ep = 7'd45; //Load word to address 45 of RF
		
		@(posedge clock);
		opcode_ep = SUB_FROM_HALFWORD_IMMEDIATE;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd28;// from address 28 of RF
		I10_ep = 10'b1000000010;
		rt_addr_ep = 7'd46; //Store the result at address 46 of RF 
		
		@(posedge clock);
		opcode_ep = SUB_FROM_WORD_IMMEDIATE;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd28;// from address 28 of RF
		I10_ep = 10'b1000000010;
		rt_addr_ep = 7'd47; //Store the result at address 47 of RF 
		
		@(posedge clock);
		opcode_op = LOAD_QUADWORD_AFORM;
		I16_op = 16'd0; // From address 0 of LS
		wr_en_rt_op = 1;
		rt_addr_op = 7'd0; //Store the result at address 0 of RF 
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;	
		@(posedge clock);
		
		opcode_op = STORE_QUADWORD_DFORM;
		I10_op = 10'd7;
		wr_en_rt_op = 0;
		ls_wr_en_op_in = 1;
		ra_addr_op = 7'd100; // At 100 RF have value 0
		rc_addr_op = 7'd47; // Move data from RF 47 to LS address 7
		
		@(posedge clock);
		opcode_op = STORE_QUADWORD_AFORM;
		I16_op = 16'd8; //   20th address of LS
		wr_en_rt_op = 0; 
		ls_wr_en_op_in = 1;
		rc_addr_op = 7'd47; // Move data from RF 47 to LS address 20
		
		@(posedge clock);
		opcode_op = IMMEDIATE_LOAD_ADDRESS;
		I18_op = 18'h26aa;
		wr_en_rt_op = 1;
		rt_addr_op = 7'd48; //Load word to address 48 of RF
		
		@(posedge clock);
		opcode_ep = FORM_SELECT_MASK_BYTES_IMMEDIATE;
		wr_en_rt_ep = 1;
		I16_ep = 16'haaaa;
		rt_addr_ep = 7'd49;//Store the result at address 49 of RF
		
		@(posedge clock);
		opcode_ep = OR_BYTE_IMMEDIATE;
		wr_en_rt_ep = 1;
		I10_ep = 10'b1111100000;
		ra_addr_ep = 7'd28;// from address 28
		rt_addr_ep = 7'd50;//Store the result at address 50 of RF
		
		@(posedge clock);
		opcode_ep = XOR_BYTE_IMMEDIATE;
		wr_en_rt_ep = 1;
		I10_ep = 10'b1111100000;
		ra_addr_ep = 7'd28;// from address 28
		rt_addr_ep = 7'd51;//Store the result at address 51 of RF
		
		@(posedge clock);
		opcode_ep = FLOATING_ADD;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd22;// from address 22 
		rb_addr_ep = 7'd22; // from address 22
		rt_addr_ep = 7'd52;//Store the result at address 52 of RF 
		
		@(posedge clock);
		opcode_ep = FLOATING_SUBTRACT;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd23;// from address 23 
		rb_addr_ep = 7'd23; // from address 23
		rt_addr_ep = 7'd53;//Store the result at address 53 of RF

		
		// Test cases for Fowarding
		
		//Case 1: Data forwarding from even pipe for an even instruction
		
		// $13 = $0 + 3;
		// NOP
		// NOP
		// $14 = $13 + 3;
		@(posedge clock);
		opcode_ep = ADD_WORD_IMMEDIATE;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd0;// from address 0 of RF
		I10_ep = 10'd3;
		rt_addr_ep = 7'd13;//Store the result at address 13 of RF 
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		
		
		@(posedge clock);
		opcode_ep = ADD_WORD_IMMEDIATE;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd13;// from address 13 of RF
		I10_ep = 10'd3;
		rt_addr_ep = 7'd54;//Store the result at address 54 of RF 
		
		
		//Case 2: Data forwarding from odd pipe for an odd instruction
		
		// gbh $7, $5
		// NOP
		// NOP
		// NOP
		// gbh $56, $7
		
		
		// gbh $7, $5
		@(posedge clock);
		// Instruction2: Gather bits from Halfword
		opcode_op = GATHER_BITS_FROM_HALFWORDS;
		I10_op = 10'd2;
		wr_en_rt_op = 1;
		ra_addr_op = 7'd5;
		rt_addr_op = 7'd7;//Store the result at address 7 of RF 
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		
		
		@(posedge clock);
		// gbh $56, $7
		// Instruction2: Gather bits from Halfword
		opcode_op = GATHER_BITS_FROM_HALFWORDS;
		I10_op = 10'd2;
		wr_en_rt_op = 1;
		ra_addr_op = 7'd7;
		rt_addr_op = 7'd56;//Store the result at address 56 of RF 
		
		//Case 3: Data forwarding from even pipe for an odd instruction
		
		// ai $13, $0, 3
		// NOP
		// NOP
		// gbh $56, $13
		
		
		// ai $13, $0,3
		// Instruction1: add word immediate
		@(posedge clock);
		opcode_ep = ADD_WORD_IMMEDIATE;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd0;// from address 0
		I10_ep = 10'd3;
		rt_addr_ep = 7'd13;//Store the result at address 13 of RF 
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		
		
		
		@(posedge clock);
		// gbh $56, $13
		// Instruction2: Gather bits from Halfword
		opcode_op = GATHER_BITS_FROM_HALFWORDS;
		I10_op = 10'd2;
		wr_en_rt_op = 1;
		ra_addr_op = 7'd13;
		rt_addr_op = 7'd56;//Store the result at address 56 of RF 
		
		
		//Case 4: Data forwarding from odd pipe for an even instruction
		
		
		// gbh $56, $13
		// NOP
		// NOP
		// NOP
		// ai $57, $56,3
		
	
	
		@(posedge clock);
		
		// gbh $56, $13
		//Gather bits from Halfword
		opcode_op = GATHER_BITS_FROM_HALFWORDS;
		I10_op = 10'd2;
		wr_en_rt_op = 1;
		ra_addr_op = 7'd14;
		rt_addr_op = 7'd56;//Store the result at address 56 of RF 
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		
		// ai $57, $56,3
		@(posedge clock);
		opcode_ep = ADD_WORD_IMMEDIATE;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd56;// from address 56
		I10_ep = 10'd3;
		rt_addr_ep = 7'd57;//Store the result at address 57 of RF 
		
		
		//Case 5: Fowarding latest data of same address in the pipe
		
		// $13 = $0 + 5;
		// NOP
		// NOP
		// $13 = $13 + 3;
        // NOP
		// NOP
		// $14 = $13 + 3;
		@(posedge clock);
		opcode_ep = ADD_WORD_IMMEDIATE;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd0;// from address 0
		I10_ep = 10'd5;
		rt_addr_ep = 7'd13;//Store the result at address 13 of RF 
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		
		@(posedge clock);
		opcode_ep = ADD_WORD_IMMEDIATE;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd13;// from address 0
		I10_ep = 10'd5;
		rt_addr_ep = 7'd13;//Store the result at address 13 of RF 
		
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		
		@(posedge clock);
		opcode_ep = ADD_WORD_IMMEDIATE;
		wr_en_rt_ep = 1;
		ra_addr_ep = 7'd13;// from address 9
		I10_ep = 10'd3;
		rt_addr_ep = 7'd58;//Store the result at address 58 of RF 
		
		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;		
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;
		@(posedge clock);
		opcode_op = NOP_EXEC;
		wr_en_rt_op = 0;
		opcode_ep = NOP_EXEC;
		wr_en_rt_ep = 0;	
		@(posedge clock);
		
		
      #20;
      $finish;
   end 


endmodule 
import definitions::*;
module decode(clock,reset,pc_in,ins1,ins2,flush_fetch,flush,pc_out,opcode_ep,I7_ep,I10_ep,I16_ep,I18_ep,
wr_en_rt_ep,opcode_op,I7_op,I10_op,I16_op,I18_op,wr_en_rt_op,ra_addr_ep,rb_addr_ep,
rc_addr_ep,rt_addr_ep,ra_addr_op,rb_addr_op,rc_addr_op,rt_addr_op,clear,
fw_ep_01_addr,fw_ep_02_addr,fw_ep_03_addr,fw_ep_04_addr,fw_ep_05_addr,fw_ep_06_addr,fw_ep_07_addr,out_ep_rt_addr,
fw_op_01_addr,fw_op_02_addr,fw_op_03_addr,fw_op_04_addr,fw_op_05_addr,fw_op_06_addr,fw_op_07_addr,out_op_rt_addr,
rf_addr_ep_r,rf_addr_op_r,wr_en_rt_ep_r, wr_en_rt_op_r,wr_en_ep_01,wr_en_ep_02,wr_en_ep_03,wr_en_ep_04,wr_en_ep_05,wr_en_ep_06,wr_en_ep_07,
wr_en_op_01,wr_en_op_02,wr_en_op_03,wr_en_op_04,wr_en_op_05,wr_en_op_06,
fw_uid_ep_02, fw_uid_ep_03, fw_uid_ep_04, fw_uid_ep_05, fw_uid_ep_06, fw_uid_ep_07,
fw_uid_op_02,fw_uid_op_03,fw_uid_op_04,fw_uid_op_05,fw_uid_op_06,fw_uid_op_07,stall
);
	parameter UNIT_1 = 4'd1;
	parameter UNIT_2 = 4'd2;
	parameter UNIT_3 = 4'd3;
	parameter UNIT_4 = 4'd4; 
	parameter UNIT_5 = 4'd5; 
	parameter UNIT_6 = 4'd6; 
	parameter UNIT_7 = 4'd7; 
	parameter UNIT_8 = 4'd8;
	input clock,reset;
	input [0:31] pc_in;
	input [0:31] ins1,ins2;
	input flush;
	input flush_fetch;
	
	output logic [0:31] pc_out;
	output opcode opcode_ep;
	output logic [0:6] I7_ep;
	output logic [0:9] I10_ep;
	output logic [0:15]I16_ep;
	output logic [0:17]I18_ep;
	output logic wr_en_rt_ep;
	output opcode opcode_op;
	output logic [0:6] I7_op;
	output logic [0:9] I10_op;
	output logic [0:15]I16_op;
	output logic [0:17]I18_op;
	output logic wr_en_rt_op;
	output logic [0:6] ra_addr_ep;
	output logic [0:6] rb_addr_ep;
	output logic [0:6] rc_addr_ep;
	output logic [0:6] rt_addr_ep;
	output logic [0:6] ra_addr_op;
	output logic [0:6] rb_addr_op,rc_addr_op;
	output logic [0:6] rt_addr_op;
	output logic clear;
	
	output logic stall;
	
	
	logic [0:3]  ins1_4;
    logic [0:3]  ins2_4;
    logic [0:6]  ins1_7;
    logic [0:6]  ins2_7;
    logic [0:7]  ins1_8;
    logic [0:7]  ins2_8;
    logic [0:8]  ins1_9;
    logic [0:8]  ins2_9;
    logic [0:10] ins1_11;
    logic [0:10] ins2_11;
	
	opcode opcode_ins1;
	logic [0:31] ins1_r, ins2_r;
	logic ins1_type, ins2_type;
	logic [0:6] I7_ins1;
	logic [0:7] I8_ins1;
	logic [0:9] I10_ins1;
	logic [0:15]I16_ins1;
	logic [0:17]I18_ins1;
	logic wr_en_rt_ins1;
	opcode opcode_ins2;
	logic [0:6] I7_ins2;
	logic [0:7] I8_ins2;
	logic [0:9] I10_ins2;
	logic [0:15]I16_ins2;
	logic [0:17]I18_ins2;
	logic wr_en_rt_ins2;
	logic [0:6] ra_addr_ins1;
	logic [0:6] rb_addr_ins1;
	logic [0:6] rc_addr_ins1;
	logic [0:6] rt_addr_ins1;
	logic [0:6] ra_addr_ins2;
	logic [0:6] rb_addr_ins2,rc_addr_ins2;
	logic [0:6] rt_addr_ins2;
	logic stall_done, stall_done_r,ins1_done,ins1_done_r,wi1_done,wi1_done_r;
	logic raw_haz_ins1, struct_haz_ins2, waw_haz_ins2, raw_haz_ins2;
	logic flush_fetch_r;
	
	
	input [0:6] fw_ep_01_addr,fw_ep_02_addr,fw_ep_03_addr,fw_ep_04_addr,fw_ep_05_addr,fw_ep_06_addr,fw_ep_07_addr,out_ep_rt_addr;//Address probes from even pipe stages
	input [0:6] fw_op_01_addr,fw_op_02_addr,fw_op_03_addr,fw_op_04_addr,fw_op_05_addr,fw_op_06_addr,fw_op_07_addr,out_op_rt_addr;//Address probes from odd pipe stages
	input wr_en_ep_01,wr_en_ep_02,wr_en_ep_03,wr_en_ep_04,wr_en_ep_05,wr_en_ep_06,wr_en_ep_07;// write enable probles from even pipe stage
	input wr_en_op_01,wr_en_op_02,wr_en_op_03,wr_en_op_04,wr_en_op_05,wr_en_op_06;// write enable probles from odd pipe stage
	input logic [0:3]  fw_uid_ep_02, fw_uid_ep_03, fw_uid_ep_04, fw_uid_ep_05, fw_uid_ep_06, fw_uid_ep_07;
	input logic [0:3] fw_uid_op_02,fw_uid_op_03,fw_uid_op_04,fw_uid_op_05,fw_uid_op_06,fw_uid_op_07;
	
	input [0:6] rf_addr_ep_r,rf_addr_op_r;// Address probes from RF stage
	input wr_en_rt_ep_r, wr_en_rt_op_r;// write enable probles from RF stage
	
	
	assign ins1_4  = ins1_r[0:3];
    assign ins2_4  = ins2_r[0:3];
    assign ins1_7  = ins1_r[0:6];
    assign ins2_7  = ins2_r[0:6];
    assign ins1_8  = ins1_r[0:7];
    assign ins2_8  = ins2_r[0:7];
    assign ins1_9  = ins1_r[0:8];
    assign ins2_9  = ins2_r[0:8];
    assign ins1_11 = ins1_r[0:10];
    assign ins2_11 = ins2_r[0:10];
	
	
	always_ff @(posedge clock) begin
		if(reset == 1 || flush == 1)begin
			pc_out <= 0;
			ins1_r <= {11'b01000000001, 21'bx};
			ins2_r <= {11'b00000000001, 21'bx};
			flush_fetch_r <= 0;
		end
		else if(stall == 1) begin
			pc_out <= pc_out;
			ins1_r <= ins1_r;
			ins2_r <= ins2_r;
			flush_fetch_r <= flush_fetch_r;
		end
		else begin
			ins1_r <= ins1;
			ins2_r <= ins2;
			pc_out <= pc_in;
			flush_fetch_r <= flush_fetch;// Change
		end
	end
	
	always_ff @(posedge clock) begin
		stall_done_r <= stall_done;
		ins1_done_r  <= ins1_done; //Change
		wi1_done_r	 <= wi1_done; //new change lah
	end
	
	always_comb begin
	
		stall = 0;
		raw_haz_ins1 = 0;
		struct_haz_ins2 = 0;
		waw_haz_ins2 = 0;
		raw_haz_ins2 = 0;
		wi1_done = 0;
	//Stall		
	
	if(stall_done_r == 0) begin //George added stall == 0)
		//Instruction 1 raw
		if(	(rf_addr_ep_r == ra_addr_ins1 &&  wr_en_rt_ep_r) || 
			(rf_addr_ep_r == rb_addr_ins1 &&  wr_en_rt_ep_r) ||
			(rf_addr_ep_r == rc_addr_ins1 &&  wr_en_rt_ep_r) ||
			(rf_addr_op_r == ra_addr_ins1 &&  wr_en_rt_op_r) ||
			(rf_addr_op_r == rb_addr_ins1 &&  wr_en_rt_op_r) ||
			(rf_addr_op_r == rc_addr_ins1 &&  wr_en_rt_op_r) ||
			
			((fw_ep_01_addr == ra_addr_ins1) && wr_en_ep_01 == 1) ||
			((fw_ep_02_addr == ra_addr_ins1) && (fw_uid_ep_02 == UNIT_2 || fw_uid_ep_02 == UNIT_3 || fw_uid_ep_02 == UNIT_4 || fw_uid_ep_02 == UNIT_5) && (wr_en_ep_02 == 1)) ||
			((fw_ep_03_addr == ra_addr_ins1) && (fw_uid_ep_03 == UNIT_3 || fw_uid_ep_03 == UNIT_4) && (wr_en_ep_03 == 1)) ||
			((fw_ep_04_addr == ra_addr_ins1) && (fw_uid_ep_04 == UNIT_3 || fw_uid_ep_04 == UNIT_4) && (wr_en_ep_04 == 1)) ||
			((fw_ep_05_addr == ra_addr_ins1) && (fw_uid_ep_05 == UNIT_3 || fw_uid_ep_05 == UNIT_4) && (wr_en_ep_05 == 1))  ||
			((fw_ep_06_addr == ra_addr_ins1) && (fw_uid_ep_06 == UNIT_4) && (wr_en_ep_06 == 1)) ||
			
			((fw_ep_01_addr == rb_addr_ins1) && wr_en_ep_01 == 1) ||
			((fw_ep_02_addr == rb_addr_ins1) && (fw_uid_ep_02 == UNIT_2 || fw_uid_ep_02 == UNIT_3 || fw_uid_ep_02 == UNIT_4 || fw_uid_ep_02 == UNIT_5) && (wr_en_ep_02 == 1)) ||
			((fw_ep_03_addr == rb_addr_ins1) && (fw_uid_ep_03 == UNIT_3 || fw_uid_ep_03 == UNIT_4) && (wr_en_ep_03 == 1)) ||
			((fw_ep_04_addr == rb_addr_ins1) && (fw_uid_ep_04 == UNIT_3 || fw_uid_ep_04 == UNIT_4) && (wr_en_ep_04 == 1)) ||
			((fw_ep_05_addr == rb_addr_ins1) && (fw_uid_ep_05 == UNIT_3 || fw_uid_ep_05 == UNIT_4) && (wr_en_ep_05 == 1))  ||
			((fw_ep_06_addr == rb_addr_ins1) && (fw_uid_ep_06 == UNIT_4) && (wr_en_ep_06 == 1)) ||
			
			
			((fw_ep_01_addr == rc_addr_ins1) && wr_en_ep_01 == 1) ||
			((fw_ep_02_addr == rc_addr_ins1) && (fw_uid_ep_02 == UNIT_2 || fw_uid_ep_02 == UNIT_3 || fw_uid_ep_02 == UNIT_4 || fw_uid_ep_02 == UNIT_5) && (wr_en_ep_02 == 1)) ||
			((fw_ep_03_addr == rc_addr_ins1) && (fw_uid_ep_03 == UNIT_3 || fw_uid_ep_03 == UNIT_4) && (wr_en_ep_03 == 1)) ||
			((fw_ep_04_addr == rc_addr_ins1) && (fw_uid_ep_04 == UNIT_3 || fw_uid_ep_04 == UNIT_4) && (wr_en_ep_04 == 1)) ||
			((fw_ep_05_addr == rc_addr_ins1) && (fw_uid_ep_05 == UNIT_3 || fw_uid_ep_05 == UNIT_4) && (wr_en_ep_05 == 1))  ||
			((fw_ep_06_addr == rc_addr_ins1) && (fw_uid_ep_06 == UNIT_4) && (wr_en_ep_06 == 1)) ||
			
			((fw_op_01_addr == ra_addr_ins1) && wr_en_op_01 == 1) ||
			((fw_op_02_addr == ra_addr_ins1) && wr_en_op_02 == 1) ||
			((fw_op_03_addr == ra_addr_ins1) && (fw_uid_op_03 == UNIT_7) && (wr_en_op_03 == 1)) ||
			((fw_op_04_addr == ra_addr_ins1) && (fw_uid_op_04 == UNIT_7) && (wr_en_op_04 == 1)) ||
			((fw_op_05_addr == ra_addr_ins1) && (fw_uid_op_05 == UNIT_7) && (wr_en_op_05 == 1)) ||
		
			
			((fw_op_01_addr == rb_addr_ins1) && wr_en_op_01 == 1) ||
			((fw_op_02_addr == rb_addr_ins1) && wr_en_op_02 == 1) ||
			((fw_op_03_addr == rb_addr_ins1) && (fw_uid_op_03 == UNIT_7) && (wr_en_op_03 == 1)) ||
			((fw_op_04_addr == rb_addr_ins1) && (fw_uid_op_04 == UNIT_7) && (wr_en_op_04 == 1)) ||
			((fw_op_05_addr == rb_addr_ins1) && (fw_uid_op_05 == UNIT_7) && (wr_en_op_05 == 1)) ||
			
			
			
			((fw_op_01_addr == rc_addr_ins1) && wr_en_op_01 == 1) ||
			((fw_op_02_addr == rc_addr_ins1) && wr_en_op_02 == 1) ||
			((fw_op_03_addr == rc_addr_ins1) && (fw_uid_op_03 == UNIT_7) && (wr_en_op_03 == 1)) ||
			((fw_op_04_addr == rc_addr_ins1) && (fw_uid_op_04 == UNIT_7) && (wr_en_op_04 == 1)) ||
			((fw_op_05_addr == rc_addr_ins1) && (fw_uid_op_05 == UNIT_7) && (wr_en_op_05 == 1)) ) begin
				
			raw_haz_ins1 = 1;
		end
	end
	
	if(raw_haz_ins1 == 0) begin  //new change lah
		wi1_done = 1;
	end
	
	//structural hazard
	if((ins1_type == EVEN && ins2_type == EVEN) || 
  (ins1_type == ODD  && ins2_type == ODD)) begin
		struct_haz_ins2 = 1;
	end
	//3.WAW
	
	
	if((rt_addr_ins1 == rt_addr_ins2) && (rt_addr_ins1 !== 7'dx) && (rt_addr_ins2 !== 7'dx)) begin
               /* (rt_addr_i1 == ra_addr_i2 || rt_addr_i2 == ra_addr_i1) ||
                (rt_addr_i1 == rb_addr_i2 || rt_addr_i2 == rb_addr_i1) ||
                (rt_addr_i1 == rc_addr_i2 || rt_addr_i2 == rc_addr_i1)) */
			waw_haz_ins2 = 1;
		//	if (stall_done_r == 1) waw_haz_ins2 = 0; 
    end
	
	
	//RAW for ins2
	//if(stall_done_r == 0) begin // added by george
	
		if( (rt_addr_ins1 == ra_addr_ins2 && wr_en_rt_ins1 && wi1_done_r == 0) ||  //next 6 lines new change added lah
			(rt_addr_ins1 == rb_addr_ins2 && wr_en_rt_ins1 && wi1_done_r == 0) ||
			(rt_addr_ins1 == rc_addr_ins2 && wr_en_rt_ins1 && wi1_done_r == 0) ||
			(rt_addr_ins1 == ra_addr_ins2 && wr_en_rt_ins1 && wi1_done_r == 0) ||
			(rt_addr_ins1 == rb_addr_ins2 && wr_en_rt_ins1 && wi1_done_r == 0) ||
			(rt_addr_ins1 == rc_addr_ins2 && wr_en_rt_ins1 && wi1_done_r == 0) ||
			
			(rf_addr_ep_r == ra_addr_ins2 &&  wr_en_rt_ep_r) ||
			(rf_addr_ep_r == rb_addr_ins2 &&  wr_en_rt_ep_r) ||
			(rf_addr_ep_r == rc_addr_ins2 &&  wr_en_rt_ep_r) ||
			(rf_addr_op_r == ra_addr_ins2 &&  wr_en_rt_op_r) ||
			(rf_addr_op_r == rb_addr_ins2 &&  wr_en_rt_op_r) ||
			(rf_addr_op_r == rc_addr_ins2 &&  wr_en_rt_op_r) ||
			
			((fw_ep_01_addr == ra_addr_ins2) && wr_en_ep_01 == 1) ||
			((fw_ep_02_addr == ra_addr_ins2) && (fw_uid_ep_02 == UNIT_2 || fw_uid_ep_02 == UNIT_3 || fw_uid_ep_02 == UNIT_4 || fw_uid_ep_02 == UNIT_5) && (wr_en_ep_02 == 1)) ||
			((fw_ep_03_addr == ra_addr_ins2) && (fw_uid_ep_03 == UNIT_3 || fw_uid_ep_03 == UNIT_4) && (wr_en_ep_03 == 1)) ||
			((fw_ep_04_addr == ra_addr_ins2) && (fw_uid_ep_04 == UNIT_3 || fw_uid_ep_04 == UNIT_4) && (wr_en_ep_04 == 1)) ||
			((fw_ep_05_addr == ra_addr_ins2) && (fw_uid_ep_05 == UNIT_3 || fw_uid_ep_05 == UNIT_4) && (wr_en_ep_05 == 1))  ||
			((fw_ep_06_addr == ra_addr_ins2) && (fw_uid_ep_06 == UNIT_4) && (wr_en_ep_06 == 1)) ||
			
			((fw_ep_01_addr == rb_addr_ins2) && wr_en_ep_01 == 1) ||
			((fw_ep_02_addr == rb_addr_ins2) && (fw_uid_ep_02 == UNIT_2 || fw_uid_ep_02 == UNIT_3 || fw_uid_ep_02 == UNIT_4 || fw_uid_ep_02 == UNIT_5) && (wr_en_ep_02 == 1)) ||
			((fw_ep_03_addr == rb_addr_ins2) && (fw_uid_ep_03 == UNIT_3 || fw_uid_ep_03 == UNIT_4) && (wr_en_ep_03 == 1)) ||
			((fw_ep_04_addr == rb_addr_ins2) && (fw_uid_ep_04 == UNIT_3 || fw_uid_ep_04 == UNIT_4) && (wr_en_ep_04 == 1)) ||
			((fw_ep_05_addr == rb_addr_ins2) && (fw_uid_ep_05 == UNIT_3 || fw_uid_ep_05 == UNIT_4) && (wr_en_ep_05 == 1))  ||
			((fw_ep_06_addr == rb_addr_ins2) && (fw_uid_ep_06 == UNIT_4) && (wr_en_ep_06 == 1)) ||
			
			
			((fw_ep_01_addr == rc_addr_ins2) && wr_en_ep_01 == 1) ||
			((fw_ep_02_addr == rc_addr_ins2) && (fw_uid_ep_02 == UNIT_2 || fw_uid_ep_02 == UNIT_3 || fw_uid_ep_02 == UNIT_4 || fw_uid_ep_02 == UNIT_5) && (wr_en_ep_02 == 1)) ||
			((fw_ep_03_addr == rc_addr_ins2) && (fw_uid_ep_03 == UNIT_3 || fw_uid_ep_03 == UNIT_4) && (wr_en_ep_03 == 1)) ||
			((fw_ep_04_addr == rc_addr_ins2) && (fw_uid_ep_04 == UNIT_3 || fw_uid_ep_04 == UNIT_4) && (wr_en_ep_04 == 1)) ||
			((fw_ep_05_addr == rc_addr_ins2) && (fw_uid_ep_05 == UNIT_3 || fw_uid_ep_05 == UNIT_4) && (wr_en_ep_05 == 1))  ||
			((fw_ep_06_addr == rc_addr_ins2) && (fw_uid_ep_06 == UNIT_4) && (wr_en_ep_06 == 1)) ||
			
			((fw_op_01_addr == ra_addr_ins2) && wr_en_op_01 == 1) ||
			((fw_op_02_addr == ra_addr_ins2) && wr_en_op_02 == 1) ||
			((fw_op_03_addr == ra_addr_ins2) && (fw_uid_op_03 == UNIT_7) && (wr_en_op_03 == 1)) ||
			((fw_op_04_addr == ra_addr_ins2) && (fw_uid_op_04 == UNIT_7) && (wr_en_op_04 == 1)) ||
			((fw_op_05_addr == ra_addr_ins2) && (fw_uid_op_05 == UNIT_7) && (wr_en_op_05 == 1)) ||
		
			
			((fw_op_01_addr == rb_addr_ins2) && wr_en_op_01 == 1) ||
			((fw_op_02_addr == rb_addr_ins2) && wr_en_op_02 == 1) ||
			((fw_op_03_addr == rb_addr_ins2) && (fw_uid_op_03 == UNIT_7) && (wr_en_op_03 == 1)) ||
			((fw_op_04_addr == rb_addr_ins2) && (fw_uid_op_04 == UNIT_7) && (wr_en_op_04 == 1)) ||
			((fw_op_05_addr == rb_addr_ins2) && (fw_uid_op_05 == UNIT_7) && (wr_en_op_05 == 1)) ||
			
			
			
			((fw_op_01_addr == rc_addr_ins2) && wr_en_op_01 == 1) ||
			((fw_op_02_addr == rc_addr_ins2) && wr_en_op_02 == 1) ||
			((fw_op_03_addr == rc_addr_ins2) && (fw_uid_op_03 == UNIT_7) && (wr_en_op_03 == 1)) ||
			((fw_op_04_addr == rc_addr_ins2) && (fw_uid_op_04 == UNIT_7) && (wr_en_op_04 == 1)) ||
			((fw_op_05_addr == rc_addr_ins2) && (fw_uid_op_05 == UNIT_7) && (wr_en_op_05 == 1))	) begin
				
			raw_haz_ins2 = 1;
		end
	//end
	
	if (stall_done_r == 1 && raw_haz_ins2 == 0 && raw_haz_ins1 == 0 ) begin
		stall = 0;
	end
	else if (raw_haz_ins2 == 1 || waw_haz_ins2 == 1 || struct_haz_ins2 == 1 || raw_haz_ins1 ==1) begin
		stall = 1;
	end
	
	
	end
	
	
	//Output
	always_comb begin
	opcode_ep  = NOP_EXEC;
	I7_ep     = 'dx;
	I10_ep    = 'dx;
	I16_ep    = 'dx;
	I18_ep    = 'dx;
	wr_en_rt_ep = 'dx;
	opcode_op = NOP_LOAD;
	I7_op = 'dx;
	I10_op = 'dx;
	I16_op = 'dx;
	I18_op = 'dx;
	wr_en_rt_op = 'dx;
	ra_addr_ep = 'dx;
	rb_addr_ep = 'dx;
	rc_addr_ep = 'dx;
	rt_addr_ep = 'dx;
	ra_addr_op = 'dx;
	rb_addr_op = 'dx;
	rc_addr_op = 'dx;
	rt_addr_op = 'dx;
	stall_done = 0;
	ins1_done  = 0;
	
	if(pc_out[29] == 1 && flush_fetch_r) begin
		if(ins2_type == EVEN) begin
			opcode_ep  	= opcode_ins2;
			I7_ep     	= I7_ins2;
			I10_ep    	= I10_ins2;
			I16_ep    	= I16_ins2;
			I18_ep    	= I18_ins2;
			wr_en_rt_ep = wr_en_rt_ins2;
			ra_addr_ep 	= ra_addr_ins2;
			rb_addr_ep 	= rb_addr_ins2;
			rc_addr_ep 	= rc_addr_ins2;
			rt_addr_ep 	= rt_addr_ins2;
			opcode_op 	= NOP_LOAD;
			I7_op 		= 'dx;
			I10_op 		= 'dx;
			I16_op 		= 'dx;
			I18_op 		= 'dx;
			wr_en_rt_op = 'dx;
			ra_addr_op 	= 'dx;
			rb_addr_op 	= 'dx;
			rc_addr_op 	= 'dx;
			rt_addr_op 	= 'dx;
		end
		else begin
			opcode_ep  	= NOP_EXEC;
			I7_ep     	= 'dx;
			I10_ep    	= 'dx;
			I16_ep    	= 'dx;
			I18_ep   	= 'dx;
			wr_en_rt_ep = 'dx;
			ra_addr_ep 	= 'dx;
			rb_addr_ep 	= 'dx;
			rc_addr_ep	= 'dx;
			rt_addr_ep 	= 'dx;
			opcode_op  	= opcode_ins2;
			I7_op     	= I7_ins2;
			I10_op    	= I10_ins2;
			I16_op    	= I16_ins2;
			I18_op    	= I18_ins2;
			wr_en_rt_op = wr_en_rt_ins2;
			ra_addr_op 	= ra_addr_ins2;
			rb_addr_op 	= rb_addr_ins2;
			rc_addr_op 	= rc_addr_ins2;
			rt_addr_op 	= rt_addr_ins2;
		end
	end
		
	//Case 1: (if ins1 type == EVEN && ins2 type == ODD && no hazard)
	else if (stall == 0 && struct_haz_ins2 == 0 && waw_haz_ins2 == 0 && ins1_done_r == 0) begin
		if (ins1_type == EVEN && ins2_type == ODD) begin
			opcode_ep  	= opcode_ins1;
			I7_ep     	= I7_ins1;
			I10_ep    	= I10_ins1;
			I16_ep    	= I16_ins1;
			I18_ep    	= I18_ins1;
			wr_en_rt_ep = wr_en_rt_ins1;
			ra_addr_ep 	= ra_addr_ins1;
			rb_addr_ep 	= rb_addr_ins1;
			rc_addr_ep 	= rc_addr_ins1;
			rt_addr_ep 	= rt_addr_ins1;
			opcode_op  	= opcode_ins2;
			I7_op     	= I7_ins2;
			I10_op    	= I10_ins2;
			I16_op    	= I16_ins2;
			I18_op    	= I18_ins2;
			wr_en_rt_op = wr_en_rt_ins2;
			ra_addr_op 	= ra_addr_ins2;
			rb_addr_op 	= rb_addr_ins2;
			rc_addr_op 	= rc_addr_ins2;
			rt_addr_op = rt_addr_ins2;
		end
		//Case 2: (if ins1 type == ODD && ins2 type == EVEN && no hazard)
		else begin
			opcode_ep  	= opcode_ins2;
			I7_ep     	= I7_ins2;
			I10_ep    	= I10_ins2;
			I16_ep    	= I16_ins2;
			I18_ep    	= I18_ins2;
			wr_en_rt_ep = wr_en_rt_ins2;
			ra_addr_ep 	= ra_addr_ins2;
			rb_addr_ep 	= rb_addr_ins2;
			rc_addr_ep 	= rc_addr_ins2;
			rt_addr_ep 	= rt_addr_ins2;
			opcode_op  	= opcode_ins1;
			I7_op     	= I7_ins1;
			I10_op    	= I10_ins1;
			I16_op    	= I16_ins1;
			I18_op    	= I18_ins1;
			wr_en_rt_op = wr_en_rt_ins1;
			ra_addr_op 	= ra_addr_ins1;
			rb_addr_op 	= rb_addr_ins1;
			rc_addr_op 	= rc_addr_ins1;
			rt_addr_op 	= rt_addr_ins1;
		end
	end 
	//raw hazard for instr 1
	else if (raw_haz_ins1 == 1) begin
		opcode_ep  	= NOP_EXEC;
		I7_ep     	= 'dx;
		I10_ep    	= 'dx;
		I16_ep    	= 'dx;
		I18_ep   	= 'dx;
		wr_en_rt_ep = 'dx;
		ra_addr_ep 	= 'dx;
		rb_addr_ep 	= 'dx;
		rc_addr_ep	= 'dx;
		rt_addr_ep 	= 'dx;
		opcode_op 	= NOP_LOAD;
		I7_op 		= 'dx;
		I10_op 		= 'dx;
		I16_op 		= 'dx;
		I18_op 		= 'dx;
		wr_en_rt_op = 'dx;
		ra_addr_op 	= 'dx;
		rb_addr_op 	= 'dx;
		rc_addr_op 	= 'dx;
		rt_addr_op 	= 'dx;
	end
	else if ((waw_haz_ins2 == 1 || struct_haz_ins2 == 1 ) && stall_done_r == 0) begin
		if(ins1_type == EVEN) begin
			opcode_ep  	= opcode_ins1;
			I7_ep     	= I7_ins1;
			I10_ep    	= I10_ins1;
			I16_ep    	= I16_ins1;
			I18_ep    	= I18_ins1;
			wr_en_rt_ep = wr_en_rt_ins1;
			ra_addr_ep 	= ra_addr_ins1;
			rb_addr_ep 	= rb_addr_ins1;
			rc_addr_ep 	= rc_addr_ins1;
			rt_addr_ep 	= rt_addr_ins1;
			opcode_op 	= NOP_LOAD;
			I7_op 		= 'dx;
			I10_op 		= 'dx;
			I16_op 		= 'dx;
			I18_op 		= 'dx;
			wr_en_rt_op = 'dx;
			ra_addr_op 	= 'dx;
			rb_addr_op 	= 'dx;
			rc_addr_op 	= 'dx;
			rt_addr_op 	= 'dx;
			stall_done	= 1;
			$monitor($time,"Hello");
		end
		else begin
			opcode_ep  	= NOP_EXEC;
			I7_ep     	= 'dx;
			I10_ep    	= 'dx;
			I16_ep    	= 'dx;
			I18_ep   	= 'dx;
			wr_en_rt_ep = 'dx;
			ra_addr_ep 	= 'dx;
			rb_addr_ep 	= 'dx;
			rc_addr_ep	= 'dx;
			rt_addr_ep 	= 'dx;
			opcode_op  	= opcode_ins1;
			I7_op     	= I7_ins1;
			I10_op    	= I10_ins1;
			I16_op    	= I16_ins1;
			I18_op    	= I18_ins1;
			wr_en_rt_op = wr_en_rt_ins1;
			ra_addr_op 	= ra_addr_ins1;
			rb_addr_op 	= rb_addr_ins1;
			rc_addr_op 	= rc_addr_ins1;
			rt_addr_op 	= rt_addr_ins1;
			stall_done= 1;
		end
	end
	//raw hazard ins2
	else if (raw_haz_ins2 == 1) begin
		if(waw_haz_ins2 == 0 && struct_haz_ins2 == 0 && ins1_done_r == 0) begin
			if(ins1_type == EVEN) begin
				opcode_ep  	= opcode_ins1;
				I7_ep     	= I7_ins1;
				I10_ep    	= I10_ins1;
				I16_ep    	= I16_ins1;
				I18_ep    	= I18_ins1;
				wr_en_rt_ep = wr_en_rt_ins1;
				ra_addr_ep 	= ra_addr_ins1;
				rb_addr_ep 	= rb_addr_ins1;
				rc_addr_ep 	= rc_addr_ins1;
				rt_addr_ep 	= rt_addr_ins1;
				opcode_op 	= NOP_LOAD;
				I7_op 		= 'dx;
				I10_op 		= 'dx;
				I16_op 		= 'dx;
				I18_op 		= 'dx;
				wr_en_rt_op = 'dx;
				ra_addr_op 	= 'dx;
				rb_addr_op 	= 'dx;
				rc_addr_op 	= 'dx;
				rt_addr_op 	= 'dx;
				stall_done	= 1;
				ins1_done   = 1;
			end
			else begin
				opcode_ep  	= NOP_EXEC;
				I7_ep     	= 'dx;
				I10_ep    	= 'dx;
				I16_ep    	= 'dx;
				I18_ep   	= 'dx;
				wr_en_rt_ep = 'dx;
				ra_addr_ep 	= 'dx;
				rb_addr_ep 	= 'dx;
				rc_addr_ep	= 'dx;
				rt_addr_ep 	= 'dx;
				opcode_op  	= opcode_ins1;
				I7_op     	= I7_ins1;
				I10_op    	= I10_ins1;
				I16_op    	= I16_ins1;
				I18_op    	= I18_ins1;
				wr_en_rt_op = wr_en_rt_ins1;
				ra_addr_op 	= ra_addr_ins1;
				rb_addr_op 	= rb_addr_ins1;
				rc_addr_op 	= rc_addr_ins1;
				rt_addr_op 	= rt_addr_ins1;
				stall_done= 1;
				ins1_done   = 1;
			end
		end
		else begin
			opcode_ep  	= NOP_EXEC;
			I7_ep     	= 'dx;
			I10_ep    	= 'dx;
			I16_ep    	= 'dx;
			I18_ep   	= 'dx;
			wr_en_rt_ep = 'dx;
			ra_addr_ep 	= 'dx;
			rb_addr_ep 	= 'dx;
			rc_addr_ep	= 'dx;
			rt_addr_ep 	= 'dx;
			opcode_op 	= NOP_LOAD;
			I7_op 		= 'dx;
			I10_op 		= 'dx;
			I16_op 		= 'dx;
			I18_op 		= 'dx;
			wr_en_rt_op = 'dx;
			ra_addr_op 	= 'dx;
			rb_addr_op 	= 'dx;
			rc_addr_op 	= 'dx;
			rt_addr_op 	= 'dx;
			stall_done  = 1;
			ins1_done   = 1;
		end
	end
	else begin
		if(ins2_type == EVEN) begin
			opcode_ep  	= opcode_ins2;
			I7_ep     	= I7_ins2;
			I10_ep    	= I10_ins2;
			I16_ep    	= I16_ins2;
			I18_ep    	= I18_ins2;
			wr_en_rt_ep = wr_en_rt_ins2;
			ra_addr_ep 	= ra_addr_ins2;
			rb_addr_ep 	= rb_addr_ins2;
			rc_addr_ep 	= rc_addr_ins2;
			rt_addr_ep 	= rt_addr_ins2;
			opcode_op 	= NOP_LOAD;
			I7_op 		= 'dx;
			I10_op 		= 'dx;
			I16_op 		= 'dx;
			I18_op 		= 'dx;
			wr_en_rt_op = 'dx;
			ra_addr_op 	= 'dx;
			rb_addr_op 	= 'dx;
			rc_addr_op 	= 'dx;
			rt_addr_op 	= 'dx;
			//stall_done	= 1;
		end
		else begin
			opcode_ep  	= NOP_EXEC;
			I7_ep     	= 'dx;
			I10_ep    	= 'dx;
			I16_ep    	= 'dx;
			I18_ep   	= 'dx;
			wr_en_rt_ep = 'dx;
			ra_addr_ep 	= 'dx;
			rb_addr_ep 	= 'dx;
			rc_addr_ep	= 'dx;
			rt_addr_ep 	= 'dx;
			opcode_op  	= opcode_ins2;
			I7_op     	= I7_ins2;
			I10_op    	= I10_ins2;
			I16_op    	= I16_ins2;
			I18_op    	= I18_ins2;
			wr_en_rt_op = wr_en_rt_ins2;
			ra_addr_op 	= ra_addr_ins2;
			rb_addr_op 	= rb_addr_ins2;
			rc_addr_op 	= rc_addr_ins2;
			rt_addr_op 	= rt_addr_ins2;
			//stall_done= 1;
		end
	end
	end
	
	

	
	always_comb begin
		opcode_ins1  = NOP_EXEC;
        opcode_ins2  = NOP_LOAD;
        ins1_type  = EVEN;
        ins2_type  = ODD;
        ra_addr_ins1 = 'dx;
        rb_addr_ins1 = 'dx;
        rc_addr_ins1 = 'dx;
        rt_addr_ins1 = 'dx;
        ra_addr_ins2 = 'dx;
        rb_addr_ins2 = 'dx;
        rc_addr_ins2 = 'dx;
        rt_addr_ins2 = 'dx;
        I7_ins1   = 'dx;  
        I8_ins1   = 'dx; 
        I10_ins1  = 'dx;
        I16_ins1  = 'dx;
        I18_ins1  = 'dx;
        I7_ins2   = 'dx;
        I8_ins2   = 'dx;
        I10_ins2  = 'dx;
        I16_ins2  = 'dx;
        I18_ins2  = 'dx;
		wr_en_rt_ins1 = 'dx;
		clear = 'dx;
		
		if(ins1_4 == 4'b1100 || ins1_4 == 4'b1110 || ins1_4 == 4'b1111 || ins1_4 == 4'b1011) begin  //4
			case(ins1_4)
				4'b1100:
					begin
						ins1_type = EVEN;
						opcode_ins1 = MULTIPLY_AND_ADD;
						wr_en_rt_ins1 = 1;
					end
				4'b1110:
					begin
						ins1_type = EVEN;
						opcode_ins1 = FLOATING_MULTIPLY_AND_ADD;
						wr_en_rt_ins1 = 1;
					end
				4'b1111:
					begin
						ins1_type = EVEN;
						opcode_ins1 = FLOATING_MULTIPLY_AND_SUBTRACT;
						wr_en_rt_ins1 = 1;
					end
				4'b1011:
					begin
						ins1_type = ODD;
						opcode_ins1 = SHUFFLE_BYTES;
						wr_en_rt_ins1 = 1;
					end
			endcase
			ins1_type  = EVEN;
            rt_addr_ins1 = ins1_r[4:10];
            ra_addr_ins1 = ins1_r[11:17];
            rb_addr_ins1 = ins1_r[18:24];
            rc_addr_ins1 = ins1_r[25:31];
		end
		
		
		else if(ins1_9 == 9'b001100101 || ins1_9 == 9'b001100100 || ins1_9 == 9'b001100000 || ins1_9 == 9'b001100110 ||
				ins1_9 == 9'b001100010 || ins1_9 == 9'b001000010 || ins1_9 == 9'b001000000 || ins1_9 == 9'b001000000 ||
				ins1_9 == 9'b001000110 || ins1_9 == 9'b001000100 || ins1_9 == 9'b001100001 || ins1_9 == 9'b001000001 || 
				ins1_9 == 9'b010000011 || ins1_9 == 9'b010000001 ) begin  //9
			
			I16_ins1  = ins1_r[9:24];
            rt_addr_ins1 = ins1_r[25:31];
			case(ins1_9)
			9'b001100101:
				begin
					ins1_type = EVEN;
					opcode_ins1 = FORM_SELECT_MASK_BYTES_IMMEDIATE;
					wr_en_rt_ins1 = 1;
				end
			9'b001100100:
				begin
					ins1_type = ODD;
					opcode_ins1 = BRANCH_RELATIVE;
					wr_en_rt_ins1 = 0;
					clear = 1;
					rt_addr_ins1 = 7'dx;
				end
			9'b001100000:
				begin
					ins1_type = ODD;
					opcode_ins1 = BRANCH_ABSOLUTE;
					wr_en_rt_ins1 = 0;
					clear = 1;
					rt_addr_ins1 = 7'dx;
				end
			9'b001100110:
				begin
					ins1_type = ODD;
					opcode_ins1 = BRANCH_RELATIVE_AND_SET_LINK;
					wr_en_rt_ins1 = 0;
					clear = 1;
					rc_addr_ins1 = ins1_r[25:31];
					rt_addr_ins1 = 7'dx;
				end
			9'b001100010:
				begin
					ins1_type = ODD;
					opcode_ins1 = BRANCH_ABSOLUTE_AND_SET_LINK;
					wr_en_rt_ins1 = 0;
					clear = 1;
					rc_addr_ins1 = ins1_r[25:31];
					rt_addr_ins1 = 7'dx;
				end
			9'b001000010:
				begin
					ins1_type = ODD;
					opcode_ins1 = BRANCH_IF_NOT_ZERO_WORD;
					wr_en_rt_ins1 = 0;
					clear = 1;
					rc_addr_ins1 = ins1_r[25:31];
					rt_addr_ins1 = 7'dx;
				end
			9'b001000000:
				begin
					ins1_type = ODD;
					opcode_ins1 = BRANCH_IF_ZERO_WORD;
					wr_en_rt_ins1 = 0;
					clear = 1;
					rc_addr_ins1 = ins1_r[25:31];
					rt_addr_ins1 = 7'dx;
				end
			9'b001000110:
				begin
					ins1_type = ODD;
					opcode_ins1 = BRANCH_IF_NOT_ZERO_HALFWORD;
					wr_en_rt_ins1 = 0;
					clear = 1;
					rc_addr_ins1 = ins1_r[25:31];
					rt_addr_ins1 = 7'dx;
				end
			9'b001000100:
				begin
					ins1_type = ODD;
					opcode_ins1 = BRANCH_IF_ZERO_HALFWORD;
					wr_en_rt_ins1 = 0;
					clear = 1;
					rc_addr_ins1 = ins1_r[25:31];
					rt_addr_ins1 = 7'dx;
				end
			9'b001100001:
				begin
					ins1_type = ODD;
					opcode_ins1 = LOAD_QUADWORD_AFORM;
					wr_en_rt_ins1 = 1;
				end
			
			9'b001000001:
				begin
					ins1_type = ODD;
					opcode_ins1 = STORE_QUADWORD_AFORM;
					rc_addr_ins1 = ins1_r[25:31];
					rt_addr_ins1 = 7'dx;
				end
			
			9'b010000011:
				begin
					ins1_type = ODD;
					opcode_ins1 = IMMEDIATE_LOAD_HALFWORD;
					wr_en_rt_ins1 = 1;
				end
			
			9'b010000001:
				begin
					ins1_type = ODD;
					opcode_ins1 = IMMEDIATE_LOAD_WORD;
					wr_en_rt_ins1 = 1;
				end
			endcase
		end
		else if(ins1_8 == 8'b00011101 || ins1_8 == 8'b00011100 || ins1_8 == 8'b00001101 || ins1_8 == 8'b00001100 ||
				ins1_8 == 8'b01110100 || ins1_8 == 8'b00010101 || ins1_8 == 8'b00010100 || ins1_8 == 8'b00000110 ||
				ins1_8 == 8'b00000101 || ins1_8 == 8'b00000100 || ins1_8 == 8'b01000110 || ins1_8 == 8'b01000101 || 
				ins1_8 == 8'b01000100 || ins1_8 == 8'b01111101 || ins1_8 == 8'b01111100 || ins1_8 == 8'b01001101 || 
				ins1_8 == 8'b01001100 || ins1_8 == 8'b01011100 || ins1_8 == 8'b01011101 || ins1_8 == 8'b00110100 || 
				ins1_8 == 8'b00100100) begin  //8
			
			rt_addr_ins1 = ins1_r[25:31];
            ra_addr_ins1 = ins1_r[18:24];
            I10_ins1  = ins1_r[8:17];
		
			case(ins1_8)
				8'b00011101:
					begin
						ins1_type = EVEN;
						opcode_ins1 = ADD_HALFWORD_IMMEDIATE;
						wr_en_rt_ins1 = 1;
					end
				8'b00011100:
					begin
						ins1_type = EVEN;
						opcode_ins1 = ADD_WORD_IMMEDIATE;
						wr_en_rt_ins1 = 1;
					end
				8'b00001101:
					begin
						ins1_type = EVEN;
						opcode_ins1 = SUB_FROM_HALFWORD_IMMEDIATE;
						wr_en_rt_ins1 = 1;
					end
				8'b00001100:
					begin
						ins1_type = EVEN;
						opcode_ins1 = SUB_FROM_WORD_IMMEDIATE;
						wr_en_rt_ins1 = 1;
					end
				8'b01110100:
					begin
						ins1_type = EVEN;
						opcode_ins1 = MULTIPLY_IMMEDIATE;
						wr_en_rt_ins1 = 1;
					end
				8'b00010101:
					begin
						ins1_type = EVEN;
						opcode_ins1 = AND_HALFWORD_IMMEDIATE;
						wr_en_rt_ins1 = 1;
					end
				8'b00010100:
					begin
						ins1_type = EVEN;
						opcode_ins1 = AND_WORD_IMMEDIATE;
						wr_en_rt_ins1 = 1;
					end
				8'b00000110:
					begin
						ins1_type = EVEN;
						opcode_ins1 = OR_BYTE_IMMEDIATE;
						wr_en_rt_ins1 = 1;
					end
				8'b00000101:
					begin
						ins1_type = EVEN;
						opcode_ins1 = OR_HALFWORD_IMMEDIATE;
						wr_en_rt_ins1 = 1;
					end
				8'b00000100:
					begin
						ins1_type = EVEN;
						opcode_ins1 = OR_WORD_IMMEDIATE;
						wr_en_rt_ins1 = 1;
					end
				8'b01000110:
					begin
						ins1_type = EVEN;
						opcode_ins1 = XOR_BYTE_IMMEDIATE;
						wr_en_rt_ins1 = 1;
					end
				8'b01000101:
					begin
						ins1_type = EVEN;
						opcode_ins1 = XOR_HALFWORD_IMMEDIATE;
						wr_en_rt_ins1 = 1;
					end
				8'b01000100:
					begin
						ins1_type = EVEN;
						opcode_ins1 = XOR_WORD_IMMEDIATE;
						wr_en_rt_ins1 = 1;
					end
				8'b01111101:
				begin
					ins1_type = EVEN;
					opcode_ins1 = COMPARE_EQUAL_HALFWORD_IMMEDIATE;
					wr_en_rt_ins1 = 1;
				end
				
				8'b01111100:
				begin
					ins1_type = EVEN;
					opcode_ins1 = COMPARE_EQUAL_WORD_IMMEDIATE;
					wr_en_rt_ins1 = 1;
				end
				
				8'b01001101:
				begin
					ins1_type = EVEN;
					opcode_ins1 = COMPARE_GREATER_THAN_HALFWORD_IMMEDIATE;
					wr_en_rt_ins1 = 1;
				end
				8'b01001100:
				begin
					ins1_type = EVEN;
					opcode_ins1 = COMPARE_GREATER_THAN_WORD_IMMEDIATE;
					wr_en_rt_ins1 = 1;
				end
				8'b01011100:
				begin
					ins1_type = EVEN;
					opcode_ins1 = COMPARE_LOGICAL_GREATER_THAN_WORD_IMMEDIATE;
					wr_en_rt_ins1 = 1;
				end
				
				8'b01011101:
				begin
					ins1_type = EVEN;
					opcode_ins1 = COMPARE_LOGICAL_GREATER_THAN_HALFWORD_IMMEDIATE;
					wr_en_rt_ins1 = 1;
				end
				8'b00110100:
				begin
					ins1_type = ODD;
					opcode_ins1 = LOAD_QUADWORD_DFORM;
					wr_en_rt_ins1 = 1;
				end
				8'b00100100:
				begin
					ins1_type = ODD;
					opcode_ins1 = STORE_QUADWORD_DFORM;
					rc_addr_ins1 = ins1_r[25:31];
					rt_addr_ins1 = 7'dx;
				end
					
					
			endcase
		end	
		else begin  
			rt_addr_ins1 = ins1_r[25:31];
			ra_addr_ins1 = ins1_r[18:24];
			rb_addr_ins1 = ins1_r[11:17];
			case(ins1_11)
				11'b00011001000:
					begin
						ins1_type = EVEN;
						opcode_ins1 = ADD_HALFWORD;
						wr_en_rt_ins1 = 1;
					end
				11'b00011000000:
					begin
						ins1_type = EVEN;
						opcode_ins1 = ADD_WORD;
						wr_en_rt_ins1 = 1;
					end
				11'b00001001000:
					begin
						ins1_type = EVEN;
						opcode_ins1 = SUB_FROM_HALFWORD;
						wr_en_rt_ins1 = 1;
					end
				11'b00001000000:
					begin
						ins1_type = EVEN;
						opcode_ins1 = SUB_FROM_WORD;
						wr_en_rt_ins1 = 1;
					end
				11'b01111000100:
					begin
						ins1_type = EVEN;
						opcode_ins1 = MULTIPLY;
						wr_en_rt_ins1 = 1;
					end
				11'b01111001100:
					begin
						ins1_type = EVEN;
						opcode_ins1 = MULITPLY_UNSIGNED;
						wr_en_rt_ins1 = 1;
					end
				11'b01010100101:
					begin
						ins1_type = EVEN;
						opcode_ins1 = COUNTING_LEADING_ZEROS;
						wr_en_rt_ins1 = 1;
						rb_addr_ins1 = 7'dx;
					end
				11'b00110110110:
					begin
						ins1_type = EVEN;
						opcode_ins1 = FORM_SELECT_MASK_BYTES;
						wr_en_rt_ins1 = 1;
						rb_addr_ins1 = 7'dx;
					end
				11'b00110110101:
					begin
						ins1_type = EVEN;
						opcode_ins1 = FORM_SELECT_MASK_HALFWORD;
						wr_en_rt_ins1 = 1;
						rb_addr_ins1 = 7'dx;
					end
				11'b00110110100:
					begin
						ins1_type = EVEN;
						opcode_ins1 = FORM_SELECT_MASK_WORD;
						wr_en_rt_ins1 = 1;
						rb_addr_ins1 = 7'dx;
					end
				11'b00011000001:
					begin
						ins1_type = EVEN;
						opcode_ins1 = AND;
						wr_en_rt_ins1 = 1;
					end
				11'b00001000001:
					begin
						ins1_type = EVEN;
						opcode_ins1 = OR;
						wr_en_rt_ins1 = 1;
					end
				11'b00001001001:
					begin
						ins1_type = EVEN;
						opcode_ins1 = NOR;
						wr_en_rt_ins1 = 1;
					end
				11'b01001000001:
					begin
						ins1_type = EVEN;
						opcode_ins1 = XOR;
						wr_en_rt_ins1 = 1;
					end
				11'b01011000100:
					begin
						ins1_type = EVEN;
						opcode_ins1 = FLOATING_ADD;
						wr_en_rt_ins1 = 1;
					end
				11'b01011000101:
					begin
						ins1_type = EVEN;
						opcode_ins1 = FLOATING_SUBTRACT;
						wr_en_rt_ins1 = 1;
					end
				11'b01011000110:
					begin
						ins1_type = EVEN;
						opcode_ins1 = FLOATING_MULTIPLY;
						wr_en_rt_ins1 = 1;
					end
				11'b00111011100:
					begin
						ins1_type = ODD;
						opcode_ins1 = ROTATE_QUADWORD_BY_BYTES;
						wr_en_rt_ins1 = 1;
					end
				11'b00111111100:
					begin
						ins1_type = ODD;
						opcode_ins1 = ROTATE_QUADWORD_BY_BYTES_IMMEDIATE;
						wr_en_rt_ins1 = 1;
						I7_ins1 = ins1_r[11:17];
						rb_addr_ins1 = 7'dx;
					end
				11'b01001001001:
					begin
						ins1_type = EVEN;
						opcode_ins1 = EQUIVALENT;
						wr_en_rt_ins1 = 1;
					end
				11'b00001011111:
					begin
						ins1_type = EVEN;
						opcode_ins1 = SHIFT_LEFT_HALFWORD;
						wr_en_rt_ins1 = 1;
					end
				11'b00001111111:
					begin
						ins1_type = EVEN;
						opcode_ins1 = SHIFT_LEFT_HALFWORD_IMMEDIATE;
						wr_en_rt_ins1 = 1;
						I7_ins1 = ins1_r[11:17];
						rb_addr_ins1 = 7'dx;
					end
				11'b00001011011:
					begin
						ins1_type = EVEN;
						opcode_ins1 = SHIFT_LEFT_WORD;
						wr_en_rt_ins1 = 1;
					end
					
				11'b00001111011:
					begin
						ins1_type = EVEN;
						opcode_ins1 = SHIFT_LEFT_WORD_IMMEDIATE;
						wr_en_rt_ins1 = 1;
						I7_ins1 = ins1_r[11:17];
						rb_addr_ins1 = 7'dx;
					end
				11'b00001011100:
					begin
						ins1_type = EVEN;
						opcode_ins1 = ROTATE_HALFWORD;
						wr_en_rt_ins1 = 1;
					end
				11'b00001111100:
					begin
						ins1_type = EVEN;
						opcode_ins1 = ROTATE_HALFWORD_IMMEDIATE;
						wr_en_rt_ins1 = 1;
						I7_ins1 = ins1_r[11:17];
						rb_addr_ins1 = 7'dx;
					end
				11'b00001011000:
					begin
						ins1_type = EVEN;
						opcode_ins1 = ROTATE_WORD;
						wr_en_rt_ins1 = 1;
					end
				11'b00001111000:
					begin
						ins1_type = EVEN;
						opcode_ins1 = ROTATE_WORD_IMMEDIATE;
						wr_en_rt_ins1 = 1;
						I7_ins1 = ins1_r[11:17];
						rb_addr_ins1 = 7'dx;
					end
					
					
				11'b00001011101:
					begin
						ins1_type = EVEN;
						opcode_ins1 = ROTATE_AND_MASK_HALFWORD;
						wr_en_rt_ins1 = 1;
					end
				11'b00001111101:
					begin
						ins1_type = EVEN;
						opcode_ins1 = ROTATE_AND_MASK_HALFWORD_IMMEDIATE;
						wr_en_rt_ins1 = 1;
						I7_ins1 = ins1_r[11:17];
						rb_addr_ins1 = 7'dx;
					end
				11'b01010110100:
					begin
						ins1_type = EVEN;
						opcode_ins1 = COUNT_ONES_IN_BYTES;
						wr_en_rt_ins1 = 1;
						rb_addr_ins1 = 7'dx;
					end
				11'b00011010011:
					begin
						ins1_type = EVEN;
						opcode_ins1 = AVERAGE_BYTES;
						wr_en_rt_ins1 = 1;
					end
				
				11'b00001010011:
					begin
						ins1_type = EVEN;
						opcode_ins1 = ABSOLUTE_DIFFERENCE_OF_BYTES;
						wr_en_rt_ins1 = 1;
					end
					
				11'b01001010011:
					begin
						ins1_type = EVEN;
						opcode_ins1 = SUM_BYTES_INTO_HALFWORDS;
						wr_en_rt_ins1 = 1;
					end
				
				11'b01111001000:
					begin
						ins1_type = EVEN;
						opcode_ins1 = COMPARE_EQUAL_HALFWORD;
						wr_en_rt_ins1 = 1;
					end
					
				11'b01111000000:
					begin
						ins1_type = EVEN;
						opcode_ins1 = COMPARE_EQUAL_WORD;
						wr_en_rt_ins1 = 1;
					end
				11'b01001001000:
					begin
						ins1_type = EVEN;
						opcode_ins1 = COMPARE_GREATER_THAN_HALFWORD;
						wr_en_rt_ins1 = 1;
					end
				11'b01001000000:
					begin
						ins1_type = EVEN;
						opcode_ins1 = COMPARE_GREATER_THAN_WORD;
						wr_en_rt_ins1 = 1;
					end
				11'b01011000000:
					begin
						ins1_type = EVEN;
						opcode_ins1 = COMPARE_LOGICAL_GREATER_THAN_WORD;
						wr_en_rt_ins1 = 1;
					end
				11'b01011001000:
					begin
						ins1_type = EVEN;
						opcode_ins1 = COMPARE_LOGICAL_GREATER_THAN_HALFWORD;
						wr_en_rt_ins1 = 1;
					end
				11'b00011000010:
					begin
						ins1_type = EVEN;
						opcode_ins1 = CARRY_GENERATE;
						wr_en_rt_ins1 = 1;
					end
				11'b01101000000:
					begin
						ins1_type = EVEN;
						opcode_ins1 = ADD_EXTENDED;
						wr_en_rt_ins1 = 1;
					end
				11'b00001000010:
					begin
						ins1_type = EVEN;
						opcode_ins1 = BORROW_GENERATE;
						wr_en_rt_ins1 = 1;
					end
				
				11'b01101000001:
					begin
						ins1_type = EVEN;
						opcode_ins1 = SUBTRACT_FROM_EXTENDED;
						wr_en_rt_ins1 = 1;
					end
				
				11'b00000000001:
					begin
						ins1_type = ODD;
						opcode_ins1 = NOP_LOAD;
						rt_addr_ins1 = 7'dx;
						ra_addr_ins1 = 7'dx;
						rb_addr_ins1 = 7'dx;
					end
				
				11'b01000000001:
					begin
						ins1_type = EVEN;
						opcode_ins1 = NOP_EXEC;
						rt_addr_ins1 = 7'dx;
						ra_addr_ins1 = 7'dx;
						rb_addr_ins1 = 7'dx;
					end
				
				11'b00000000000:
					begin
						ins1_type = ODD;
						opcode_ins1 = STOP_AND_SIGNAL;
						rt_addr_ins1 = 7'dx;
						ra_addr_ins1 = 7'dx;
						rb_addr_ins1 = 7'dx;
					end
				
				
				11'b00110110000:
					begin
						ins1_type = ODD;
						opcode_ins1 = GATHER_BITS_FROM_WORDS;
						wr_en_rt_ins1 = 1;
						rb_addr_ins1 = 7'dx;
					end
				
				11'b00110110001:
					begin
						ins1_type = ODD;
						opcode_ins1 = GATHER_BITS_FROM_HALFWORDS;
						wr_en_rt_ins1 = 1;
						rb_addr_ins1 = 7'dx;
					end
				
				
				11'b00111011011:
					begin
						ins1_type = ODD;
						opcode_ins1 = SHIFT_LEFT_QUADWORD_BY_BITS;
						wr_en_rt_ins1 = 1;
					end
				
				11'b00111111011:
					begin
						ins1_type = ODD;
						opcode_ins1 = SHIFT_LEFT_QUADWORD_BY_BITS_IMMEDIATE;
						wr_en_rt_ins1 = 1;
						I7_ins1 = ins1_r[11:17];
						rb_addr_ins1 = 7'dx;
					end
				
				11'b00111011111:
					begin
						ins1_type = ODD;
						opcode_ins1 = SHIFT_LEFT_QUADWORD_BY_BYTES;
						wr_en_rt_ins1 = 1;
					end
				
				11'b00111111111:
					begin
						ins1_type = ODD;
						opcode_ins1 = SHIFT_LEFT_QUADWORD_BY_BYTES_IMMEDIATE;
						wr_en_rt_ins1 = 1;
						I7_ins1 = ins1_r[11:17];
						rb_addr_ins1 = 7'dx;
					end
			endcase
	end
	
	if(ins2_4 == 4'b1100 || ins2_4 == 4'b1110 || ins2_4 == 4'b1111 || ins2_4 == 4'b1011) begin  //4
			case(ins2_4)
				4'b1100:
					begin
						ins2_type = EVEN;
						opcode_ins2 = MULTIPLY_AND_ADD;
						wr_en_rt_ins2 = 1;
					end
				4'b1110:
					begin
						ins2_type = EVEN;
						opcode_ins2 = FLOATING_MULTIPLY_AND_ADD;
						wr_en_rt_ins2 = 1;
					end
				4'b1111:
					begin
						ins2_type = EVEN;
						opcode_ins2 = FLOATING_MULTIPLY_AND_SUBTRACT;
						wr_en_rt_ins2 = 1;
					end
				4'b1011:
					begin
						ins2_type = ODD;
						opcode_ins2 = SHUFFLE_BYTES;
						wr_en_rt_ins2 = 1;
					end
			endcase
			ins2_type  = EVEN;
            rt_addr_ins2 = ins2_r[4:10];
            ra_addr_ins2 = ins2_r[11:17];
            rb_addr_ins2 = ins2_r[18:24];
            rc_addr_ins2 = ins2_r[25:31];
		end
		
		
		else if(ins2_9 == 9'b001100101 || ins2_9 == 9'b001100100 || ins2_9 == 9'b001100000 || ins2_9 == 9'b001100110 ||
				ins2_9 == 9'b001100010 || ins2_9 == 9'b001000010 || ins2_9 == 9'b001000000 || ins2_9 == 9'b001000000 ||
				ins2_9 == 9'b001000110 || ins2_9 == 9'b001000100 || ins2_9 == 9'b001100001 || ins2_9 == 9'b001000001 || 
				ins2_9 == 9'b010000011 || ins2_9 == 9'b010000001 ) begin  //9
			
			I16_ins2  = ins2_r[9:24];
            rt_addr_ins2 = ins2_r[25:31];
			case(ins2_9)
			9'b001100101:
				begin
					ins2_type = EVEN;
					opcode_ins2 = FORM_SELECT_MASK_BYTES_IMMEDIATE;
					wr_en_rt_ins2 = 1;
				end
			9'b001100100:
				begin
					ins2_type = ODD;
					opcode_ins2 = BRANCH_RELATIVE;
					wr_en_rt_ins2 = 0;
					rt_addr_ins2 = 7'dx;
				end
			9'b001100000:
				begin
					ins2_type = ODD;
					opcode_ins2 = BRANCH_ABSOLUTE;
					wr_en_rt_ins2 = 0;
					rt_addr_ins2 = 7'dx;
				end
			9'b001100110:
				begin
					ins2_type = ODD;
					opcode_ins2 = BRANCH_RELATIVE_AND_SET_LINK;
					wr_en_rt_ins2 = 0;
					rc_addr_ins2 = ins2_r[25:31];
					rt_addr_ins2 = 7'dx;
				end
			9'b001100010:
				begin
					ins2_type = ODD;
					opcode_ins2 = BRANCH_ABSOLUTE_AND_SET_LINK;
					wr_en_rt_ins2 = 0;
					rc_addr_ins2 = ins2_r[25:31];
					rt_addr_ins2 = 7'dx;
				end
			9'b001000010:
				begin
					ins2_type = ODD;
					opcode_ins2 = BRANCH_IF_NOT_ZERO_WORD;
					wr_en_rt_ins2 = 0;
					rc_addr_ins2 = ins2_r[25:31];
					rt_addr_ins2 = 7'dx;
				end
			9'b001000000:
				begin
					ins2_type = ODD;
					opcode_ins2 = BRANCH_IF_ZERO_WORD;
					wr_en_rt_ins2 = 0;
					rc_addr_ins2 = ins2_r[25:31];
					rt_addr_ins2 = 7'dx;
				end
			9'b001000110:
				begin
					ins2_type = ODD;
					opcode_ins2 = BRANCH_IF_NOT_ZERO_HALFWORD;
					wr_en_rt_ins2 = 0;
					rc_addr_ins2 = ins2_r[25:31];
					rt_addr_ins2 = 7'dx;
				end
			9'b001000100:
				begin
					ins2_type = ODD;
					opcode_ins2 = BRANCH_IF_ZERO_HALFWORD;
					wr_en_rt_ins2 = 0;
					rc_addr_ins2 = ins2_r[25:31];
					rt_addr_ins2 = 7'dx;
				end
			9'b001100001:
				begin
					ins2_type = ODD;
					opcode_ins2 = LOAD_QUADWORD_AFORM;
					wr_en_rt_ins2 = 1;
				end
			
			9'b001000001:
				begin
					ins2_type = ODD;
					opcode_ins2 = STORE_QUADWORD_AFORM;
					rc_addr_ins2 = ins2_r[25:31];
					rt_addr_ins2 = 7'dx;
				end
			
			9'b010000011:
				begin
					ins2_type = ODD;
					opcode_ins2 = IMMEDIATE_LOAD_HALFWORD;
					wr_en_rt_ins2 = 1;
				end
			
			9'b010000001:
				begin
					ins2_type = ODD;
					opcode_ins2 = IMMEDIATE_LOAD_WORD;
					wr_en_rt_ins2 = 1;
				end
			endcase
		end
		else if(ins2_8 == 8'b00011101 || ins2_8 == 8'b00011100 || ins2_8 == 8'b00001101 || ins2_8 == 8'b00001100 ||
				ins2_8 == 8'b01110100 || ins2_8 == 8'b00010101 || ins2_8 == 8'b00010100 || ins2_8 == 8'b00000110 ||
				ins2_8 == 8'b00000101 || ins2_8 == 8'b00000100 || ins2_8 == 8'b01000110 || ins2_8 == 8'b01000101 || 
				ins2_8 == 8'b01000100 || ins2_8 == 8'b01111101 || ins2_8 == 8'b01111100 || ins2_8 == 8'b01001101 || 
				ins2_8 == 8'b01001100 || ins2_8 == 8'b01011100 || ins2_8 == 8'b01011101 || ins2_8 == 8'b00110100 || 
				ins2_8 == 8'b00100100) begin  //8
			
			rt_addr_ins2 = ins2_r[25:31];
            ra_addr_ins2 = ins2_r[18:24];
            I10_ins2  = ins2_r[8:17];
		
			case(ins2_8)
				8'b00011101:
					begin
						ins2_type = EVEN;
						opcode_ins2 = ADD_HALFWORD_IMMEDIATE;
						wr_en_rt_ins2 = 1;
					end
				8'b00011100:
					begin
						ins2_type = EVEN;
						opcode_ins2 = ADD_WORD_IMMEDIATE;
						wr_en_rt_ins2 = 1;
					end
				8'b00001101:
					begin
						ins2_type = EVEN;
						opcode_ins2 = SUB_FROM_HALFWORD_IMMEDIATE;
						wr_en_rt_ins2 = 1;
					end
				8'b00001100:
					begin
						ins2_type = EVEN;
						opcode_ins2 = SUB_FROM_WORD_IMMEDIATE;
						wr_en_rt_ins2 = 1;
					end
				8'b01110100:
					begin
						ins2_type = EVEN;
						opcode_ins2 = MULTIPLY_IMMEDIATE;
						wr_en_rt_ins2 = 1;
					end
				8'b00010101:
					begin
						ins2_type = EVEN;
						opcode_ins2 = AND_HALFWORD_IMMEDIATE;
						wr_en_rt_ins2 = 1;
					end
				8'b00010100:
					begin
						ins2_type = EVEN;
						opcode_ins2 = AND_WORD_IMMEDIATE;
						wr_en_rt_ins2 = 1;
					end
				8'b00000110:
					begin
						ins2_type = EVEN;
						opcode_ins2 = OR_BYTE_IMMEDIATE;
						wr_en_rt_ins2 = 1;
					end
				8'b00000101:
					begin
						ins2_type = EVEN;
						opcode_ins2 = OR_HALFWORD_IMMEDIATE;
						wr_en_rt_ins2 = 1;
					end
				8'b00000100:
					begin
						ins2_type = EVEN;
						opcode_ins2 = OR_WORD_IMMEDIATE;
						wr_en_rt_ins2 = 1;
					end
				8'b01000110:
					begin
						ins2_type = EVEN;
						opcode_ins2 = XOR_BYTE_IMMEDIATE;
						wr_en_rt_ins2 = 1;
					end
				8'b01000101:
					begin
						ins2_type = EVEN;
						opcode_ins2 = XOR_HALFWORD_IMMEDIATE;
						wr_en_rt_ins2 = 1;
					end
				8'b01000100:
					begin
						ins2_type = EVEN;
						opcode_ins2 = XOR_WORD_IMMEDIATE;
						wr_en_rt_ins2 = 1;
					end
				8'b01111101:
				begin
					ins2_type = EVEN;
					opcode_ins2 = COMPARE_EQUAL_HALFWORD_IMMEDIATE;
					wr_en_rt_ins2 = 1;
				end
				
				8'b01111100:
				begin
					ins2_type = EVEN;
					opcode_ins2 = COMPARE_EQUAL_WORD_IMMEDIATE;
					wr_en_rt_ins2 = 1;
				end
				
				8'b01001101:
				begin
					ins2_type = EVEN;
					opcode_ins2 = COMPARE_GREATER_THAN_HALFWORD_IMMEDIATE;
					wr_en_rt_ins2 = 1;
				end
				8'b01001100:
				begin
					ins2_type = EVEN;
					opcode_ins2 = COMPARE_GREATER_THAN_WORD_IMMEDIATE;
					wr_en_rt_ins2 = 1;
				end
				8'b01011100:
				begin
					ins2_type = EVEN;
					opcode_ins2 = COMPARE_LOGICAL_GREATER_THAN_WORD_IMMEDIATE;
					wr_en_rt_ins2 = 1;
				end
				
				8'b01011101:
				begin
					ins2_type = EVEN;
					opcode_ins2 = COMPARE_LOGICAL_GREATER_THAN_HALFWORD_IMMEDIATE;
					wr_en_rt_ins2 = 1;
				end
				8'b00110100:
				begin
					ins2_type = ODD;
					opcode_ins2 = LOAD_QUADWORD_DFORM;
					wr_en_rt_ins2 = 1;
				end
				8'b00100100:
				begin
					ins2_type = ODD;
					opcode_ins2 = STORE_QUADWORD_DFORM;
					rc_addr_ins2 = ins2_r[25:31];
					rt_addr_ins2 = 7'dx;
				end
					
					
			endcase
		end	
		else begin  
			rt_addr_ins2 = ins2_r[25:31];
			ra_addr_ins2 = ins2_r[18:24];
			rb_addr_ins2 = ins2_r[11:17];
			case(ins2_11)
				11'b00011001000:
					begin
						ins2_type = EVEN;
						opcode_ins2 = ADD_HALFWORD;
						wr_en_rt_ins2 = 1;
					end
				11'b00011000000:
					begin
						ins2_type = EVEN;
						opcode_ins2 = ADD_WORD;
						wr_en_rt_ins2 = 1;
					end
				11'b00001001000:
					begin
						ins2_type = EVEN;
						opcode_ins2 = SUB_FROM_HALFWORD;
						wr_en_rt_ins2 = 1;
					end
				11'b00001000000:
					begin
						ins2_type = EVEN;
						opcode_ins2 = SUB_FROM_WORD;
						wr_en_rt_ins2 = 1;
					end
				11'b01111000100:
					begin
						ins2_type = EVEN;
						opcode_ins2 = MULTIPLY;
						wr_en_rt_ins2 = 1;
					end
				11'b01111001100:
					begin
						ins2_type = EVEN;
						opcode_ins2 = MULITPLY_UNSIGNED;
						wr_en_rt_ins2 = 1;
					end
				11'b01010100101:
					begin
						ins2_type = EVEN;
						opcode_ins2 = COUNTING_LEADING_ZEROS;
						wr_en_rt_ins2 = 1;
						rb_addr_ins2 = 7'dx;
					end
				11'b00110110110:
					begin
						ins2_type = EVEN;
						opcode_ins2 = FORM_SELECT_MASK_BYTES;
						wr_en_rt_ins2 = 1;
						rb_addr_ins2 = 7'dx;
					end
				11'b00110110101:
					begin
						ins2_type = EVEN;
						opcode_ins2 = FORM_SELECT_MASK_HALFWORD;
						wr_en_rt_ins2 = 1;
						rb_addr_ins2 = 7'dx;
					end
				11'b00110110100:
					begin
						ins2_type = EVEN;
						opcode_ins2 = FORM_SELECT_MASK_WORD;
						wr_en_rt_ins2 = 1;
						rb_addr_ins2 = 7'dx;
					end
				11'b00011000001:
					begin
						ins2_type = EVEN;
						opcode_ins2 = AND;
						wr_en_rt_ins2 = 1;
					end
				11'b00001000001:
					begin
						ins2_type = EVEN;
						opcode_ins2 = OR;
						wr_en_rt_ins2 = 1;
					end
				11'b00001001001:
					begin
						ins2_type = EVEN;
						opcode_ins2 = NOR;
						wr_en_rt_ins2 = 1;
					end
				11'b01001000001:
					begin
						ins2_type = EVEN;
						opcode_ins2 = XOR;
						wr_en_rt_ins2 = 1;
					end
				11'b01011000100:
					begin
						ins2_type = EVEN;
						opcode_ins2 = FLOATING_ADD;
						wr_en_rt_ins2 = 1;
					end
				11'b01011000101:
					begin
						ins2_type = EVEN;
						opcode_ins2 = FLOATING_SUBTRACT;
						wr_en_rt_ins2 = 1;
					end
				11'b01011000110:
					begin
						ins2_type = EVEN;
						opcode_ins2 = FLOATING_MULTIPLY;
						wr_en_rt_ins2 = 1;
					end
				11'b00111011100:
					begin
						ins2_type = ODD;
						opcode_ins2 = ROTATE_QUADWORD_BY_BYTES;
						wr_en_rt_ins2 = 1;
					end
				11'b00111111100:
					begin
						ins2_type = ODD;
						opcode_ins2 = ROTATE_QUADWORD_BY_BYTES_IMMEDIATE;
						wr_en_rt_ins2 = 1;
						I7_ins2 = ins2_r[11:17];
						rb_addr_ins2 = 7'dx;
					end
				11'b01001001001:
					begin
						ins2_type = EVEN;
						opcode_ins2 = EQUIVALENT;
						wr_en_rt_ins2 = 1;
					end
				11'b00001011111:
					begin
						ins2_type = EVEN;
						opcode_ins2 = SHIFT_LEFT_HALFWORD;
						wr_en_rt_ins2 = 1;
					end
				11'b00001111111:
					begin
						ins2_type = EVEN;
						opcode_ins2 = SHIFT_LEFT_HALFWORD_IMMEDIATE;
						wr_en_rt_ins2 = 1;
						I7_ins2 = ins2_r[11:17];
						rb_addr_ins2 = 7'dx;
					end
				11'b00001011011:
					begin
						ins2_type = EVEN;
						opcode_ins2 = SHIFT_LEFT_WORD;
						wr_en_rt_ins2 = 1;
					end
					
				11'b00001111011:
					begin
						ins2_type = EVEN;
						opcode_ins2 = SHIFT_LEFT_WORD_IMMEDIATE;
						wr_en_rt_ins2 = 1;
						I7_ins2 = ins2_r[11:17];
						rb_addr_ins2 = 7'dx;
					end
				11'b00001011100:
					begin
						ins2_type = EVEN;
						opcode_ins2 = ROTATE_HALFWORD;
						wr_en_rt_ins2 = 1;
					end
				11'b00001111100:
					begin
						ins2_type = EVEN;
						opcode_ins2 = ROTATE_HALFWORD_IMMEDIATE;
						wr_en_rt_ins2 = 1;
						I7_ins2 = ins2_r[11:17];
						rb_addr_ins2 = 7'dx;
					end
				11'b00001011000:
					begin
						ins2_type = EVEN;
						opcode_ins2 = ROTATE_WORD;
						wr_en_rt_ins2 = 1;
					end
				11'b00001111000:
					begin
						ins2_type = EVEN;
						opcode_ins2 = ROTATE_WORD_IMMEDIATE;
						wr_en_rt_ins2 = 1;
						I7_ins2 = ins2_r[11:17];
						rb_addr_ins2 = 7'dx;
					end
					
					
				11'b00001011101:
					begin
						ins2_type = EVEN;
						opcode_ins2 = ROTATE_AND_MASK_HALFWORD;
						wr_en_rt_ins2 = 1;
					end
				11'b00001111101:
					begin
						ins2_type = EVEN;
						opcode_ins2 = ROTATE_AND_MASK_HALFWORD_IMMEDIATE;
						wr_en_rt_ins2 = 1;
						I7_ins2 = ins2_r[11:17];
						rb_addr_ins2 = 7'dx;
					end
				11'b01010110100:
					begin
						ins2_type = EVEN;
						opcode_ins2 = COUNT_ONES_IN_BYTES;
						wr_en_rt_ins2 = 1;
						rb_addr_ins2 = 7'dx;
					end
				11'b00011010011:
					begin
						ins2_type = EVEN;
						opcode_ins2 = AVERAGE_BYTES;
						wr_en_rt_ins2 = 1;
					end
				
				11'b00001010011:
					begin
						ins2_type = EVEN;
						opcode_ins2 = ABSOLUTE_DIFFERENCE_OF_BYTES;
						wr_en_rt_ins2 = 1;
					end
					
				11'b01001010011:
					begin
						ins2_type = EVEN;
						opcode_ins2 = SUM_BYTES_INTO_HALFWORDS;
						wr_en_rt_ins2 = 1;
					end
				
				11'b01111001000:
					begin
						ins2_type = EVEN;
						opcode_ins2 = COMPARE_EQUAL_HALFWORD;
						wr_en_rt_ins2 = 1;
					end
					
				11'b01111000000:
					begin
						ins2_type = EVEN;
						opcode_ins2 = COMPARE_EQUAL_WORD;
						wr_en_rt_ins2 = 1;
					end
				11'b01001001000:
					begin
						ins2_type = EVEN;
						opcode_ins2 = COMPARE_GREATER_THAN_HALFWORD;
						wr_en_rt_ins2 = 1;
					end
				11'b01001000000:
					begin
						ins2_type = EVEN;
						opcode_ins2 = COMPARE_GREATER_THAN_WORD;
						wr_en_rt_ins2 = 1;
					end
				11'b01011000000:
					begin
						ins2_type = EVEN;
						opcode_ins2 = COMPARE_LOGICAL_GREATER_THAN_WORD;
						wr_en_rt_ins2 = 1;
					end
				11'b01011001000:
					begin
						ins2_type = EVEN;
						opcode_ins2 = COMPARE_LOGICAL_GREATER_THAN_HALFWORD;
						wr_en_rt_ins2 = 1;
					end
				11'b00011000010:
					begin
						ins2_type = EVEN;
						opcode_ins2 = CARRY_GENERATE;
						wr_en_rt_ins2 = 1;
					end
				11'b01101000000:
					begin
						ins2_type = EVEN;
						opcode_ins2 = ADD_EXTENDED;
						wr_en_rt_ins2 = 1;
					end
				11'b00001000010:
					begin
						ins2_type = EVEN;
						opcode_ins2 = BORROW_GENERATE;
						wr_en_rt_ins2 = 1;
					end
				
				11'b01101000001:
					begin
						ins2_type = EVEN;
						opcode_ins2 = SUBTRACT_FROM_EXTENDED;
						wr_en_rt_ins2 = 1;
					end
				
				11'b00000000001:
					begin
						ins2_type = ODD;
						opcode_ins2 = NOP_LOAD;
						rt_addr_ins2 = 7'dx;
						ra_addr_ins2 = 7'dx;
						rb_addr_ins2 = 7'dx;
					end
				
				11'b01000000001:
					begin
						ins2_type = EVEN;
						opcode_ins2 = NOP_EXEC;
						rt_addr_ins2 = 7'dx;
						ra_addr_ins2 = 7'dx;
						rb_addr_ins2 = 7'dx;
					end
				
				11'b00000000000:
					begin
						ins2_type = ODD;
						opcode_ins2 = STOP_AND_SIGNAL;
						rt_addr_ins2 = 7'dx;
						ra_addr_ins2 = 7'dx;
						rb_addr_ins2 = 7'dx;
					end
				
				
				11'b00110110000:
					begin
						ins2_type = ODD;
						opcode_ins2 = GATHER_BITS_FROM_WORDS;
						wr_en_rt_ins2 = 1;
						rb_addr_ins2 = 7'dx;
					end
				
				11'b00110110001:
					begin
						ins2_type = ODD;
						opcode_ins2 = GATHER_BITS_FROM_HALFWORDS;
						wr_en_rt_ins2 = 1;
						rb_addr_ins2 = 7'dx;
					end
				
				
				11'b00111011011:
					begin
						ins2_type = ODD;
						opcode_ins2 = SHIFT_LEFT_QUADWORD_BY_BITS;
						wr_en_rt_ins2 = 1;
					end
				
				11'b00111111011:
					begin
						ins2_type = ODD;
						opcode_ins2 = SHIFT_LEFT_QUADWORD_BY_BITS_IMMEDIATE;
						wr_en_rt_ins2 = 1;
						I7_ins2 = ins2_r[11:17];
						rb_addr_ins2 = 7'dx;
					end
				
				11'b00111011111:
					begin
						ins2_type = ODD;
						opcode_ins2 = SHIFT_LEFT_QUADWORD_BY_BYTES;
						wr_en_rt_ins2 = 1;
					end
				
				11'b00111111111:
					begin
						ins2_type = ODD;
						opcode_ins2 = SHIFT_LEFT_QUADWORD_BY_BYTES_IMMEDIATE;
						wr_en_rt_ins2 = 1;
						I7_ins2 = ins2_r[11:17];
						rb_addr_ins2 = 7'dx;
					end
			endcase
	end
	if(pc_out[29] == 1 && flush_fetch_r) begin
		if(ins2_type == EVEN) begin 
			ins1_type = ODD;
		end
		else begin
			ins1_type = EVEN;
		end
	end
	end
endmodule
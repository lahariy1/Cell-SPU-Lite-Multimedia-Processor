module fetch(clock,reset,stall,flush,pc_in,ins1,ins2,pc_out,flush_fetch);
	input clock,reset;
	input stall;  //structural or data hazards make stall one;last indicates that the last instruction is executed
	input flush; //bt_addr is branch taken address
	input [0:31] pc_in;
	output logic [0:31] ins1,ins2;
	
	output logic [0:31] pc_out;
	logic [0:7] imem [2048];
	logic [0:31] imem_temp[512];
	logic last;
	output logic flush_fetch;
	logic pc_inc_4,stall_r;
	int pc;
	initial begin
        $readmemb("Binary.txt", imem_temp);
		for(int i = 0;i<512/*imem_temp[i]!=0*/;i++)begin
			imem[4*i] 	  = imem_temp[i][0:7];
			imem[(4*i)+1] = imem_temp[i][8:15];
			imem[(4*i)+2] = imem_temp[i][16:23];
			imem[(4*i)+3] = imem_temp[i][24:31];
		end
	end
	
	
	always_ff @(posedge clock) begin
		if(reset) begin 
			pc_out <= 0;
			flush_fetch <= 0;
		end
		else if (flush) begin //flush is 1 when the branch is taken
			pc_out <= pc_in;
			flush_fetch <= flush;
		end
		else if (stall) begin 
			pc_out <= pc_out;
			flush_fetch <= flush;
		end
		//if previous PC from branch was an odd address the next cycle 
		//PC should be incremented by 4 not 8, because instruction onw was passed a X.
		else if(pc_inc_4 ==1) begin
			pc_out <= pc_out + 4;
			flush_fetch <= flush;
		end
		else begin
			pc_out <= pc_out+8;
			flush_fetch <= flush;
		end
	end
	
	always_ff @(posedge clock) begin
		if(reset == 1) begin
			stall_r <= 0;
		end
		else begin	
			stall_r <= stall;
		end
	end
	
	always_comb begin
		pc_inc_4 = 0;
		pc = pc_out;
		// Stop and Signal seen Yet?
		if (last == 1  && stall_r == 0) begin
			ins1[0:31] = {11'b01000000001, 21'bx};
			ins2[0:31] = {11'b00000000001, 21'bx};
		end
		else begin
			//If new PC from branch instruct is an odd address
			if(flush_fetch == 1 && pc_out[29] == 1) begin	
				if ({imem[pc],imem[pc+1][0:2]} == 11'b00000000000) begin
					last = 1;
				end
					ins1[0:31] = 'dx;
					ins2[0:31] = {imem[pc],imem[pc+1],imem[pc+2],imem[pc+3]};
					//Set this for the next cycle PC to be incremented by 4 not 8.
					pc_inc_4  = 1;
			end
			else begin
				//Normal case
				if({imem[pc],imem[pc+1][0:2]} != 11'b00000000000 && {imem[pc+4],imem[pc+5][0:2]} != 11'b00000000000) begin
					ins1[0:31] = {imem[pc],imem[pc+1],imem[pc+2],imem[pc+3]};
					ins2[0:31] = {imem[pc+4],imem[pc+5],imem[pc+6],imem[pc+7]};
				end
				
				else if ({imem[pc],imem[pc+1][0:2]} == 11'b00000000000) begin
					last = 1;
					ins1[0:31] = {imem[pc],imem[pc+1],imem[pc+2],imem[pc+3]};
					ins2[0:31] = {11'b01000000001, 21'bx};
				end 
				else begin	//(imem[pc+4] = 11'b00000000000)
					//So that next cycle 
					last = 1;
					ins1[0:31] = {imem[pc],imem[pc+1],imem[pc+2],imem[pc+3]};
					ins2[0:31] = {imem[pc+4],imem[pc+5],imem[pc+6],imem[pc+7]};
				end
			end
		end
	end
endmodule
	
	
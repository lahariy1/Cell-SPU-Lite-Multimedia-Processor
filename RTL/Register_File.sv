
module reg_file(clock,reset,ra_addr_ep,rb_addr_ep,rc_addr_ep,ra_addr_op,rb_addr_op,rc_addr_op,rt_addr_ep,rt_addr_op,rt_data_ep,rt_data_op,wrbe_ep, wrbe_op,o_ra_data_ep,o_rb_data_ep,o_rc_data_ep,o_ra_data_op,o_rb_data_op,o_rc_data_op,reg_file_mem);
	input clock,reset;
	input [6:0] ra_addr_ep; 
	input [6:0] rb_addr_ep;
	input [6:0] rc_addr_ep;
	input [6:0] rt_addr_ep; 	
	input [6:0] ra_addr_op; 
	input [6:0] rb_addr_op;
	input [6:0] rc_addr_op; 	
	input [6:0] rt_addr_op; 
	input [127:0] rt_data_ep;
	input [127:0] rt_data_op;
	input wrbe_ep, wrbe_op;
	output logic [127:0] o_ra_data_ep;
	output logic [127:0] o_rb_data_ep;
	output logic [127:0] o_rc_data_ep;
	output logic [127:0] o_ra_data_op;
	output logic [127:0] o_rb_data_op;
	output logic [127:0] o_rc_data_op;
	
	output logic [0:127] reg_file_mem [128];
	
	
	
	assign o_ra_data_ep   = reg_file_mem[ra_addr_ep];
	assign	o_rb_data_ep  = reg_file_mem[rb_addr_ep];
	assign	o_rc_data_ep  = reg_file_mem[rc_addr_ep];
	assign	o_ra_data_op  = reg_file_mem[ra_addr_op];
	assign	o_rb_data_op  = reg_file_mem[rb_addr_op];
	assign	o_rc_data_op  = reg_file_mem[rc_addr_op];
	always_ff @(posedge clock) begin
		if(reset) begin
            for(int i = 0; i < 128; i++) begin
                reg_file_mem[i] <= 128'd0;
            end
        end
		//$display("ra read =%d address =%d ",o_ra_data_op,ra_addr_op);
		/*o_ra_data_ep <= reg_file_mem[ra_addr_ep];
		o_rb_data_ep <= reg_file_mem[rb_addr_ep];
		o_rc_data_ep <= reg_file_mem[rc_addr_ep];
		o_ra_data_op <= reg_file_mem[ra_addr_op];
		o_rb_data_op <= reg_file_mem[rb_addr_op];
		o_rc_data_op <= reg_file_mem[rc_addr_op];*/
		if(wrbe_ep == 1) begin
			reg_file_mem[rt_addr_ep] <= rt_data_ep;   
		end 
		if(wrbe_op == 1) begin
			reg_file_mem[rt_addr_op] <= rt_data_op;  // if both wrbe signals are 1 & rt_addr is same then rt_data_op is written to rt_addr address
		end
	end
endmodule
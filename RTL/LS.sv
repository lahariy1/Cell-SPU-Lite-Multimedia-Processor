import definitions::*;
module local_store(clock,lsa_addr,lsa_data_in,lsa_data_out,ls_wr_en,ls_mem);
	input clock;
	input ls_wr_en;
	input [0:14] lsa_addr;
	input [0:127] lsa_data_in;
	output logic [0:127] lsa_data_out;
	output logic [0:7] ls_mem [LS_SIZE];
	
	initial begin
        $readmemb("preload_data", ls_mem);
    end
	
	always_comb begin
		for (int i=0; i<16; i++) begin
			lsa_data_out[i*BYTE +: BYTE] = ls_mem[i + lsa_addr];
		end
	end

	always_ff @(posedge clock) begin
		if (ls_wr_en == 1) begin
			for (int i=0; i<16; i++) begin
				ls_mem[i + lsa_addr] <= lsa_data_in[i*BYTE +: BYTE];
			end
		end
	end
endmodule
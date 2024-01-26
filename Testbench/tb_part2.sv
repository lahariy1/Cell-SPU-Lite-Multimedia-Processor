import definitions::*;
module tb_part2();

	logic clock, reset;
	topmodule_part2 dut(.clock(clock),
					   .reset(reset)
					   );
   

	initial clock = 0;
	always #5 clock = ~clock;


	initial begin
	
		// Before first clock edge, initialize
		reset = 1;
		@(posedge clock);
		reset = 0;
		@(posedge clock);
		
		repeat(1000) @(posedge clock);
		$finish;
	end 
endmodule 
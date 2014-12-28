`timescale 1ns/1ns


module queue_up #(parameter NUM_IN_LOG2=3)
(
	clk, rst,
	count, valid_i,
	pick, valid_o, size
);
	input logic clk, rst;
	input logic [31:0] count [2**NUM_IN_LOG2-1:0];
	input logic valid_i [2**NUM_IN_LOG2-1:0];
	output logic [NUM_IN_LOG2-1:0] pick;
	output logic [7:0] size;
	output logic valid_o; 

	integer min_t; //used to determine when 
				   //integer wraparound is 
				   //occuring

	always_ff @(posedge clk) begin
		if(rst) begin
			pick <= 'b0;
			size <= 'b0;
			valid_o <= 'b0;
			min_t <= 0;
		end else begin
			if(|valid_i) begin
				//nice disgusting combinational block
				if(&count) begin
				end
				if(&min_t) begin
				end
			end
		end
	end

endmodule

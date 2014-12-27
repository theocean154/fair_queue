`timescale 1ns/1ns


module fq #(parameter NUM_IN_LOG2=3)
(
	clk, rst,
	fifo_rdreq,
	fifo_empty,
	fifo_data,
	output_data_valid,
	output_data
);
	input logic clk, rst;
	input logic fifo_empty [2**NUM_IN_LOG2-1:0];
	input logic [63:0] fifo_data [2**NUM_IN_LOG2-1:0];
	output logic fifo_rdreq [2**NUM_IN_LOG2-1:0];
	output logic output_data_valid;
	output logic [63:0] output_data;



	integer queue [2**NUM_IN_LOG2-1:0]; //end times 32 bit wraparound
	logic running [2**NUM_IN_LOG2-1:0]; //currently outputting

	integer t; //current t

	logic valid[2**NUM_IN_LOG2-1:0];
	queue_up q_inst(.valid_i(valid),.count(fifo_data[7:0]),.*);


genvar i;
generate for(i=0;i<2**NUM_IN_LOG2;i=i+1) begin

	always_ff @(posedge clk) begin
		if(rst) begin
			running[i] <= 1'b0;
		end else begin
			if(!fifo_empty[i] && !running[i]) begin
				valid[i] <= 1'b1;
			end else begin
				valid[i] <= 1'b0;
				if(fifo_empty[i]) begin
				//do nothing
				end else if(running[i]) begin
				//do nothing
				end
			end
		end
	end
end
endgenerate


endmodule

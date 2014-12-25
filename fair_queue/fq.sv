`timescale 1ns/1ns


module fq (
	clk, rst,
	fifo_rdreq,
	fifo_empty,
	fifo_data,
	output_data_valid,
	output_data
);
	input logic clk, rst;
	input logic fifo_empty [7:0];
	input logic [63:0] fifo_data [7:0];
	output logic fifo_rdreq [7:0];
	output logic output_data_valid;
	output logic [63:0] output_data;

	integer end_time [7:0];

	byte unsigned ttf; //time to finish
	logic sending [7:0];



	always_ff @(posedge clk) begin
		if(rst) begin
			next <= 'b0;

		end else begin



		end
	end


endmodule

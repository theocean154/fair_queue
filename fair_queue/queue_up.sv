`timescale 1ns/1ns


module queue_up #(parameter NUM_IN_LOG2=3)
(
	clk, rst,
	count, valid_i,
	order, valid_o
);
	input logic clk, rst;
	input logic [7:0] count [2**NUM_IN_LOG2-1:0];
	input logic valid_i [2**NUM_IN_LOG2-1:0];
	output logic [NUM_IN_LOG2-1:0] pick;
	output logic valid_o; 


endmodule

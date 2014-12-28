`timescale 1ns/1ns


module fq #(parameter NUM_IN_LOG2=3)
(
	input logic clk, rst,
	output logic fifo_rdreq [2**NUM_IN_LOG2-1:0],
	input fifo_empty[2**NUM_IN_LOG2-1:0],
	input [63:0] fifo_data [2**NUM_IN_LOG2-1:0],
	output output_data_valid,
	output [63:0] output_data
);


	//integer queue [2**NUM_IN_LOG2-1:0]; //end times 32 bit wraparound
	logic [2**NUM_IN_LOG2-1:0] running; //currently outputting

	logic valid[2**NUM_IN_LOG2-1:0]; //input is ready
	logic [NUM_IN_LOG2-1:0] pick; //which channel to select
	logic valid_o; //selected channel is valid 

	logic [7:0] counts [2**NUM_IN_LOG2-1:0]; //first 8 bits of each channel (count)
	logic [2**NUM_IN_LOG2-1:0] rdreq;

genvar j;
generate for(j=0;j<2**NUM_IN_LOG2;j=j+1) begin
	assign counts[j] = fifo_data[j][7:0];
	assign rdreq[j] = fifo_rdreq[j];
end
endgenerate


	byte total; //# packets total to output
	byte count; //current # packets output
	logic [NUM_IN_LOG2-1:0] current;



	//queue_up selects the next packet to send
	queue_up q_inst(.valid_i(valid), .count(counts),
		.pick(pick), .valid_o(valid_o),.*);




genvar i;
generate for(i=0;i<2**NUM_IN_LOG2;i=i+1) begin
	always_ff @(posedge clk) begin
		if(rst) begin
			valid[i] <= 1'b0;
		end else begin
			if(!fifo_empty[i] && !running[i]) begin //available for selection
				valid[i] <= 1'b1;
			end else begin 
				valid[i] <= 1'b0; //not available for selection
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




	always_ff @(posedge clk) begin
		if(rst) begin
			current <= 'b0;
			running <= 'b0;
			output_data <= 'b0;
			output_data_valid <= 'b0;
			rdreq <= 'b0;
		end else begin
			//change this if additional output channels
			if(&running) begin //something is already outputting
				//output record
				output_data <= fifo_data[current];
				output_data_valid <= 1'b1;
				rdreq[current] <= 1'b1;

				//check if last packet
				if((count+1)==total) begin //last packet 
					running[current] <= 1'b0;
				end
			end else begin
				if(valid_o) begin //something selected to be output
					current <= pick;
					running[pick] <= 1'b1; //mux on output from submodule
					output_data <= fifo_data[pick];
					output_data_valid <= 1'b1;
					rdreq[pick] <= 1'b1;
				end else begin
					rdreq <= 'b0;
					current <= 'b0;
					output_data_valid <= 1'b0;
				end
			end
		end
	end



endmodule

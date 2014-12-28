`timescale 1ns/1ns


module fq #(parameter NUM_IN_LOG2=3)
(
	input logic clk, 
	input logic rst,
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
	//logic [7:0] size;

	integer unsigned t; //virtual time

	logic [31:0] counts [2**NUM_IN_LOG2-1:0]; //first 8 bits of each channel (count)

genvar j;
generate for(j=0;j<2**NUM_IN_LOG2;j=j+1) begin
	assign counts[j] = t+{24'b0,fifo_data[j][7:0]};
end
endgenerate


	byte unsigned total; //# packets total to output
	byte unsigned count; //current # packets output
	logic [NUM_IN_LOG2-1:0] current;



	//queue_up selects the next packet to send
	queue_up q_inst(.valid_i(valid), .count(counts),
		//.pick(pick), .valid_o(valid_o),.size(size),.*);
		.pick(pick), .valid_o(valid_o),.*);




genvar i;
generate for(i=0;i<2**NUM_IN_LOG2;i=i+1) begin
	always_ff @(posedge clk) begin
		if(rst) begin
			valid[i] <= 1'b0;
			//counts[i]<='b0;
		end else begin
			if(!fifo_empty[i] && !running[i]) begin //available for selection
				valid[i] <= 1'b1;
				//counts[i] <= t+{24'b0,fifo_data[i][7:0]};
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
			/* this is a stupid syntax thing */
			fifo_rdreq[0] <= 'b0;
			fifo_rdreq[1] <= 'b0;
			fifo_rdreq[2] <= 'b0;
			fifo_rdreq[3] <= 'b0;
			fifo_rdreq[4] <= 'b0;
			fifo_rdreq[5] <= 'b0;
			fifo_rdreq[6] <= 'b0;
			fifo_rdreq[7] <= 'b0;

			total <= 'b0;
			count <= 'b0;
			t <= 0;
		end else begin
			//change this if additional output channels
			if(&running) begin //something is already outputting
				//output record
				output_data <= fifo_data[current];
				output_data_valid <= 1'b1;
				fifo_rdreq[current] <= 1'b1;
				//set others to 0
				count <= count + 1;
				t <= t+1;

				//check if last packet to avoid 1 cycle bubble
				if((count+1)==total) begin //last packet 
					running[current] <= 1'b0;					
				end
			end else begin
				if(valid_o) begin //something selected to be output
					current <= pick;
					running[pick] <= 1'b1; //mux on output from submodule
					output_data <= fifo_data[pick];
					output_data_valid <= 1'b1;
					fifo_rdreq[pick] <= 1'b1;
					//set others to 0
					total <= fifo_data[pick][7:0];
					count <= 8'b01;
				end else begin
					/* this is a stupid syntax thing */
					fifo_rdreq[0] <= 'b0;
					fifo_rdreq[1] <= 'b0;
					fifo_rdreq[2] <= 'b0;
					fifo_rdreq[3] <= 'b0;
					fifo_rdreq[4] <= 'b0;
					fifo_rdreq[5] <= 'b0;
					fifo_rdreq[6] <= 'b0;
					fifo_rdreq[7] <= 'b0;
					current <= 'b0;
					output_data_valid <= 1'b0;
					total <= 'b0;
					count <= 'b0;
				end
			end
		end
	end



endmodule

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
/*
genvar j;
generate for(j=0;j<2**NUM_IN_LOG2;j=j+1) begin
	assign counts[j] = t+{24'b0,fifo_data[j][7:0]};
end
endgenerate
*/

	byte unsigned total; //# packets total to output
	byte unsigned count; //current # packets output
	logic [NUM_IN_LOG2-1:0] current;



	//queue_up selects the next packet to send
	queue_up q_inst(.valid_i(valid), .count(counts),
		//.pick(pick), .valid_o(valid_o),.size(size),.*);
		.pick(pick), .valid_o(valid_o),.*);




/* 
 * Send each new packet to the 
 * queue up module along with 
 * its virtual end time
 */
genvar i;
generate for(i=0;i<2**NUM_IN_LOG2;i=i+1) begin
	always_ff @(posedge clk) begin
		if(rst) begin
			valid[i] <= 1'b0; 
			counts[i]<='b0;
		end else begin
			if(!fifo_empty[i] && !running[i]) begin //available for selection
				valid[i] <= 1'b1; //valid if it is available for selection
				if(!valid[i]) begin //need to enqueue
					counts[i] <= t+{24'b0,fifo_data[i][7:0]}; //add virtual time
				end
			end else begin 
				valid[i] <= 1'b0; //not available for selection (already picked)
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
			current <= 'b0; //currently sending
			running <= 'b0; //currently sending 
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

			total <= 'b0; //total packets in current submission
			count <= 'b0; //current packet number
			t <= 0; //virtual time
		end else begin
			//change this if additional output channels
			//if(|running) doesn't work for unpacked
			if(running[0] || running[1] || running[2] ||
				running[3] || running[4] || running[5]||
				running[6] || running[7]) begin //something is already outputting
				
				//output record
				output_data <= fifo_data[current];
				output_data_valid <= 1'b1;
				fifo_rdreq[current] <= 1'b1;

				//set others to 0
				if(pick!=0) begin
					fifo_rdreq[0] <= 1'b0;
				end
				if(pick!=1) begin
					fifo_rdreq[1] <= 1'b0;
				end
				if(pick!=2) begin
					fifo_rdreq[2] <= 1'b0;
				end
				if(pick!=3) begin
					fifo_rdreq[3] <= 1'b0;
				end
				if(pick!=4) begin
					fifo_rdreq[4] <= 1'b0;
				end
				if(pick!=5) begin
					fifo_rdreq[5] <= 1'b0;
				end
				if(pick!=6) begin
					fifo_rdreq[6] <= 1'b0;
				end
				if(pick!=7) begin
					fifo_rdreq[7] <= 1'b0;
				end

				//increment packet count
				count <= count + 1'b1;
				//increment virtual time
				t <= t+1;

				//check if last packet to avoid 1 cycle bubble
				if((count+1'b1)>=total) begin //last packet 
					running[current] <= 1'b0; //turn off current
					count <= 'b0; //reset count

					//fetch next
					//TODO

				end
			end else begin
				if(valid_o) begin //something selected to be output
					current <= pick; //output from queue_up
					running[pick] <= 1'b1; //mux on output from submodule
					output_data <= fifo_data[pick]; //output first packet
					output_data_valid <= 1'b1; //output is valid
					fifo_rdreq[pick] <= 1'b1; //raise ACK

					//set others to 0
					if(pick!=0) begin
						fifo_rdreq[0] <= 1'b0;
					end
					if(pick!=1) begin
						fifo_rdreq[1] <= 1'b0;
					end
					if(pick!=2) begin
						fifo_rdreq[2] <= 1'b0;
					end
					if(pick!=3) begin
						fifo_rdreq[3] <= 1'b0;
					end
					if(pick!=4) begin
						fifo_rdreq[4] <= 1'b0;
					end
					if(pick!=5) begin
						fifo_rdreq[5] <= 1'b0;
					end
					if(pick!=6) begin
						fifo_rdreq[6] <= 1'b0;
					end
					if(pick!=7) begin
						fifo_rdreq[7] <= 1'b0;
					end

					//TODO check for corner case of 
					//only single packet transmission
					total <= fifo_data[pick][7:0]; //get total
					count <= 8'b01;//set count to 1

				end else begin //essentially a reset of state
					/* this is a stupid syntax thing */
					fifo_rdreq[0] <= 'b0;
					fifo_rdreq[1] <= 'b0;
					fifo_rdreq[2] <= 'b0;
					fifo_rdreq[3] <= 'b0;
					fifo_rdreq[4] <= 'b0;
					fifo_rdreq[5] <= 'b0;
					fifo_rdreq[6] <= 'b0;
					fifo_rdreq[7] <= 'b0;
					
					//not currently outputting
					current <= 'b0;
					output_data_valid <= 1'b0;


					total <= 'b0; //reset total
					count <= 'b0; //reset count
				end
			end
		end
	end



endmodule

`timescale 1ns/1ns


module queue_up #(parameter NUM_IN_LOG2=3)
(
	clk, rst,
	count, valid_i,
	pick, valid_o
);
	input logic clk, rst;
	input logic [31:0] count [2**NUM_IN_LOG2-1:0];
	input logic valid_i [2**NUM_IN_LOG2-1:0];
	output logic [NUM_IN_LOG2-1:0] pick;
	//output logic [7:0] size;
	output logic valid_o; 

	integer unsigned min_t; //used to determine when 
				   //integer wraparound is 
				   //occuring

    logic [31:0] min_size;
    logic [NUM_IN_LOG2-1:0] min_index;

    /* nice disgusting combinational block */
    always_comb begin
    	min_size = 32'b1111_1111_1111_1111_1111_1111_1111_1111; //not correct

    	if(valid_i[0] && count[0]<min_size) begin
    		min_size=count[0];
    		min_index = 3'b000;
    	end 
    	if(valid_i[1] && count[1] < min_size) begin
    		min_size=count[1];
    		min_index = 3'b001;
    	end 
    	if(valid_i[2] && count[2] < min_size) begin
			min_size=count[2];
    		min_index = 3'b010;
    	end 
    	if(valid_i[3] && count[3] < min_size) begin
    		min_size=count[3];
    		min_index = 3'b011;
    	end 
    	if(valid_i[4] && count[4] < min_size) begin
    		min_size=count[4];
    		min_index = 3'b100;
    	end 
    	if(valid_i[5] && count[5] < min_size) begin
    		min_size=count[5];
    		min_index = 3'b101;
    	end 
    	if(valid_i[6] && count[6] < min_size) begin
    		min_size=count[6];
    		min_index = 3'b110;
    	end 
    	if(valid_i[7] && count[7] < min_size) begin
    		min_size=count[7];
    		min_index = 3'b111;
    	end
    end
    


	always_ff @(posedge clk) begin
		if(rst) begin
			pick <= 'b0;
			//size <= 'b0;
			valid_o <= 1'b0;
			min_t <= 0;
		end else begin
			//if(|valid_i) begin // doesnt work?
			if(valid_i[0] || valid_i[1] || valid_i[2] ||
				valid_i[3] || valid_i[4] || valid_i[5] ||
				valid_i[6] || valid_i[7]) begin //if any valid inputs
				//size <= min_size;
				pick <= min_index;
				valid_o <= 1'b1;
				if(&min_t) begin
				end
			end else begin
				valid_o <= 1'b0;
			end
		end
	end

endmodule

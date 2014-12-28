/* Project: DAU
 * Owner: Tim Paine
 */
module fq_tb();
  parameter NUM_IN_LOG2=3;

  logic clk;
  logic rst;
  logic fifo_empty [2**NUM_IN_LOG2-1:0];
  logic [63:0] fifo_data [2**NUM_IN_LOG2-1:0];
  logic fifo_rdreq [2**NUM_IN_LOG2-1:0];
  logic output_data_valid;
  logic [63:0] output_data;

  fq #(.NUM_IN_LOG2(NUM_IN_LOG2))
  fq_inst(.*);


  initial begin
    //$vcdpluson;
    clk = 0;
    rst = 1;

    //reset   
    #1 clk = 1;
    #1 clk = 0;
    #1 $finish;
  end

  initial  begin
     $display("output_data \t output_data_valid");
     $monitor("%d,%d", output_data, output_data_valid);
  end


endmodule



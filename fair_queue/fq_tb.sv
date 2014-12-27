/* Project: DAU
 * Owner: Tim Paine
 */
module fq_tb();
  parameter NUM_IN_LOG2=3;

  logic clk;
  logic rst;
 
  fq #(.NUM_IN_LOG2(NUM_IN_LOG2))
  fq_inst(.*);


  initial begin
    $vcdpluson();
    clk = 0;
    rst = 1;

    //reset   
    #1 clk = 1;
    #1 clk = 0;
    #1 $finish;
  end

  initial  begin
     $display("");
     $monitor("%b", clk);
  end


endmodule



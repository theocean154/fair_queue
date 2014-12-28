#include "Vfq.h"
#include "verilated.h"
#include "verilated_vcd_c.h"


int main(int argc, char **argv, char **env) {
  int i;
  int clk;
  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vfq* top = new Vfq;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("fq.vcd");
  // initialize simulation inputs
  top->clk = 1;
  top->rst = 1;
  top->fifo_empty[0] = 0;
  top->fifo_empty[1] = 0;
  top->fifo_empty[2] = 0;
  top->fifo_empty[3] = 1;
  top->fifo_empty[4] = 1;
  top->fifo_empty[5] = 1;
  top->fifo_empty[6] = 1;
  top->fifo_empty[7] = 1;
  top->fifo_data[0] = 100;
  top->fifo_data[1] = 50;
  top->fifo_data[2] = 25;

  //top->cen = 0;
  //top->wen = 0;
  //top->dat = 0x55;
  // run simulation for 100 clock periods
  for (i=0; i<400; i++) {
    top->rst = (i < 2);
    // dump variables into VCD file and toggle clock
    for (clk=0; clk<2; clk++) {
      tfp->dump (2*i+clk);
      top->clk = !top->clk;
      top->eval ();
    }
    //top->cen = (i > 5);
    //top->wen = (i == 10);
    if (Verilated::gotFinish())  exit(0);
  }
  tfp->close();
  exit(0);
}
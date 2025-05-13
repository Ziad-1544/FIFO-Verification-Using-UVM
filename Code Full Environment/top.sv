/////////////////////////////////////////////////////////////
// Top Module:
// Step 1: import uvm_pkg & test_pkg & include `include"uvm_macros.svh"
// Step 2: Clock Generation
// Step 3: Instantiate the interface & pass the parameters through '.' operator to avoid editing the design 
// Step 4: Initial block -> set the virtual interface in the database & run the test
////////////////////////////////////////////////////////////
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_test_pkg::*;

module top();
  //CLK Generation
  bit clk;
  always #1 clk = ~clk;
  //Interface Instantiation
  FIFO_if fifo_if(clk);
  //DUT instantiation
  FIFO DUT(.fifo_if(fifo_if));
  //Assertion
  bind FIFO FIFO_SVA SVA(.fifo_if(fifo_if));

  initial begin
    //                                                        who can get access
    //saving func   data type of variable       which class     "known name"    key to call the variable back    what you will pass to the database
    uvm_config_db #(virtual FIFO_if)::set(    null       ,"uvm_test_top",         "FIFO_IF"           ,               fifo_if             );
    run_test("FIFO_test");
  end

endmodule
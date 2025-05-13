import Shared_pkg::*;
module FIFO_SVA (FIFO_if.DUT fifo_if);
//Combinational flags
property FULL_FLAG;
    @(posedge fifo_if.clk) fifo_if.rst_n |-> (fifo_if.full == (top.DUT.count == FIFO_DEPTH));
endproperty

property EMPTY_FLAG;
    @(posedge fifo_if.clk) fifo_if.rst_n |-> (fifo_if.empty == (top.DUT.count == 0));
endproperty

property ALMOST_FULL_FLAG;
    @(posedge fifo_if.clk) fifo_if.rst_n |-> (fifo_if.almostfull == (top.DUT.count == FIFO_DEPTH-1));
endproperty

property ALMOST_EMPTY_FLAG;
    @(posedge fifo_if.clk) fifo_if.rst_n |-> (fifo_if.almostempty == (top.DUT.count == 1));
endproperty

// Reset condition assertions
property COUNT_RESET;
    @(posedge fifo_if.clk) !fifo_if.rst_n |-> (top.DUT.count == 0);
endproperty

property WR_PTR_RESET;
    @(posedge fifo_if.clk) !fifo_if.rst_n |-> (top.DUT.wr_ptr == 0);
endproperty

property RD_PTR_RESET;
    @(posedge fifo_if.clk) !fifo_if.rst_n |-> (top.DUT.rd_ptr == 0);
endproperty


//Sequential Flags:
property OVERFLOW;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) fifo_if.full && fifo_if.wr_en |=> fifo_if.overflow;
endproperty

property UNDERFLOW;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) fifo_if.empty && fifo_if.rd_en |=> fifo_if.underflow;
endproperty
property WR_ACK;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) fifo_if.wr_en && top.DUT.count<FIFO_DEPTH  |=> fifo_if.wr_ack;
endproperty

//Pointers assertions:
property PTR_EXCEEDED;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (top.DUT.wr_ptr < FIFO_DEPTH) && (top.DUT.rd_ptr < FIFO_DEPTH);
endproperty 

property WR_PTR_WRAPAROUND;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) top.DUT.wr_ptr == {max_fifo_addr{1'b1}} && fifo_if.wr_en && top.DUT.count < FIFO_DEPTH |=> top.DUT.wr_ptr == {max_fifo_addr{1'b0}};
endproperty

property RD_PTR_WRAPAROUND;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) top.DUT.rd_ptr == {max_fifo_addr{1'b1}} && fifo_if.rd_en && top.DUT.count > 0 |=> top.DUT.rd_ptr == 0;
endproperty



// Assertions for sequential flags:
assert property(OVERFLOW) 			else $error("Overflow flag assertion failed");
assert property(UNDERFLOW) 			else $error("Underflow flag assertion failed");


// Assert Combinational flags:
assert property(FULL_FLAG) 			else $error("Full flag incorrect");
assert property(EMPTY_FLAG) 		else $error("Empty flag assertion failed");
assert property(ALMOST_FULL_FLAG) 	else $error("Almost Full flag assertion failed");
assert property(ALMOST_EMPTY_FLAG) 	else $error("Almost Empty flag assertion failed");
assert property(COUNT_RESET) 		else $error("Count reset assertion failed");
assert property(WR_PTR_RESET) 		else $error("Write ptr reset assertion failed");
assert property(RD_PTR_RESET) 		else $error("Read ptr reset assertion failed");
// Assertions for sequential flags:
assert property(WR_ACK) 			else $error("Write Acknowledge flag assertion failed");

// Assertion for pointers not exceeding FIFO depth:
assert property(PTR_EXCEEDED) 		else $error("Pointers exceeded FIFO depth");

// Assertions for pointer wraparound:
assert property(WR_PTR_WRAPAROUND) 	else $error("Write pointer wraparound assertion failed");
assert property(RD_PTR_WRAPAROUND) 	else $error("Read pointer wraparound assertion failed");

// Cover properties to verify they can be reached:
cover property(OVERFLOW);
cover property(UNDERFLOW);

// Cover properties to verify they can be reached:
cover property(FULL_FLAG);
cover property(EMPTY_FLAG);
cover property(ALMOST_FULL_FLAG);
cover property(ALMOST_EMPTY_FLAG);
cover property(WR_ACK);
cover property(PTR_EXCEEDED);
cover property(WR_PTR_WRAPAROUND);
cover property(RD_PTR_WRAPAROUND);
cover property(COUNT_RESET);
cover property(WR_PTR_RESET);
cover property(RD_PTR_RESET);

endmodule
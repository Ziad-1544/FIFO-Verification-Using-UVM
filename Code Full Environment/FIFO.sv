////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if.DUT fifo_if);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
 
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

//Write Operation & sequential Flags handling:
always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		wr_ptr <= 0;
		fifo_if.wr_ack <= 0; 	// all flags should be resetted
		fifo_if.overflow <= 0;	// all flags should be resetted
	end
	else if (fifo_if.wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= fifo_if.data_in;
		fifo_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		fifo_if.overflow <= 0;
	end
	else begin 
		fifo_if.wr_ack <= 0; 
		//if (fifo_if.full & fifo_if.wr_en)------->Warning: this statement is not a bitwise operation 
											//-> better to use && (meanwhile & will do the same job because oprands are 1 bit) 
		if (fifo_if.full && fifo_if.wr_en)
			fifo_if.overflow <= 1;
		else begin
			fifo_if.overflow <= 0;
		end
	end
end

//Read operation:
always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		fifo_if.underflow <= 0;	// all flags should be resetted
		rd_ptr <= 0;
	end
	else if (fifo_if.rd_en && count > 0) begin
		fifo_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		fifo_if.underflow <= 0; // handling Underflow sequentially 
	end
	else if ( fifo_if.empty && fifo_if.rd_en)begin
		fifo_if.underflow <= 1; // handling Underflow sequentially
	end
end

//Counter handling:
always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b10) && !fifo_if.full) 
			count <= count + 1;
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b01) && !fifo_if.empty)
			count <= count - 1;
		//--------------------------------------->No handling for cases when both fifo_if.wr_en & fifo_if.rd_en are enabled 
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && fifo_if.empty)
			count <= count + 1;
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && fifo_if.full)
			count <= count - 1;
	end
end

assign fifo_if.full = (count == FIFO_DEPTH)? 1 : 0;
assign fifo_if.empty = (count == 0)? 1 : 0;
//assign fifo_if.underflow = (fifo_if.empty && fifo_if.rd_en)? 1 : 0; ------>ERROR : This flag is sequential not combinational 
//assign fifo_if.almostfull = (count == FIFO_DEPTH-2)? 1 : 0;--------------->ERROR : rising the flag when only 1 slot left not 2
assign fifo_if.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 
assign fifo_if.almostempty = (count == 1)? 1 : 0;

//Combinational flags
property FULL_FLAG;
    @(posedge fifo_if.clk) fifo_if.rst_n |-> (fifo_if.full == (count == FIFO_DEPTH));
endproperty

property EMPTY_FLAG;
    @(posedge fifo_if.clk) fifo_if.rst_n |-> (fifo_if.empty == (count == 0));
endproperty

property ALMOST_FULL_FLAG;
    @(posedge fifo_if.clk) fifo_if.rst_n |-> (fifo_if.almostfull == (count == FIFO_DEPTH-1));
endproperty

property ALMOST_EMPTY_FLAG;
    @(posedge fifo_if.clk) fifo_if.rst_n |-> (fifo_if.almostempty == (count == 1));
endproperty

// Reset condition assertions
property COUNT_RESET;
    @(posedge fifo_if.clk) !fifo_if.rst_n |-> (count == 0);
endproperty

property WR_PTR_RESET;
    @(posedge fifo_if.clk) !fifo_if.rst_n |-> (wr_ptr == 0);
endproperty

property RD_PTR_RESET;
    @(posedge fifo_if.clk) !fifo_if.rst_n |-> (rd_ptr == 0);
endproperty


//Sequential Flags:
property WR_ACK;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) fifo_if.wr_en && count<FIFO_DEPTH  |=> fifo_if.wr_ack;
endproperty

//Pointers assertions:
property PTR_EXCEEDED;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (wr_ptr < FIFO_DEPTH) && (rd_ptr < FIFO_DEPTH);
endproperty 

property WR_PTR_WRAPAROUND;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) wr_ptr == {max_fifo_addr{1'b1}} && fifo_if.wr_en && count < FIFO_DEPTH |=> wr_ptr == {max_fifo_addr{1'b0}};
endproperty

property RD_PTR_WRAPAROUND;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) rd_ptr == {max_fifo_addr{1'b1}} && fifo_if.rd_en && count > 0 |=> rd_ptr == 0;
endproperty

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
////////////////////////////////////////////////////////////////////////////////
//FIFO Interface
////////////////////////////////////////////////////////////////////////////////
interface FIFO_if (input bit clk);
    logic [15:0] data_in;
    logic rst_n, wr_en, rd_en;
    logic [15:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;

    modport DUT (input data_in,rst_n,wr_en,rd_en,clk, 
    output data_out,wr_ack,overflow,full,empty,almostfull,almostempty,underflow 
    );
endinterface    
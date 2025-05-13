////////////////////////////////////////////////////////////////////////////////
//Shift register shared package
// - for enums and any other typedefs need for the project
////////////////////////////////////////////////////////////////////////////////
package Shared_pkg;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    localparam max_fifo_addr = $clog2(FIFO_DEPTH);
    //singals for seq_item
    logic RD_ACTIVE,WR_ACTIVE;
    int RD_EN_ON_DIST=30,WR_EN_ON_DIST=70;
endpackage
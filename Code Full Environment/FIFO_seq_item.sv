///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// UVM Sequence Item: <OBJECT>
// Step 1: Import uvm_pkg and include `uvm_macros.svh`.
// Step 2: Create the class extended from the original uvm_sequence_item class.
// Step 3: Register the class name in the factory using `uvm_object_utils(<class_name>);`.
// Step 4: Initialize all signals and add rand/randc to the required variables for randomization purposes.
//         Also, configure (cfg) as needed. If variables are used, create a handle for your custom-made database.
// Step 5: Create the extended constructor with default values, name="<class_name>".
// Step 6: Implement the ToString functions that will be used later in UVM_info. 
//         Remember that UVM_info only prints strings.
// Step 7: Add your constraints.
//
// Class Importance:
//   - This class is used to create the object passed to sequences (e.g., main & reset) using the sequencer (~FIFO),
//     which passes the randomized values to the driver.
//   - This class contains all the variables with the rand option for randomization purposes.
//   - This class also contains all the constraints for randomization.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
package FIFO_seq_item_pkg;
import uvm_pkg::*;
import Shared_pkg::*;
`include "uvm_macros.svh"

    class FIFO_seq_item extends uvm_sequence_item;
        `uvm_object_utils(FIFO_seq_item)
    
        rand logic [15:0] data_in;
        rand logic rst_n, wr_en, rd_en;
        logic [15:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;
        
        function new(string name="FIFO_seq_item");
            super.new(name);
        endfunction
    
        function string convert2string();
            return $sformatf("%s data_in=0x%0h, rst_n=%0b, wr_en=%0b, rd_en=%0b, data_out=0x%0h, wr_ack=%0b, overflow=%0b, full=%0b, empty=%0b, almostfull=%0b, almostempty=%0b, underflow=%0b", 
             super.convert2string(), data_in, rst_n, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
        endfunction
        
        function string convert2string_stimulus();
            return $sformatf("data_in=0x%0h, rst_n=%0b, wr_en=%0b, rd_en=%0b", 
                 data_in, rst_n, wr_en, rd_en);
        endfunction
         constraint rst_const{
            rst_n dist{0:=5,1:=95};
        }

        constraint wr_en_const {
            if (WR_ACTIVE) 
            wr_en dist {1:=WR_EN_ON_DIST, 0:=(100-WR_EN_ON_DIST)};
            else 
            wr_en == 0;
        }

        constraint rd_en_const {
            if (RD_ACTIVE)
            rd_en dist {1:=RD_EN_ON_DIST, 0:=(100-RD_EN_ON_DIST)};
            else
            rd_en == 0;
        }
        
        constraint data_in_const {
            data_in dist {16'h0000:=10, 16'hFFFF:=10, [16'h0001:16'hFFFE]:=80};
        }
        
        constraint sequential_ops {
            rd_en && wr_en dist {1:=30, 0:=70};
        }

    endclass
endpackage
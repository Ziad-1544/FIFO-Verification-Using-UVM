///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// UVM Sequencer: <OBJECT>
// Step 1: Import uvm_pkg & include `uvm_macros.svh` 
//         Import seq_item_pkg  
// Step 2: Create the class extended from the original uvm_sequencer class with a parameter of seq_item class
// Step 3: Register the class name in the factory using `uvm_OBJECT_utils(<class_name>);
// Step 4: Define the extended constructor with default values name = "<class_name>"
//
// Class Importance:
//   - This class performs a similar job as a FIFO used for synchronization, as it manages the transfer of sequence items between the sequences and the driver.
//   - The sequence driver flow is as follows:
//     Sequence item --> Sequence1 ||  Sequencer   ||       Driver       || Interface/DUT
//                      start_item()----------------> get_next_item
//                                                         |      
//                      assert(item.randomize) <-----------
//                      finish_item()---------------> after passing in VIF 
//                                                        |  
//                                                     item_done()
//   - The illustrated algorithm helps in the case of multiple sequences, where each does not know when to assert the data to the driver. Using this algorithm, everything becomes organized.
//   - As this is an object or a component, it is connected to the driver through TLM_export and TLM_port.
//     "Remember: export & port are only for 1-to-1 connections."
//
// IMPORTANT QUESTION: 
// As we learned, the sequencer acts as a FIFO to synchronize between different sequences, but from the code seen below, we can't find anything that describes this explanation.
// Why? Because this is an extended version. In the uvm_sequencer class, the FIFO functionality is implemented.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
package FIFO_sequencer_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_seq_item_pkg::*;

    class FIFO_sequencer extends uvm_sequencer #(FIFO_seq_item);
        `uvm_component_utils(FIFO_sequencer)
    
        function new(string name = "Mysequencer",uvm_component parent = null);
            super.new(name,parent);
        endfunction

    endclass
endpackage
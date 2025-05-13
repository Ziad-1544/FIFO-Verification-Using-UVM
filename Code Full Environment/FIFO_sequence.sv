///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// UVM Sequence: <OBJECT>
// Step 1: Import uvm_pkg and include `uvm_macros.svh`.
//         Import config_pkg to create the agent.
// Step 2: Create a class for each sequence (e.g., rst, main) extended from the original uvm_sequence class 
//         with a parameter of seq_item class.
// Step 3: Register the class name in the factory using `uvm_object_utils(<class_name>);`.
// Step 4: Create the constructor with default values, e.g., name = "<class_name>".
// Step 5: Implement the task body that actually runs the sequence algorithm. 
//         First, create the sequence from the seq_item class.
//         "Remember: The rest of the body should be between start_item and finish_item to drive values to the driver 
//         when called only."
//
// Class Importance:
//   - This is the class used to drive values over wires of seq_item in normal test benches.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
package FIFO_sequence_pkg;
import uvm_pkg::*;
import Shared_pkg::*;
`include "uvm_macros.svh"
import FIFO_seq_item_pkg::*;
    //FIFO_1
    class FIFO_rst_seq extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_rst_seq)
    
        FIFO_seq_item seq_item;
    
        function new(string name ="FIFO_rst_sequence");
            super.new(name);
        endfunction
    
        task body;
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst_n=0;
            finish_item(seq_item);
        endtask

    endclass
    //FIFO_2
    class FIFO_main1_seq extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_main1_seq)

        FIFO_seq_item seq_item;

        function new(string name ="FIFO_main1_sequence");
            super.new(name);
        endfunction

        task body;
            repeat(10)begin    
                seq_item = FIFO_seq_item::type_id::create("seq_item");
                WR_ACTIVE=1;
                RD_ACTIVE=0;
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask
    endclass

    //FIFO_3
    class FIFO_main2_seq extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_main2_seq)

        FIFO_seq_item seq_item;

        function new(string name ="FIFO_main2_sequence");
            super.new(name);
        endfunction

        task body;
            repeat(10)begin    
                seq_item = FIFO_seq_item::type_id::create("seq_item");
                WR_ACTIVE=0;
                RD_ACTIVE=1;
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask
    endclass

    //FIFO_4
    class FIFO_main3_seq extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_main3_seq)

        FIFO_seq_item seq_item;

        function new(string name ="FIFO_main3_sequence");
            super.new(name);
        endfunction

        task body;
             repeat(1000) begin
                repeat(6)begin
                    seq_item = FIFO_seq_item::type_id::create("seq_item");
                    WR_ACTIVE=1;
                    RD_ACTIVE=0;
                    start_item(seq_item);
                    assert(seq_item.randomize());
                    finish_item(seq_item);
                end
                repeat(6)begin
                    seq_item = FIFO_seq_item::type_id::create("seq_item");
                    WR_ACTIVE=0;
                    RD_ACTIVE=1;
                    start_item(seq_item);
                    assert(seq_item.randomize());
                    finish_item(seq_item);
                end
             end   
        endtask
    endclass
    //FIFO_5
    class FIFO_main4_seq extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_main4_seq)

        FIFO_seq_item seq_item;

        function new(string name ="FIFO_main4_sequence");
            super.new(name);
        endfunction

        task body;
            repeat(5000)begin    
                seq_item = FIFO_seq_item::type_id::create("seq_item");
                WR_ACTIVE=1;
                RD_ACTIVE=1;
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end 
        endtask
    endclass

endpackage
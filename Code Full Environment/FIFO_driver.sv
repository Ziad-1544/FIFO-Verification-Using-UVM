///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// UVM Driver: <COMPONENT>
// Step 1: Import uvm_pkg and include `uvm_macros.svh`.
//         Import config_pkg: to create the agent.
//         Import sequence_item_pkg: to create the coverage.
// Step 2: Create the class extended from the original uvm_driver class with parameter seq_item class.
// Step 3: Save the class name in the factory using `uvm_component_utils(<class_name>);`.
// Step 4: Create handles for VIF, CFG, and Seq_item.
//         Remember, CFG is used (as long as you will use variables, so you should make a handle of your custom-made database).
// Step 5: Make the extended constructor with default values name="<class name>" and parent=null.
// Step 6: In the extended run phase, in a forever loop:
//         1) Create the sequence_item_var.
//            Why create it inside, not outside the loop?
//            - stim_seq_item? It's like a small paper with instructions: “What values should we send to the DUT in this clock cycle?”
//            - Every time we want to drive new signals, we need a new paper with new values.
//            - UVM likes to keep a history of each paper.
//            - If you use the same paper and keep changing it, UVM will only remember the last version.
//         2) Call get_next_item() to stimulate the sequence to randomize or get your data.
//         3) After making sure the data is sent, wait for @negedge clk.
//         4) Call item_done().
//         5) Use `uvm_info` to print the data in case of verbosity UVM_HIGH.
//
//         Now it comes to the question: why in a forever loop and when will it stop?
//         - Actually, it depends on the sequence. If the sequence has sent all values (e.g., finished the repeat loop),
//           then the code will stop at get_next_item(), waiting.
//
//         So now, how will the application stop?
//         - The application will stop at the drop objection of the test that comes just after all sequences are done. ;)
//
//         How is the data sent to the interface or the DUT? --> Through the VIF. That's why we imported the config variable.
// IMPORTANT QUESTION:
// - Why did we make the config object and use the VIF, not the config?
//   Because at this scale, there is no need to, but later when using multi-agent, you will understand the importance of the config object.
// IMPORTANT QUESTION:
// - Why do the driver, sequencer, and sequence need a parameter of seq_item, but the monitor doesn't?
//   Because all of them are based on the sequence_item (e.g., constraints of randomization), but the monitor gets its values from the interface, AKA DUT.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
package FIFO_driv_pkg;
 import uvm_pkg::*;
 import FIFO_config_pkg::*;
 import FIFO_seq_item_pkg::*;
`include "uvm_macros.svh"

    class FIFO_driv extends uvm_driver #(FIFO_seq_item);
        `uvm_component_utils(FIFO_driv)

        virtual FIFO_if FIFO_vif;
        FIFO_config FIFO_cfg;
        FIFO_seq_item stim_seq_item;

        function  new(string name ="FIFO_driv",uvm_component parent = null);
            super.new(name,parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                stim_seq_item=FIFO_seq_item::type_id::create("stim_seq_item");
                seq_item_port.get_next_item(stim_seq_item);
                FIFO_vif.data_in = stim_seq_item.data_in;
                FIFO_vif.wr_en = stim_seq_item.wr_en;
                FIFO_vif.rd_en = stim_seq_item.rd_en;
                FIFO_vif.rst_n = stim_seq_item.rst_n;
                @(negedge FIFO_vif.clk);
                seq_item_port.item_done();
                `uvm_info("run_phase",stim_seq_item.convert2string_stimulus(),UVM_HIGH);
            end
        endtask

    endclass
endpackage

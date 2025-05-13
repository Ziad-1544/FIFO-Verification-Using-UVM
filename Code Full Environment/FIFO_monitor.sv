///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// UVM Monitor: <COMPONENT>
// Step 1: Import uvm_pkg & include `uvm_macros.svh` 
//         Import config_pkg: to create the agent 
//         Import sequence_item_pkg: to create the coverage 
// Step 2: Create the class extended from the original uvm_monitor class 
// Step 3: Register the class name in the factory using `uvm_component_utils(<class_name>);
// Step 4: Create handles for VIF, Seq_item & initialize an analysis port to send the data received to coverage & scoreboard
//         & remember CFG used (as long as you will use variables, you should make a handle of your custom-made database)
// Step 5: Make the extended constructor with default values name="<class name>" & parent = null
// Step 6: In the extended build phase: create the analysis port 
// Step 7: In the extended run phase: in a forever loop: 
//                                       1) Create the seq_item
//                                       2) Sample at each negedge clk
//                                       3) Take values from the VIF and write them to the analysis port 
//                                       4) Add a UVM_INFO to print the values in the transcript in case of Verbosity UVM_HIGH
// IMPORTANT QUESTION:
// - Why did we make the config object and use the VIF instead of the config?
//   Because at this scale there is no need, but later when using multi-agent, you will understand the importance of the config object.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
package FIFO_monitor_pkg;
import uvm_pkg::*;
import FIFO_config_pkg::*;
import FIFO_seq_item_pkg::*;
import Shared_pkg::*;
`include "uvm_macros.svh"
    class FIFO_monitor extends uvm_monitor;

        `uvm_component_utils(FIFO_monitor)

        virtual FIFO_if FIFO_vif;
        FIFO_seq_item rsp_seq_item; 
        uvm_analysis_port #(FIFO_seq_item) mon_ap; 

        function new(string name ="FIFO_monitor",uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap=new("mon_ap",this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                rsp_seq_item =FIFO_seq_item::type_id::create("rsp_seq_item");
                @(negedge FIFO_vif.clk);
                rsp_seq_item.data_in    = FIFO_vif.data_in    ;
                rsp_seq_item.wr_en      = FIFO_vif.wr_en      ;
                rsp_seq_item.rd_en      = FIFO_vif.rd_en      ;
                rsp_seq_item.rst_n      = FIFO_vif.rst_n      ;
                rsp_seq_item.data_out   = FIFO_vif.data_out   ;
                rsp_seq_item.full       = FIFO_vif.full       ;
                rsp_seq_item.almostfull = FIFO_vif.almostfull ;
                rsp_seq_item.empty      = FIFO_vif.empty      ;
                rsp_seq_item.almostempty= FIFO_vif.almostempty;
                rsp_seq_item.overflow   = FIFO_vif.overflow   ;
                rsp_seq_item.underflow  = FIFO_vif.underflow  ;
                rsp_seq_item.wr_ack     = FIFO_vif.wr_ack     ;
                mon_ap.write(rsp_seq_item);
                `uvm_info("run_phase",rsp_seq_item.convert2string(),UVM_HIGH);
            end
        endtask

    endclass
endpackage
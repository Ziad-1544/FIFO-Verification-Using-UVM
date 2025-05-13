/////////////////////////////////////////////////////////////
// UVM TEST: <COMPONENT> 
// Step 1: Import uvm_pkg and include `uvm_macros.svh`.
//         Import env_pkg: to create the environment.
//         Import config_pkg: to create the config object (your custom-made database).
//         Import sequence_pkg: to create your needed sequences.
// Step 2: Create the class extended from the original uvm_test class.
// Step 3: Register the class name in the factory using `uvm_component_utils(<class_name>);`.
// Step 4: Create handles for the environment, sequences, and config.
// Step 5: Define the extended constructor with default values: name="<class_name>" and parent=null.
// Step 6: In the extended build phase, create each component/sequence, get the interface to "cfg.vif" variable, 
//         and finally set your custom-made database in the uvm_config_db.
/////////////////////////////////////////////////////////////
package FIFO_test_pkg;

import FIFO_env_pkg::*;
import FIFO_config_pkg::*;
import FIFO_sequence_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

  class FIFO_test extends uvm_test;
      `uvm_component_utils(FIFO_test);

      FIFO_env env;
      FIFO_config FIFO_cfg;
      FIFO_main1_seq main1_seq;
      FIFO_main2_seq main2_seq;
      FIFO_main3_seq main3_seq;
      FIFO_main4_seq main4_seq;
      FIFO_rst_seq rst_seq;

      function new(string name="FIFO_test",uvm_component parent = null);
        super.new(name,parent);
      endfunction

      function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env=FIFO_env::type_id::create("env",this);
        FIFO_cfg=FIFO_config::type_id::create("FIFO_cfg",this);
        main1_seq=FIFO_main1_seq::type_id::create("main1_seq",this);
        main2_seq=FIFO_main2_seq::type_id::create("main2_seq",this);
        main3_seq=FIFO_main3_seq::type_id::create("main3_seq",this);
        main4_seq=FIFO_main4_seq::type_id::create("main4_seq",this);
        rst_seq=FIFO_rst_seq::type_id::create("rst_seq",this);
           //                                                        no need to fill,this is   
           //saving func   data type of variable       which class   access field in setting   key to call the variable back          varibale type name
        if(!uvm_config_db #(virtual FIFO_if)::get(   this    ,            ""                  ,"FIFO_IF",              FIFO_cfg.FIFO_vif)   )begin
            `uvm_fatal("build_phase","test-unable to get the configuration object")
        end
        //                                         anyone
        uvm_config_db #(FIFO_config)::set(this,"*","CFG",FIFO_cfg);
      endfunction

      task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
//    To display a msg                             ----> verbosity  
        `uvm_info("run_phase","welcome to the uvm env.",UVM_MEDIUM);

        //RST SEQUENCE
        `uvm_info("run_phase","Reset Asserted.",UVM_LOW);
        rst_seq.start(env.agt.sqr);
        `uvm_info("run_phase","Reset Desserted.",UVM_LOW);

        //MAIN1_SEQUENCE
        `uvm_info("run_phase","Main1 started.",UVM_LOW);
        main1_seq.start(env.agt.sqr);
        `uvm_info("run_phase","Main1 Finished.",UVM_LOW);
        
        //MAIN2_SEQUENCE
        `uvm_info("run_phase","Main2 started.",UVM_LOW);
        main2_seq.start(env.agt.sqr);
        `uvm_info("run_phase","Main2 Finished.",UVM_LOW);
        
        //MAIN3_SEQUENCE
        `uvm_info("run_phase","Main3 started.",UVM_LOW);
        main3_seq.start(env.agt.sqr);
        `uvm_info("run_phase","Main3 Finished.",UVM_LOW);
        
        //MAIN4_SEQUENCE
        `uvm_info("run_phase","Main4 started.",UVM_LOW);
        main4_seq.start(env.agt.sqr);
        `uvm_info("run_phase","Main4 Finished.",UVM_LOW);

        phase.drop_objection(this);
      endtask:run_phase

  endclass: FIFO_test
endpackage
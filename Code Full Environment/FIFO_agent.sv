///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// UVM Agent: <COMPONENT>
// Step 1: Import uvm_pkg and include `uvm_macros.svh` 
//         Import config_pkg: to create the agent 
//         Import driver_pkg: to create the driver 
//         Import monitor_pkg: to create the monitor 
//         Import sequencer_pkg: to create the sequencer 
//         Import sequence_item_pkg: to create the sequence item 
//         Import sequence_pkg: to create the sequences (e.g., reset, main) 
// Step 2: Create the class extended from the original uvm_agent class.
// Step 3: Register the class name in the factory using `uvm_component_utils(<class_name>);
// Step 4: Create handles for sqr, mon, drv, agt_port, 
//         and cfg (as long as you will use variables, you should create a handle for your custom-made database).
// Step 5: Define the extended constructor with default values: name="<class_name>" and parent=null.
// Step 6: In the extended build phase: create each component/sequence/agt_port
//         and finally get your custom-made database to your cfg handle.
// Step 7: In the extended connect phase: connect the handle of drv.vif to the virtual interface of your database,
//         and do the same for the monitor.vif handle. Connect the export of the sequencer to the port of the driver,
//         and finally connect the monitor_analysis_port to the agent_analysis_port.
//
// Class Importance:
//   - What if we have a very complicated project and we need to create separate agents (separate drivers & monitors) 
//     to test specific modules in the project?
//   - You can reuse the agent in multiple environments, testbenches, or DUTs.
//   --> Instead of rewriting the driver/monitor logic every time, just plug in the agent wherever you need it.
//   - Agents organize protocol-specific components (driver, monitor, sequencer).
//   - They make your testbench modular, reusable, scalable, and flexible.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
package FIFO_agent_pkg;
    import uvm_pkg::*;
    import FIFO_config_pkg::*;
    import FIFO_driv_pkg::*;
    import FIFO_monitor_pkg::*;
    import FIFO_sequencer_pkg::*;
    import FIFO_seq_item_pkg::*;
    import FIFO_sequence_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_agent extends uvm_agent;
        `uvm_component_utils(FIFO_agent)

        FIFO_sequencer sqr;
        FIFO_monitor mon;
        FIFO_driv drv;
        FIFO_config FIFO_cfg;
        uvm_analysis_port #(FIFO_seq_item) agt_ap;

        function new(string name = "FIFO_agent" , uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(FIFO_config)::get(this,"","CFG",FIFO_cfg))begin
                `uvm_fatal("build_phase","unable to get the configuration object")
            end
            sqr=FIFO_sequencer::type_id::create("sqr",this);
            mon=FIFO_monitor::type_id::create("mon",this);
            drv=FIFO_driv::type_id::create("drv",this);
            agt_ap = new ("agt_ap",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
//IMP QUESTION:
/*          how is the vif of the driver who is connected to vif of the conf , wasn't the driver how drives the the values and he is the one assigned?
yes, the driver drives the values after getting it from the sequences , as the driver signal in its class is connected to the config vif to be avaible accross all other component 
,if you checked the flow of values in the chart , you will found that the driver's VIF who is passed to the DUT & INTERFACE, from these 2 point we understand now 
why is the driver assigned and not virse versa
*/
            drv.FIFO_vif = FIFO_cfg.FIFO_vif;
            mon.FIFO_vif = FIFO_cfg.FIFO_vif;
            drv.seq_item_port.connect(sqr.seq_item_export);
            mon.mon_ap.connect(agt_ap);
            //Connect is used when connecting a port/export or analysis port while assigning for normal signal wires 
        endfunction
    endclass
endpackage
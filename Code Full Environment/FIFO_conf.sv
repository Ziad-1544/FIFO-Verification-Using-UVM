/////////////////////////////////////////////////////////////
// UVM TEST:
// Step 1: Import uvm_pkg & include `uvm_macros.svh` 
//         Import env_pkg: to create the environment 
//         Import config_pkg: to create the config component (your custom-made database)
//         Import sequence_pkg: to create your needed sequences 
// Step 2: Create a class extended from the original uvm_test class
// Step 3: Register the class name in the factory using `uvm_component_utils(<class_name>`);
// Step 4: Create the extended constructor with default values name="<class_name>" & parent=null
// Step 5: In the extended build phase: create each component/sequence, get the interface to "cfg.vif" variable, 
//         and finally set your custom-made database in the uvm_database.
//
//
// Class Importance:
//    - Did you think about how we can connect the real interface that is connected to the DUT, to the Driver / Scoreboard / Coverage?
//    - This file acts as a custom-made database with mainly the virtual interface and also any other needed variables. 
//    - Instead of creating variables everywhere, just create a variable of this class, and all needed sub-variables are accessible.  
/////////////////////////////////////////////////////////////

package FIFO_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

    class FIFO_config extends uvm_object;
        `uvm_object_utils(FIFO_config);
    
        virtual FIFO_if FIFO_vif;
    
        function new(string name ="FIFO_config");
            super.new(name);
        endfunction

    endclass
endpackage
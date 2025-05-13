///////////////////////////////////////////////////////////////////////////////////////////////////////////
// UVM ENV: <COMPONENT>
// Step 1: Import uvm_pkg and include `uvm_macros.svh`.
//         Import FIFO_agent_pkg to create the agent.
//         Import FIFO_scoreboard_pkg to create the scoreboard.
//         Import FIFO_coverage_pkg to create the coverage.
// Step 2: Create a class that extends the original uvm_env class.
// Step 3: Register the class with the factory using `uvm_component_utils(<class_name>);`.
// Step 4: Create handles for the agent, coverage, and scoreboard.
// Step 5: Define the constructor with default values: name="<class_name>" and parent=null.
// Step 6: In the build_phase, create each component/sequence
//         and set up your custom-made database in the UVM database.
// Step 7: Connect the agent's export to the scoreboard's port and the coverage's port.
///////////////////////////////////////////////////////////////////////////////////////////////////////////
package FIFO_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_agent_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg::*;

  class FIFO_env extends uvm_env;
      `uvm_component_utils(FIFO_env);

      FIFO_agent agt;
      FIFO_scoreboard sb;
      FIFO_coverage cov;

      function new(string name="FIFO_env",uvm_component parent = null);
        super.new(name,parent);
      endfunction

      // Build the driver in the build phase
      function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt=FIFO_agent::type_id::create("agt",this);
        sb=FIFO_scoreboard::type_id::create("sb",this);
        cov=FIFO_coverage::type_id::create("cov",this);
      endfunction

      function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.agt_ap.connect(sb.sb_export);
        agt.agt_ap.connect(cov.cov_export);
      endfunction

  endclass
endpackage
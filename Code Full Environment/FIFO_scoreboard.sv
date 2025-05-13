///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// UVM Scoreboard: <COMPONENT>
// Step 1: Import uvm_pkg and include `uvm_macros.svh`.
//         Import shared_pkg to include all needed typedefs.
//         Import sequence_item_pkg to create the scoreboard.  
// Step 2: Create a class that extends the original uvm_scoreboard class.
// Step 3: Register the class with the factory using `uvm_component_utils(<class_name>);`.
// Step 4: Create handles for analysis export, analysis FIFO, and sequence item.
// Step 5: Define the constructor with default values: name = "<class_name>" and parent = null.
// Step 6: In the build phase:
//         - Create the analysis export and FIFO.
// Step 7: In the connect phase:
//         - Connect the export of the agent to the FIFO's analysis export.
// Step 8: In the run phase:
//         - Continuously retrieve sequence items from the FIFO.
//         - Compare the DUT output with the reference model output.
//         - Log errors or successes based on the comparison.
// Step 9: Implement a reference model:
//         - Simulate the expected behavior of the DUT based on the sequence item.
// Step 10: In the report phase:
//         - Log the total number of successful and failed comparisons.
//
// Class Importance:
//   - The scoreboard is responsible for verifying the correctness of the DUT's output by comparing it with the reference model.
//   - It ensures that the DUT behaves as expected under all test scenarios.
//   - Errors are logged for debugging, and a summary of results is provided at the end of the simulation.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package FIFO_scoreboard_pkg;
import uvm_pkg::*;
import Shared_pkg::*;
import FIFO_seq_item_pkg::*;
`include "uvm_macros.svh"
    class FIFO_scoreboard extends uvm_scoreboard; 
        `uvm_component_utils(FIFO_scoreboard)
        
        uvm_analysis_export #(FIFO_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;
        FIFO_seq_item seq_item_sb;
        logic [15:0] data_out_ref;
        logic wr_ack_ref;
        logic [7:0] arr [15:0];
        int error_count=0;
        int correct_count=0;

        function new(string name ="FIFO_scoreboard",uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export=new("sb_export",this);
            sb_fifo=new("sb_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
                forever begin
                    sb_fifo.get(seq_item_sb);
                    // Compare with task output or with golden model output
                    if((data_out_ref != seq_item_sb.data_out) || (wr_ack_ref !=seq_item_sb.wr_ack))begin
                        `uvm_error("run_phase",$sformatf("comparison failed,Check output:%s",seq_item_sb.convert2string()));
                        error_count++;
                    end
                    else begin
                        `uvm_info("run_phase",$sformatf("correct FIFO_out:%s",seq_item_sb.convert2string()),UVM_HIGH);
                        correct_count++;
                    end
                end
        endtask

        task ref_model(FIFO_seq_item seq_item_chk);
            static logic [2:0] rd_ptr = 0;
            static logic [2:0] wr_ptr = 0;
            static logic [3:0] count = 0;
            logic read;
            
            if (!seq_item_chk.rst_n) begin
                count = 0;
                rd_ptr = 0;
                wr_ptr = 0;
                wr_ack_ref = 0;
            end
            else begin
                                
                // Handle write operation
                if (seq_item_chk.wr_en && count < 8) begin
                    arr[wr_ptr] = seq_item_chk.data_in;
                    wr_ptr++;
                    wr_ack_ref = 1;
                end
                else begin
                    wr_ack_ref = 0;
                end
                
                // Handle read operation using saved value if appropriate
                if (seq_item_chk.rd_en && count > 0) begin
                    data_out_ref = arr[rd_ptr];
                    rd_ptr++;
                    read = 1;
                end
                else begin
                    read = 0;
                end
                
                // Update count based on operations
                if (wr_ack_ref && !read ) begin
                    count++;
                end
                else if (!wr_ack_ref && read) begin
                    count --;
                end
            end
        endtask
        
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("total transaction counts:%0d",correct_count+error_count),UVM_MEDIUM);
            `uvm_info("report_phase",$sformatf("total successful counts:%0d",correct_count),UVM_MEDIUM);
            `uvm_info("report_phase",$sformatf("total failed counts:%0d",error_count),UVM_MEDIUM);
        endfunction
            
    endclass
endpackage
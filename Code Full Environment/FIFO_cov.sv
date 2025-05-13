///////////////////////////////////////////////////////////////////////////////////////////////////////////
// UVM Coverage: FIFO_coverage
// Step 1: Import uvm_pkg & include `uvm_macros.svh`.
//         Import FIFO_seq_item_pkg to access the sequence item for coverage collection.
// Step 2: Create a class extending the uvm_component class.
// Step 3: Register the class with the factory using `uvm_component_utils(FIFO_coverage)`.
// Step 4: Create handles for TLM FIFO, analysis export, and sequence item.
// Step 5: Define the constructor with default values: name = "FIFO_cov" and parent = null.
// Step 6: In the build phase:
//         - Initialize the TLM FIFO and analysis export.
// Step 7: In the connect phase:
//         - Connect the analysis export to the TLM FIFO.
// Step 8: In the run phase:
//         - Continuously get sequence items from the FIFO.
//         - Sample the coverage group based on the sequence item fields.
//
// Class Importance:
//   - This class is responsible for collecting functional coverage during the simulation.
//   - It ensures that all possible scenarios are exercised and provides metrics for coverage closure.
//   - Coverage bins are defined based on the sequence item fields to track the exercised scenarios.
///////////////////////////////////////////////////////////////////////////////////////////////////////////

package FIFO_coverage_pkg;
import uvm_pkg::*;
import Shared_pkg::*;
import FIFO_seq_item_pkg::*;
`include "uvm_macros.svh"

    class FIFO_coverage extends uvm_component;
        `uvm_component_utils(FIFO_coverage)

        uvm_analysis_export #(FIFO_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
        FIFO_seq_item seq_item_cov;

        // Coverage groups
        covergroup C_GP_1;
            read_en:     coverpoint seq_item_cov.rd_en;
            write_en:    coverpoint seq_item_cov.wr_en;
            write_ack:   coverpoint seq_item_cov.wr_ack;
            overflow:    coverpoint seq_item_cov.overflow;
            underflow:   coverpoint seq_item_cov.underflow;
            full:        coverpoint seq_item_cov.full;
            empty:       coverpoint seq_item_cov.empty;
            almostempty: coverpoint seq_item_cov.almostempty;
            almostfull:  coverpoint seq_item_cov.almostfull;

            cross_write_ack:     cross read_en, write_en, write_ack {
                ignore_bins impossible_write_ack = binsof(write_en) intersect {0} && binsof(write_ack) intersect {1};
                //Impossible to have Write_ack with WR_EN off
            }
            cross_overflow:      cross read_en, write_en, overflow {
                ignore_bins impossible_overflow = binsof(write_en) intersect {0} && binsof(overflow) intersect {1};
                //Impossible to have overflow when Write_en is off
            }
            cross_full:          cross read_en, write_en, full {
                ignore_bins impossible_full = binsof(read_en) intersect {1} && binsof(full) intersect {1};
                //Impossible to see Full and Read_en on same cycle
            }
            cross_underflow:     cross read_en, write_en, underflow;
            cross_empty:         cross read_en, write_en, empty;
            cross_almostempty:   cross read_en, write_en, almostempty;
            cross_almostfull:    cross read_en, write_en, almostfull;

        endgroup
    

        function new(string name = "FIFO_cov", uvm_component parent = null);
            super.new(name, parent);
            C_GP_1=new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export",this);
            cov_fifo = new("cov_fifo",this);
        endfunction
        
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item_cov);
                C_GP_1.sample();
            end
        endtask

    endclass
endpackage
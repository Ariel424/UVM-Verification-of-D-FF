`include "uvm_macros.svh"
import uvm_pkg::*;

class config_dff extend uvm_object; 
`uvm_object_utils(config_dff)

uvm_active_passive_enum agent_type = uvm_active; 

function new (input string path = "config_dff");
super.new (path); 
endfunction

endclass

class transaction extends uvm_sequence_item; 
`uvm_object_utils(transaction)

  rand bit rst; 
  rand bit din; 
  bit dout; 

  function new (input string path = "transaction");
    super.new (path);
  endfunction 

endclass

class vaild_din extends uvm_sequence#(transaction); 
  `uvm_onject_utils (vaild_din)

  transaction tr; 

  function new (input string path = "vaild_din");
    super.new (path);
  endfunction 

  virtual task body(); 
    repeat (15)
      begin 
        tr = treansaction::type_id::create("tr");
        start_item(tr);
        assert (tr.randomize()); 
        tr.rst = 1'b0; 
        `uvm_info("SEQ", $sformatf("rst : %0b  din : %0b  dout : %0b", tr.rst, tr.din, tr.dout), UVM_NONE);
        finish_item (tr); 
      end 
  endtask 
endclass 

class rst_dff extends uvm_sequence#(transaction);
  `uvm_object_utils (rst_dff)

  transaction tr; 

  function new (input string path = "rst_dff");
    super.new (path);
  endfunction 

  virtual task body ();
    repeat (15)
      begin 
        tr = transaction::type_id::create("tr"); 
        start_item (tr);
        assert (tr.randomize()); 
        tr.rst = 1'b1; 
        `uvm_info ("SEQ", $sformatf ("rst : %0b  din : %0b  dout : %0b", tr.rst, tr.din, tr.dout), UVM_NONE);
        finish_item (tr); 
      end 
  endtask
endclass 

class rand_bit_rst extends uvm_sequence#(transaction); 
  `uvm_object_utils (rand_bit_rst)

  transaction tr; 

  function new (input string path = "rand_bit_rst"); 
    super.new (path); 
  endfunction 

  virtual task body (); 
    repeat (15) 
      begin 
        tr = transaction::type_id::create ("tr"); 
        start_item (tr); 
        assert (tr.randomize()); 
        `uvm_info ("SEQ", $sformatf ("rst : %0b  din : %0b  dout : %0b", tr.rst, tr.din, tr.dout), UVM_NONE);
        finish_item(tr);
      end
  endtask 
endclass 

class drv extends uvm_driver #(transaction); 
  `uvm_component_utils (drv)

  transaction tr; 
  virtual dff_if dif; 

  function new (input string path = "drv", uvm_component parent = null); 
    super.new(path, parent)
  endfunction 

  virtual function void build_phase (uvm_phase phase); 
    super.build_phase (phase);
    if (!uvm_config_db#(virtual dff_if)::get(this, " ", "dif", dif)
        `uvm_error ("drv", "Unable to access Interface"); 
        endfunction

        virtual task run_phase (uvm_phases phase); 
          tr = transaction::type_id::create("tr"); 
          forever begin 
            seq_item_port.get_next_item(tr); 
            dif.rst <= tr.rst; 
            dif.din <= tr.din;
            `uvm_info ("SEQ", $sformatf ("rst : %0b  din : %0b  dout : %0b", tr.rst, tr.din, tr.dout), UVM_NONE);
            seq_item_port.item_done(); 
            repeat (2) @(posedge dif.clk); 
          end
        endtask
        endclass 

        class mon extends uvm_monitor; 
          `uvm_component_utils (mon)

          uvm_analysis_port#(transaction) send; 
          transaction tr; 
          virtual dff_if dif; 

          function new (input string inst = "mon", uvm_component parent = null);
            super.new (inst, null);
          endfunction

          virtual function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            tr = transaction::type_id::create("tr");
            send = new("send", this);
            if (!uvm_config_db#(virtual dff_if)::get(this, " ", "dif", dif)
                `uvm_error ("drv", "Unable to access Interface"); 
                endfunction 

                virtual task run_phase (uvm_phase phase); 
                  forever begin 
                    repeat (2) @(posedge dif.clk); 
                    tr.rst = dif.rst;
                    tr.din = dif.din; 
                    tr.dout = dif.dout; 
                    `uvm_info ("MON", $sformatf ("rst : %0b  din : %0b  dout : %0b", tr.rst, tr.din, tr.dout), UVM_NONE);
                    send.write(tr);
                  end 
                endtask 
                endclass 

                class sco extends uvm_scoreboard 
                  `uvm_component_utils (sco)

                  uvm_analysis_imp# (transaction, sco) recv; 

                  function new (input string inst = "sco", uvm_component parent = null); 
                    super.new (inst, parent);
                  endfunction 

                  virtual function void build_phase (uvm_phase phase); 
                    super.new (phase); 
                    recv = new ("recv", this);
                  endfunction 

                  virtual function void write (transaction tr);
                    `uvm_info ("SCO", $sformatf("rst : %0b  din : %0b  dout : %0b", tr.rst, tr.din, tr.dout), UVM_NONE);
                    if (tr.rst == 1'b1)
                      `uvm_info ("SCO", "DFF Reset", UVM_NONE)
                      else if (tr.rst == 1'b0 && (tr.din == tr.dout))
                        `uvm_info ("SCO", "TEST PASSED", UVM_NONE)
                        else 
                          `uvm_info ("SCO", "TEST FAILED", UVM_NONE)

                          $display ("-----------------------------------------");
                  endfunction 
                endclass 
                

                        

                          
                        

                  
              

        
          

                
                


        
                 
          
                 
            
            
          
          
          
      
          
        
        
        

    
          
            
        
        
    
    
    

  
  


  

  
          

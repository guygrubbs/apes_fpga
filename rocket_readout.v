/******************************************************************
*
* Module:       rocket_readout
* Description:  rocket_readout 
*
* Organization: NASA-GSFC
* Author:       Salman Sheikh
* email:        salman.i.sheikh@nasa.gov
*
* Comments:
*   Controls the FE board for the APES instrument. 
*   
*
* FPGA: A3P1000L-FG256I
******************************************************/

`timescale 1 ns / 1 ns 

module rocket_readout (
     clk50, rst_n, collect_done, Counts, Hk_words,
     Cnt_Gtclk, Cnt_Invload, Cnt_Data, 
     Hk_Gtclk, Hk_Invload, Hk_Data,
     cnt_start, cnt_clr);

input         clk50;           
input         rst_n;               
input         collect_done;
input  [9:0]  Counts[51:0];
input  [9:0]  Hk_words[9:0];


// Rocket interface signals
input         Cnt_Gtclk;       
input         Cnt_Invload;     
output        Cnt_Data;    
input         Hk_Gtclk;        
input         Hk_Invload;     
output        Hk_Data;      

output        cnt_start;
output        cnt_clr;


wire  [11:0]  val_adc[0:31];   // output 8 bit registers 
wire  [ 8:0]  lcla;
wire  [31:0]  lcld_i;
reg           sm_regw; 
reg           regw_pls;    
reg hven;

wire   [9:0]  dbus_in_cnt;
wire   [9:0]  dbus_in_hk;

wire   increment_cnt, increment_hk;


/*
sync sync_stim (
  .clk            (clk50),       
  .rst_n          (rst_n),      
  .async_in       (Stim_cmd_n), 
  .sync_out       (stim_cmd_n)       
);

sync sync_reset (
  .clk            (clk50),     
  .rst_n          (rst_n),    
  .async_in       (Reset_cmd_n),
  .sync_out       (reset_cmd_n)       
);

sync sync_hven (
  .clk            (clk50),     
  .rst_n          (rst_n),    
  .async_in       (Hven_cmd_n),
  .sync_out       (hven_cmd_n)       
);
*/

sync sync_gclk1 (
  .clk            (clk50),         
  .rst_n          (rst_n),       
  .async_in       (Cnt_Gtclk),      
  .sync_out       (Cnt_Gtclk_sync)       
);

syncn syncn_loadn1 (
  .clk            (clk50),      
  .rst_n          (rst_n),    
  .async_in       (Cnt_Invload), 
  .sync_out       (Cnt_Invload_sync)       
);

sync sync_gclk2 (
  .clk            (clk50),  
  .rst_n          (rst_n), 
  .async_in       (Hk_Gtclk), 
  .sync_out       (Hk_Gtclk_sync)       
);

syncn syncn_loadn2 (
  .clk            (clk50),  
  .rst_n          (rst_n), 
  .async_in       (Hk_Invload), 
  .sync_out       (Hk_Invload_sync)       
);

hk_readout hk_readout( 
  .clk50          (clk50), 
  .rst_n          (rst_n), 
  .words_in       (Hk_words), 
  .hk_in          (dbus_in_hk), 
  .increment      (increment_hk)
);

parallel_shifter #(     // Increments readout module and transmits out data 
  .n            (9))    // Serial based on Gtclk and Invload
  HK_shifter (
  .clk50         (clk50),  
  .rst_n         (rst_n),
  .enable        (1'b1),  // allowing the rocket to pull off data
  .gclk          (Hk_Gtclk_sync), 
  .loadn         (Hk_Invload_sync), 
  .dbus_in       (dbus_in_hk), 
  .increment     (increment_hk), 
  .serial_out    (Hk_Data)
  );

//HVPS Control Voltage
//0->3.3V produces 0->5.0V at the HVPS input which 0->4kV
//We need to set to 2000V or 1.65V decmal 2047

wire en_rocket_rd;

apes_fsm  fsm(       
  .clk50         (clk50), 
  .rst_n         (rst_n), 
  .collect_done  (collect_done),  
  .en_rocket_rd  (en_rocket_rd),      // enables readout of words_out
  .rdout_done    (rdout_done ),    // indicates rocket tx complete  
  .cnt_start     (cnt_start),       
  .cnt_clr       (cnt_clr)       
);

cnt_readout u_cnt_readout( // put words on Rocket txbus one at a time
  .clk50         (clk50),
  .rst_n         (rst_n), 
  .clr_rdout     (cnt_clr),
  .increment     (increment_cnt),     
  .words_in      (Counts),   
  .cnt_in        (dbus_in_cnt),       
  .rdout_done    (rdout_done)
);


parallel_shifter #(// Increments readout and Tx Cntdata 
  .n            (9)) 
  shifter (
  .clk50         (clk50),
  .rst_n         (rst_n),
  .enable        (en_rocket_rd),  // allows rocket to pull data
  .gclk          (Cnt_Gtclk_sync), 
  .loadn         (Cnt_Invload_sync), 
  .dbus_in       (dbus_in_cnt), 
  .increment     (increment_cnt), 
  .serial_out    (Cnt_Data)
  );


endmodule

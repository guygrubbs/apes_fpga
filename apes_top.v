/******************************************************************************
*
* Module:       apes_top
* Description:   
*
******************************************************************************/

`timescale 1 ns / 100 ps


module apes_top (
Ext_clk_50mhz, Gse_reset, Inpulse,
Safe_cmd, Stim_cmd_n, Reset_cmd_n, Hven_cmd_n, 
Cnt_Data, Cnt_Gtclk, Cnt_Invload, Hk_Data, Hk_Gtclk, Hk_Invload,  

Dac1_sck, Dac1_sdi, Dac1_sync_n, 
Mcp_dac_clk, Mcp_dac_sdi, Mcp_dac_cs, 
Adc_sdo, Adc_cs1, Adc_cs2, Adc_clk, Adc_sdi,
Hven, Sync);

input         Ext_clk_50mhz;           
input         Gse_reset;               // External Reset             
input         Safe_cmd;                // SAFE Command               
input         Stim_cmd_n;              // STIM Command               
input         Reset_cmd_n;             // Reset command              
input         Hven_cmd_n;              // HV En command              

// 50 Input pulses
input  [49:0] Inpulse;

//  Threshold DACs
output        Dac1_sck;
output        Dac1_sdi;
output        Dac1_sync_n;

// MCP DAC interface
output        Mcp_dac_clk;                 // DAC Clock input            
output        Mcp_dac_sdi;                 // DAC Serial Data input      
output        Mcp_dac_cs;                  // DAC Chip Select 

// HK ADC interface
input         Adc_sdo;                 // ADC Serial Data out     
output        Adc_cs1;                 // ADC Chip Select input 1  
output        Adc_cs2;                 // ADC Chip Select input 2   
output        Adc_clk;                 // ADC Clock input        
output        Adc_sdi;                 // ADC Serial Data input      
               

output        Hven;                    // High Voltage Enable        
output        Sync;


//Rocket interface signals
output        Cnt_Data;              // Count Data output        
input         Cnt_Gtclk;             // Count Gated Clock               
input         Cnt_Invload;           // Count Inverted Load             

output        Hk_Data;               // HK Data output   
input         Hk_Gtclk;              // HK Gated Clock               
input         Hk_Invload;            // HK Inverted Load           



reg reg1, rstn, rock_resetn;
wire        clk50;
wire [9:0]  Counts[51:0];
wire [9:0]  Hk_words[9:0];
wire        Safe_cmd_sync;
wire        Stim_cmd_n_sync;

wire gse_resetn, rock_resetn;

assign gse_resetn = !Gse_reset;
assign rock_resetn = Reset_cmd_n;

always @(posedge clk50 or negedge gse_resetn or negedge rock_resetn)
  if(!gse_resetn or !rock_resetn)
  begin
    reg1     <= 0;
    rstn     <= 0;
  end
  else begin 
    reg1     <= 1;
    rstn     <= reg1;    // rst_n is the chip system reset
  end

BUFD   bufr1 (.A(rstn),   .Y(rst_n));

CLKBUF clka (.PAD(Ext_clk_50mhz), .Y(clk50));

sync sync_safe (
  .clk            (clk50),         
  .rst_n          (rst_n),        
  .async_in       (Safe_cmd),     
  .sync_out       (Safe_cmd_sync)       
);

sync sync_stim (
  .clk            (clk50),       
  .rst_n          (rst_n),      
  .async_in       (Stim_cmd_n), 
  .sync_out       (Stim_cmd_n_sync)       
);

sync sync_hven (
  .clk            (clk50),     
  .rst_n          (rst_n),    
  .async_in       (Hven_cmd_n),
  .sync_out       (Hven_cmd_n_sync)       
);


rocket_readout u_rocket_readout(
.clk50          (clk50), 
.rst_n          (rst_n), 
.collect_done   (cnt_done),
.Counts         (Counts), 
.Hk_words       (Hk_words), 
.Cnt_Gtclk      (Cnt_Gtclk), 
.Cnt_Invload    (Cnt_Invload),
.Cnt_Data       (Cnt_Data), 
.Hk_Gtclk       (Hk_Gtclk), 
.Hk_Invload     (Hk_Invload),  
.Hk_Data        (Hk_Data), 
.cnt_start      (cnt_start), 
.cnt_clr        (cnt_clr)
);

pulse_counters u_pulse_counters(
  .clk50          (clk50), 
  .rst_n          (rst_n), 
  .Inpulse        (Inpulse),
  .stim_cmd       (~Stim_cmd_n_sync),
  .cnt_start      (cnt_start),
  .cnt_clr        (cnt_clr),
  .cnt_done       (cnt_done),
  .Counts         (Counts)
);

dac_adc_top u_dac_adc_top(
  .clk50          (clk50), 
  .rst_n          (rst_n), 
  .hven_cmd       (~Hven_cmd_n_sync),
  .safe_cmd       (Safe_cmd_sync),
  .dac_cmd        (5'h0f),
  .Dac1_sck       (Dac1_sck),
  .Dac1_sdi       (Dac1_sdi),
  .Dac1_sync_n    (Dac1_sync_n),
  .Mcp_dac_clk    (Mcp_dac_clk),
  .Mcp_dac_sdi    (Mcp_dac_sdi),
  .Mcp_dac_cs     (Mcp_dac_cs),
  .Adc_sdo        (Adc_sdo),
  .Adc_cs1        (Adc_cs1),
  .Adc_cs2        (Adc_cs2),
  .Adc_clk        (Adc_clk),
  .Adc_sdi        (Adc_sdi),
  .hk_words       (Hk_words),
  .hven           (Hven)
);
  
clk_div u_clk_div_by50
(.clk_50mhz(clk50), 
 .rst_n(rst_n), 
 .clk_100khz(Sync));

endmodule

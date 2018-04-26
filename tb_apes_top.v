
`timescale 1ns / 1ns
module tb_apes_top;

parameter PERIOD = 10;

     // Inputs
    reg Ext_clk_50mhz;
    reg Gse_reset;
    reg [49:0] Inpulse;
    reg Safe_cmd,                // SAFE Command               
        Stim_cmd_n,              // STIM Command               
        Reset_cmd_n,             // Reset command              
        Hven_cmd_n,              // HV En command              
        Adc_sdo,                 // ADC Serial Data out        
        Cnt_Gtclk,                // Gated Clock 1              
        Cnt_Invload,             // Inverted Load 1            
        Hk_Gtclk,                // Gated Clock 2              
        Hk_Invload;              // Gated Clock 2              
    wire Dac1_sdi;
    wire Dac1_sync_n,
    //wire Dac2_sck;
    //wire Dac2_sdi;
    //wire Dac2_sync_n;
    //wire fpga_clk_out,
         // Stim_rcd_n,              // STIM Received              ( B6)
         // Reset_rcd_n,             // Reset Received             ( B7)
         // Hven_rcd_n,              // High Voltage En Received   ( B8)
         // Safe_rcd,                // SAFE Received              ( B9)
          Cnt_Data,                // Serial Data output 1       (A14)
          Hk_Data,                 // Serial Data output 2       (B14)
          Adc_cs1,                 // ADC Chip Select input 1    (R11)
          Adc_cs2,                 // ADC Chip Select input 2    (R10)
          Adc_clk,                 // ADC Clock input            ( T9)
          Adc_sdi,                 // ADC Serial Data input      ( T8)
          Mcp_dac_clk,             // DAC Clock input            ( T5)
          Mcp_dac_sdi,             // DAC Serial Data input      ( R7)
          Mcp_dac_cs,             // DAC Chip Select 1 (U2)     ( T6)
          Hven;                    // High Voltage Enable        ( R9);
     
   apes_top apes_top_uut (
       .Ext_clk_50mhz(Ext_clk_50mhz), 
       .Gse_reset(Gse_reset),
       .Inpulse(Inpulse),
       .Safe_cmd(Safe_cmd), 
       .Stim_cmd_n(Stim_cmd_n),
       .Reset_cmd_n(Reset_cmd_n), 
       .Hven_cmd_n(Hven_cmd_n), 
       .Cnt_Data(Cnt_Data), 
       .Cnt_Gtclk(Cnt_Gtclk), 
       .Cnt_Invload(Cnt_Invload),
       .Hk_Data(Hk_Data), 
       .Hk_Gtclk(Hk_Gtclk), 
       .Hk_Invload(Hk_Invload), 

       .Mcp_dac_clk(Mcp_dac_clk), 
       .Mcp_dac_sdi(Mcp_dac_sdi), 
       .Mcp_dac_cs(Mcp_dac_cs), 
       .Dac1_sck(Dac1_sck),
       .Dac1_sdi(Dac1_sdi),
       .Dac1_sync_n(Dac1_sync_n),
       //.Dac2_sck(Dac2_sck),
       //.Dac2_sdi(Dac2_sdi),
       //.Dac2_sync_n(Dac2_sync_n),
       .Adc_sdo(Adc_sdo), 
       .Adc_cs1(Adc_cs1), 
       .Adc_cs2(Adc_cs2), 
       .Adc_clk(Adc_clk), 
       .Adc_sdi(Adc_sdi),
       //.Stim_rcd_n(Stim_rcd_n), 
       //.Reset_rcd_n(Reset_rcd_n), 
       //.Hven_rcd_n(Hven_rcd_n),
       //.Safe_rcd(Safe_rcd),
       .Hven(Hven), 
       //.fpga_clk_out(fpga_clk_out)); 
       .Sync(Sync)); 
   
    dac121s101  dac121s101_1 (
       .SYNCn(Dac1_sync), 
       .SCLK(Dac1_sck), 
   	.DIN(Dac1_sdi) );
   
    dac121s101  dac121s101_2 (
       .SYNCn(Dac_cs1), 
   	 .SCLK(Dac_clk), 
   	 .DIN(Dac_sdi) );


  adc128s102 adc128s102_0( 
    .SCLK(Adc_clk), 
    .CSn(Adc_cs1), 
    .DIN(Adc_sdi), 
    .DOUT(Adc_sdo_1),
    .data(8'h11) );

  adc128s102 adc128s102_1( 
     .SCLK(Adc_clk), 
     .CSn(Adc_cs2), 
     .DIN(Adc_sdi), 
     .DOUT(Adc_sdo_2),
     .data(8'h55) );

initial
Ext_clk_50mhz = 0;
always
#10 Ext_clk_50mhz = ~Ext_clk_50mhz;


reg  [7:0]  div_count;
reg         div_clk;

always @(posedge Ext_clk_50mhz or posedge Gse_reset) 
  if (Gse_reset) 
  begin
    div_count <= 8'b0;
    div_clk <= 1'b0;
  end 
  else 
  begin
    div_count <= div_count + 1;
    div_clk <= div_count[7]; //Flip div_clk every 2^8 cycles
  end 


initial 
begin
  Cnt_Gtclk = 0;
  Cnt_Invload = 1;
  //#1600000;
  //  wait (apes_top_uut.u_rocket_readout.en_rocket_rd);

  repeat (52) 
  begin

     Cnt_Gtclk = 0;
     Cnt_Invload = 0;
     #100; 
     Cnt_Invload = 1;

    repeat (10)
    begin
     Cnt_Gtclk = 1; #100;
     Cnt_Gtclk = 0; #100;
    end
  end 

  //wait (apes_top_uut.u_rocket_readout.collect_done == 1);
  //wait (apes_top_uut.u_rocket_readout.rdout_done);
  wait (apes_top_uut.u_rocket_readout.en_rocket_rd);
  //#2000000;

  repeat (52) 
  begin

     Cnt_Gtclk = 0;
     Cnt_Invload = 0;
     #100; 
     Cnt_Invload = 1;

    repeat (10)
    begin
     Cnt_Gtclk = 1; #100;
     Cnt_Gtclk = 0; #100;
    end
  end 

  wait (apes_top_uut.u_rocket_readout.en_rocket_rd);

  repeat (52) 
  begin

     Cnt_Gtclk = 0;
     Cnt_Invload = 0;
     #100; 
     Cnt_Invload = 1;

    repeat (10)
    begin
     Cnt_Gtclk = 1; #100;
     Cnt_Gtclk = 0; #100;
    end
  end 

end


initial 
begin

   Safe_cmd = 0;
   Stim_cmd_n = 1;  
   Reset_cmd_n = 1;
   Hven_cmd_n = 0;

   Hk_Gtclk = 0;
   Hk_Invload = 0;


   Gse_reset = 0;
   #50; 
   Gse_reset = 1;
   #100;
   Gse_reset = 0;

   #2000 Stim_cmd_n = 0;  
   //Reset_cmd_n = 1;
   #100;
   Hven_cmd_n = 1;

  wait (apes_top_uut.u_rocket_readout.rdout_done);
  repeat (9) @ (posedge Cnt_Gtclk);
 
   Hven_cmd_n = 0;
   #1000;
   //Reset_cmd_n = 0;
   #100;
   Hven_cmd_n = 1;

  wait (apes_top_uut.u_rocket_readout.rdout_done);
  repeat (9) @ (posedge Cnt_Gtclk);
 
   Hven_cmd_n = 0;
   #1000;
   Reset_cmd_n = 0;
   #100;
   Hven_cmd_n = 1;


end



always @(posedge Gse_reset or posedge Ext_clk_50mhz) //div_clk)
begin
   if (Gse_reset)
   //Inpulse <= 50'h30f0f_ff0f_ffff;
   Inpulse <= 50'h0;
   else
   Inpulse <= {Inpulse[48:0], Inpulse[49] ^ Inpulse[48] ^ Inpulse[23] ^ Inpulse[22]};
end


endmodule

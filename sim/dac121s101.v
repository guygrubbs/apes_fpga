//-------1---------2---------3---------4---------5---------6---------7---------8
// DAC121S101 - 12 bit Digital to Analog Converter behavioral
// Revision:
//
// Created 05/01/09 : Mark A. Johnson  210-522-2419  majohnson@swri.org
//
// Comments:
//

`timescale 1 ns / 100 ps

module dac121s101 #(
  parameter DAC_MON=1'b1) (            // Monitor DAC
  SYNCn, SCLK, DIN );

input         SYNCn,                   // Sync not
              SCLK,                    // Serial Clock
              DIN;                     // Data In

reg    [15:0] din      = 16'h0000;     // Data In
reg           init     = 1'b0;
integer       sm_dac   = 0;            // DAC State Machine
reg    [31:0] err_flag = 32'h00000000; // Error Flag
time          missedby = 0;            // Missed By in nSec

              // Time Parameters - NSC DAC121S101QML spec - ©2008
parameter     tCLK     =  50,          // min Clock Period
              tH       =  20,          // min Clock Hi
              tL       =  20,          // min Clock Lo
              tSUD     =   6,          // min Data Setup
              tDHD     =   5,          // min Data Hold
              tSYNC    =  37;          // min SYNC Hi

              // Time Stamps
real          tCLK_hi=0, tCLK_lo=0, tDIN=0, tSYNC_hi=0;

// processes -------------------------------------------------------------------

always @(posedge SCLK) #21             // -21 ns setup time (can ya believe it?)
 if (!SYNCn && !init) begin            // Sync on / not initialized
   init     = 1'b1;                       // set init
   din      = 16'h0000;                // reset data
end

always @(negedge SCLK) case (sm_dac)   // DAC State Machine

  default: if (init) begin             // states 0-15
    if (!SYNCn) begin                  // sync on
      din = {din[14:0], DIN};          // shift in data
      sm_dac = sm_dac + 1;             // inc state machine
    end else begin                     // sync off early
      $display ("@%0d ns: ERROR: %m SYNC# signal deactivated early", $time);
      err_flag = "DAC!";               // set error flag
    end
  end

  16: begin                            // state 16
    if (DAC_MON) begin                 // monitor dac ops
      //$write ("@%0d ns: DAC %m Data = %h", $time, din[11:0]);
      case (din[13:12])
        2'b00: $display(""); //$display (" - Normal");
        2'b01: $display (" - Power down w/5K to ground");
        2'b10: $display (" - Power down w/100K to ground");
        2'b11: $display (" - Power down w/output at Hi-Z");
      endcase
    end
    if (!SYNCn) begin                  // sync still on
      $display ("@%0d ns: ERROR: %m SYNC# signal still active", $time);
      err_flag = "DAC!";               // set error flag
    end
    sm_dac = 0;                        // reset state machine
    init = 1'b0;                          // reset init
  end
endcase


// check timings ---------------------------------------------------------------

always @(SCLK) if ($time>999)                    // check clock timings
  if (SCLK) begin                                // clock hi
    if (($time-tCLK_hi)<tCLK) begin
      missedby = tCLK-($time-tCLK_hi);
      $display ("@%0d %m ERROR: Clock Frequency too high: Period missed by %0d",
                $time, missedby);
      err_flag = "DAC!";                         // set error flag
    end
    if (($time-tCLK_lo)<tL) begin
      missedby = tL-($time-tCLK_lo);
      $display ("@%0d %m ERROR: Clock no Low long enough: missed by %0d",
                $time, missedby);
      err_flag = "DAC!";                         // set error flag
    end
    tCLK_hi = $time;
  end else begin                                 // clock lo
    if (($time-tCLK_lo)<tCLK) begin
      missedby = tCLK-($time-tCLK_lo);
      $display ("@%0d %m ERROR: Clock Frequency too high: Period missed by %0d",
                $time, missedby);
      err_flag = "DAC!";                         // set error flag
    end
    if (($time-tCLK_hi)<tH) begin
      missedby = tH-($time-tCLK_hi);
      $display ("@%0d %m ERROR: Clock no Low long enough: missed by %0d",
                $time, missedby);
      err_flag = "DAC!";                         // set error flag
    end
    tCLK_lo = $time;
  end

always @(DIN) if ($time>999)                     // check data timings
  tDIN = $time;

always @(tCLK_lo) if (!SYNCn)
  if ((tCLK_lo-tDIN)<tSUD) begin
    missedby = tSUD-(tCLK_lo-tDIN);
    $display ("@%0d %m ERROR: DAC Data Setup timing not met: missed by %0d",
              $time, missedby);
    err_flag = "DAC!";                           // set error flag
  end

always @(tDIN) if (!SYNCn)
  if ((tDIN-tCLK_lo)<tDHD) begin
    missedby = tDHD-(tDIN-tCLK_lo);
    $display ("@%0d %m ERROR: DAC Data Hold timing not met: missed by %0d",
              $time, missedby);
    err_flag = "DAC!";                           // set error flag
  end

always @(SYNCn)
  if (SYNCn)
    tSYNC_hi = $time;
  else if (($time-tSYNC_hi)<tSYNC) begin
    missedby = tSYNC-($time-tSYNC_hi);
    $display ("@%0d %m ERROR: DAC SYNC# high timing not met: missed by %0d",
              $time, missedby);
    err_flag = "DAC!";                           // set error flag
  end
endmodule       

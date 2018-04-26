//-------1---------2---------3---------4---------5---------6---------7---------8
// adc128s102 - 12 bit Analog to Digital Converter behavioral
// Revision:
//
// Created 6/18/12 : John R Dickinson  210-522-5826  john.dickinson@swri.edu
//
// Comments:
//

`timescale 1 ns / 100 ps

module adc128s102 ( SCLK, CSn, DIN, DOUT, data );

parameter     WAIT_CNT = 11;                     // Wait Count
parameter     O=1'b0, l=1'b1, X=1'bx, Z=1'bz;    // onetickbeemyass

input         SCLK,                    // SCLK
              CSn,                     // Chip Select not
              DIN;                     // Data in
output        DOUT;                    // Data out
input  [ 7:0] data;                    // Data to shift out

reg    [ 3:0] old_addr,                // ADC Mux input addr
              addr,                    // ADC Mux input addr
              din;                     // data in
reg    [31:0] err_flag = 32'h00000000, // Error Flag
              old_data=0;              // Data from previous cycle
reg    [11:0] adc_oshft=0;             // ADC data output shift register

integer       sm_adc=0,                // ADC State Machine
              cnt_shft=0;              // Shift Counter

real          tRDn_off = 0;            // Time Stamps

time          missedby = 0;            // Missed By in nSec

              // Time Parameters (ns) - NSC DAC128S102QML spec - ©Jan 13, 2011
parameter     tmCLK    =  62.5,        // min Clock Period
              tMCLK    =  22500,        // max Clock Period
              tmCH     =    25,        // min Clock Hi
              tmCL     =    25,        // min Clock Lo
              tMCH     =   50000,        // max Clock Hi
              tMCL     =   50000,        // max Clock Lo
              tCSH     =    10,        // min CLK to CSn hold
              tCSS     =    10,        // min CSn CLK setup
//            tEN      =    30,        // max CSn to DOUT - OPERATIONAL DESC
//            tDACC    =    27,        // max CLK to DOUT - OPERATIONAL DESC
//            tDHLD    =    11,        // min DOUT to CLK hold - OPERATION DESC
              tDS      =    10,        // min DIN Setup
              tDH      =    10;        // min DIN Hold
//            tDIS     =    20;        // max CSn to DOUT z - OPERATIONAL DESC

              // Time Stamps
real          tCLK_hi=0, tCLK_lo=0, tDIN=0, tCS_hi=0, tCS_lo=0,
              blo=0, bhi=0;


// processes -------------------------------------------------------------------
always @(posedge SCLK) begin
  addr <= {addr[2:0], DIN};                      // data valid on rising edge

end

always @(negedge SCLK) /*if ($time>999)*/ begin  // data cgange on falling edge

  case (sm_adc)                                  // adc state machine

    0: begin                                     // WAIT
      addr <= 4'h0;                              // reset address value
      adc_oshft <= 12'h0;                        // reset out shift reg
      
      if (!CSn) begin                            // enabled; bit 15 (DC)
        cnt_shft = cnt_shft + 1'b1;                 // inc shift counter
        
        sm_adc <= 1;                             // goto CONVERT
      end else
        cnt_shft = 0;
    end

    1: begin                                     // CONVERT
      if (!CSn) begin                            // enabled; bit 14:11 (addr)
        cnt_shft = cnt_shft + 1'b1;                 // inc shift counter
        
        if (cnt_shft==5) begin
          sm_adc = 2;                            // goto SHIFT
          adc_oshft <= {1'b1,11'h0};                // begin data w/1
        end else
          adc_oshft <= 12'h0;                    // when shifting data in, out=0

      end else begin
        sm_adc = 0;                              // reset; goto WAIT
        if (cnt_shft>1) begin
          $display ("@%0d ns: ERROR: %m CS# signal deactivated early", $time);
          err_flag = "ADC!";                     // set error flag
        end
      end
    end

    2: begin                                     // SHIFT bits 12:0
      if (!CSn) begin                            // enabled; bit 12:0 (data)
        cnt_shft = cnt_shft + 1'b1;                 // inc shift counter
        
        if (cnt_shft==6) begin
          adc_oshft <= {old_addr[2:0],           // shift out data
                        old_data, 1'b0};
          old_data <= #5 data;                   // latch data for next cycle
          old_addr <= #5 addr;                   // latch address for next cycle
        end else
          adc_oshft <= {adc_oshft[10:0], 1'b0};     // shift data: msb 1st

        if (cnt_shft==15)                        // shift counter expired
          sm_adc = 3;                            // goto EXIT
      
      end else begin
        sm_adc = 0;                              // reset; goto WAIT
        $display ("@%0d ns: ERROR: %m CS# signal deactivated early", $time);
        err_flag = "ADC!";                       // set error flag
      end
    end

    3: begin                                     // EXIT
      cnt_shft = 0;                              // inc shift counter
      adc_oshft <= {adc_oshft[10:0], 1'b0};         // shift data: msb 1st
      if (!CSn) begin                            // enabled; bit 15/z (DC)
        sm_adc    = 1;                           // goto CONVERT
      end else begin
        sm_adc    = 0;                           // reset; goto WAIT
        $display ("@%0d ns: ERROR: %m CS# signal deactivated early", $time);
        err_flag = "ADC!";                       // set error flag
      end
    end
  endcase
end

assign
  DOUT = CSn ? 1'bz : adc_oshft[11];             // data out; z if no select


// check timings ---------------------------------------------------------------
always @(SCLK) if ($time>999)                    // check clock timings
  if (SCLK) begin                                // clock hi
    if (!CSn) begin                              // CSn low
      if (($time-tCLK_hi)<tmCLK) begin           // period too lo; freq too hi
        missedby = tmCLK-($time-tCLK_hi);
        $display ("@%0d %m ERROR: Clock Frequency too high: Period missed by %0d",
                  $time, missedby);
        err_flag = "ADC!";                       // set error flag
      end
      if (($time-tCLK_hi)>tMCLK) begin           // period too hi; freq too lo
        missedby = tMCLK-($time-tCLK_hi);
        $display ("@%0d %m ERROR: Clock Frequency too low: Period missed by %0d",
                  $time, missedby);
        err_flag = "ADC!";                       // set error flag
      end
      if (blo && (($time-tCLK_lo)<tmCL)) begin   // low time too lo
        missedby = tmCL-($time-tCLK_lo);
        $display ("@%0d %m ERROR: Clock not Low long enough: missed by %0d",
                  $time, missedby);
        err_flag = "ADC!";                       // set error flag
      end
      if (blo && (($time-tCLK_lo)>tMCL)) begin   // low time too lo
        missedby = tMCL-($time-tCLK_lo);
        $display ("@%0d %m ERROR: Clock Low too long: missed by %0d",
                  $time, missedby);
        err_flag = "ADC!";                       // set error flag
      end
    end
    tCLK_hi = $time;
    bhi = 1;
  end else begin                                 // clock lo
    if (!CSn) begin                              // CSn low
      if (($time-tCLK_lo)<tmCLK) begin           // period too lo; freq too hi
        missedby = tmCLK-($time-tCLK_lo);
        $display ("@%0d %m ERROR: Clock Frequency too high: Period missed by %0d",
                  $time, missedby);
        err_flag = "ADC!";                       // set error flag
      end
      if (($time-tCLK_lo)>tMCLK) begin           // period too hi; freq too lo
        missedby = tMCLK-($time-tCLK_lo);
        $display ("@%0d %m ERROR: Clock Frequency too low: Period missed by %0d",
                  $time, missedby);
        err_flag = "ADC!";                       // set error flag
      end
      if (bhi && (($time-tCLK_hi)<tmCH)) begin   // high time too lo
        missedby = tmCH-($time-tCLK_hi);
        $display ("@%0d %m ERROR: Clock not High long enough: missed by %0d",
                  $time, missedby);
        err_flag = "ADC!";                       // set error flag
      end
      if (bhi && (($time-tCLK_hi)>tMCH)) begin   // high time too lo
        missedby = tMCH-($time-tCLK_hi);
        $display ("@%0d %m ERROR: Clock High too long: missed by %0d",
                  $time, missedby);
        err_flag = "ADC!";                       // set error flag
      end
    end
    tCLK_lo = $time;
    blo = 1;
  end

always @(DIN) if ($time>999)                     // check data timings
  tDIN = $time;

always @(tCLK_hi)   // Verify tCSS
  if ((tCLK_hi-tCS_lo)<tCSS) begin
    missedby = tCSS-(tCLK_hi-tCS_lo);
    $display ("@%0d %m ERROR: ADC CLK to Chip Select Setup timing not met: missed by %0d",
              $time, missedby);
    err_flag = "ADC!";                           // set error flag
  end

always @(tCS_lo)    // Verify tCSH
  if ((tCS_lo-tCLK_hi)<tCSH) begin
    missedby = tCSH-(tCS_lo-tCLK_hi);
    $display ("@%0d %m ERROR: ADC CLK to Chip Select Hold timing not met: missed by %0d",
              $time, missedby);
    err_flag = "ADC!";                           // set error flag
  end

always @(tCLK_hi) if (!CSn)   // Verify tDS; data valid on rising edge
  if ((tCLK_hi-tDIN)<tDS) begin
    missedby = tDS-(tCLK_hi-tDIN);
    $display ("@%0d %m ERROR: ADC Data Setup timing not met: missed by %0d",
              $time, missedby);
    err_flag = "ADC!";                           // set error flag
  end

always @(tDIN) if (!CSn)      // Verify tDH; data valid on rising edge
  if ((tDIN-tCLK_hi)<tDH) begin
    missedby = tDH-(tDIN-tCLK_hi);
    $display ("@%0d %m ERROR: ADC Data Hold timing not met: missed by %0d",
              $time, missedby);
    err_flag = "ADC!";                           // set error flag
  end

endmodule

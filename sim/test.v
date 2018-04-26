/******************************************************************************
*
******************************************************************************/

`timescale 1 ns / 1 ns 

module test;

reg          clk50 = 0;           // External 50MHz Clock       ( A2)
reg             resetn_in,                // POR_n input               ( H2)
             GSE_RESET;               // External Reset             ( B1)  
reg   [ 7:0] clock_div;
reg    [28:0] count_rst;

reg R1, rstn;

CLKINT    bufr1 (.A(rstn_all),   .Y(rst_n));   // 50 MHz Hard Reset not  updated to CLKINT after base15

always
#10 clk50 = ~clk50;

assign gse_resetn = !GSE_RESET;

always @(posedge clk50 or negedge gse_resetn)
  if(!gse_resetn) begin
    R1        <= 0;
    rstn     <= 0;
  end
  else begin
    R1        <= 1;
    rstn     <= R1;                  // rst_n is the chip system reset
  end 

/////////////POR Reset ///////////////////////////
always @(posedge clk50 or negedge resetn_in)
begin
  if(!resetn_in)
    count_rst <= 29'b10100000000000000000000000000;
  else begin
    if (count_rst[28:26] == 3'b101) count_rst <= count_rst + 1;
  end
end 

assign resetn_out = !count_rst[26];
assign rstn_all =   rstn & resetn_out;

initial 
begin
GSE_RESET = 1'b1;
resetn_in = 1'b1;
#1000;
resetn_in = 1'b0;
#2000;
resetn_in = 1'b1;
end


endmodule

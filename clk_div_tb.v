`timescale 1 ns/100 ps
module clk_div_tb;

  reg clk,rst_n;
  wire clk_out;
 
     clk_div t1(clk,rst_n,clk_out);

   initial
     clk= 1'b0;
   always
     #10  clk=~clk; 

   initial
    begin
       rst_n=1'b0;
       #500 rst_n=1'b1;
    end
 
endmodule
 

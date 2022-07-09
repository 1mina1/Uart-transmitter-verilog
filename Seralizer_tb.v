// FILE NAME: Seralizer_tb.v
// TYPE: module
// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 8/7/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: seralizer, parallel to serial ,testbench
//------------------------------------------------
// PURPOSE: testbench for the seralizer\
`timescale 1us/1ns
module Seralizer_tb();
  ///////////////////testbench signals////////////////
  reg    [7:0]   Seralizer_ParallelData_tb;
  reg            Seralizer_CLK_tb;
  reg            Seralizer_RST_SYN_tb;
  reg            Seralizer_RST_ASYN_tb;
  reg            Seralizer_En_tb;
  reg    [7:0]   Data_collected;
  wire           Seralizer_done_tb;
  wire           Seralizer_SerialData_tb;
  integer            i;
  
  ////////////////////initial block///////////////////////
 initial 
   begin
  // Save Waveform
   $dumpfile("Seralizer.vcd") ;       
   $dumpvars;
  // initialization
   initialize();
   Data_Check();
   #1000
   $finish;
 end
  ////////////////////signal initialization////////////////
 task initialize;
   begin
     Seralizer_CLK_tb = 1'b0;
     Seralizer_RST_SYN_tb = 1'b1;
     Seralizer_RST_ASYN_tb = 1'b1;
     Seralizer_ParallelData_tb = 8'b11010110;
     #30
     Seralizer_RST_SYN_tb = 1'b0;
     #40
     Seralizer_RST_SYN_tb = 1'b1;
     Seralizer_En_tb =1'b1;
   end
 endtask
 ////////////////////check data seralization///////////////
 task Data_Check;
   begin
     Data_collected[0] = Seralizer_SerialData_tb;
     for(i=1;i<8;i=i+1)
     begin
       #104.2
       Data_collected[i] = Seralizer_SerialData_tb;
     end
     if(Data_collected == Seralizer_ParallelData_tb &&(Seralizer_done_tb))
       $display("data seralized successfully");
     else
       $display("data seralization failed");
   end
 endtask
 ////////////////////clock generation////////////////////
  always #52.1 Seralizer_CLK_tb = !Seralizer_CLK_tb;//for 9.6Khz clock  
 /////////////////// DUT Instantation ///////////////////
 Seralizer #(.WIDTH(3)) DUT (
 .Seralizer_ParallelData(Seralizer_ParallelData_tb),
 .Seralizer_CLK(Seralizer_CLK_tb),
 .Seralizer_RST_SYN(Seralizer_RST_SYN_tb),
 .Seralizer_RST_ASYN(Seralizer_RST_ASYN_tb),
 .Seralizer_En(Seralizer_En_tb),
 .Seralizer_done(Seralizer_done_tb),
 .Seralizer_SerialData(Seralizer_SerialData_tb));
endmodule

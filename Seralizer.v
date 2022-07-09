// FILE NAME: Seralizer.v
// TYPE: module
// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 7/7/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: seralizer, parallel to serial 
//------------------------------------------------
// PURPOSE:   this module is used to transform parallel data to serial with help of counter\

/////////input and outputs ports declaration////////////
module Seralizer #(parameter WIDTH = 3)(
  input    wire    [2**(WIDTH)-1:0]    Seralizer_ParallelData,
  input    wire                        Seralizer_CLK,
  input    wire                        Seralizer_RST_SYN,
  input    wire                        Seralizer_RST_ASYN,
  input    wire                        Seralizer_En,
  output   wire                        Seralizer_done,
  output   wire                        Seralizer_SerialData);
  //////////////////module instantiations//////////////////
  
  wire    [WIDTH-1:0]    CountToPISO;
  
  counter #(.CounterWIDTH(WIDTH)) C0 (
  .counter_RST_SYN(Seralizer_RST_SYN),
  .counter_RST_ASYN(Seralizer_RST_ASYN),
  .counter_CLK(Seralizer_CLK),
  .counter_En(Seralizer_En),
  .counter_finish(Seralizer_done),
  .count(CountToPISO));
  
  Parallel_To_Serial #(.PISO_WIDTH(WIDTH)) P0 (
  .PISO_ParallelData(Seralizer_ParallelData),
  .PISO_Count(CountToPISO),
  .PISO_SerialData(Seralizer_SerialData));
  
endmodule

// FILE NAME: Parallel_To_Serial.v
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
module Parallel_To_Serial #(parameter PISO_WIDTH=3) (
  input    wire    [2**(PISO_WIDTH)-1:0]      PISO_ParallelData,
  input    wire    [PISO_WIDTH-1:0]           PISO_Count,
  output   reg                                PISO_SerialData);
  
  reg    [2**(PISO_WIDTH)-1:0]    data; 
  ////////////combinational logic//////////////
  always@(*)
  begin
    data = (PISO_ParallelData>>PISO_Count);
    PISO_SerialData = data[0];
  end
endmodule
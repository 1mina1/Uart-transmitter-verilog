// FILE NAME: Parity_Calc.v
// TYPE: module
// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 7/7/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: parity calculation, even parity, odd parity
//------------------------------------------------
// PURPOSE:   this module is used to calculate the parity for uart\

/////////input and outputs ports declaration////////////
module Parity_Calc #(parameter DataWIDTH=3) (
  input    wire    [2**(DataWIDTH)-1:0]    ParityCalc_PDATA,
  input    wire                            ParityCalc_DataValid,
  input    wire                            ParityCalc_ParType, 
  output   reg                             ParityCalc_ParBit);
  
  reg    Parity;
  
  //////////////////combinational logic for parity calculation using xor/////////
  always@(*)
  begin
    Parity =(^ParityCalc_PDATA);
    if(ParityCalc_ParType == 1'b0)
      ParityCalc_ParBit = Parity;
    else
      ParityCalc_ParBit = (~Parity);
  end
endmodule   
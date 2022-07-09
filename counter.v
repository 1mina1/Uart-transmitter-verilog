// FILE NAME: counter.v
// TYPE: module
// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 7/7/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: counter, parameterized counter
//------------------------------------------------
// PURPOSE:   counter to use in the seralizer\

/////////input and outputs ports declaration////////////
module counter #(parameter CounterWIDTH = 3) (
  input    wire                         counter_RST_SYN,
  input    wire                         counter_RST_ASYN,
  input    wire                         counter_CLK,
  input    wire                         counter_En,
  output   wire                         counter_finish,
  output   reg    [CounterWIDTH-1:0]    count );
  
  reg    [CounterWIDTH-1:0]    count_comb;
  
  ///////////sequentional block//////////
  always@(posedge counter_CLK or negedge counter_RST_ASYN)
  begin
    if(!counter_RST_ASYN)
      count <= 'b0;
    else if(!counter_RST_SYN)
      count <= 'b0;
    else
      count <= count_comb;
  end
  
  ///////////combinational logic///////////
  always@(*)
  begin
    if(counter_En)
     if(!counter_finish)
       count_comb = count +3'b1;
     else
       count_comb = count;
    else
      count_comb = 'b0;
  end
  
  assign counter_finish = (&count);
endmodule

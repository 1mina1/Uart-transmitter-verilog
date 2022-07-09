// FILE NAME: FSM.v
// TYPE: module
// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 7/7/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: UART controller, finite state machine, moore state machine testbench
//------------------------------------------------
// PURPOSE:  test bench for the finite state machine /
`timescale 1us/1ns
module FSM_tb ();
  ///////////////////testbench signals////////////////
  reg              FSM_RST_SYN_tb;
  reg              FSM_RST_ASYN_tb;
  reg              FSM_CLK_tb;
  reg              FSM_DataValid_tb;
  reg              FSM_SerDone_tb;
  reg              FSM_ParEn_tb;
  wire             FSM_SerEn_tb;
  wire    [1:0]    FSM_MuxSel_tb;
  wire             FSM_Busy_tb;
  ////////////////////initial block///////////////////////
  initial 
   begin
  // Save Waveform
   $dumpfile("FSM.vcd") ;       
   $dumpvars;
  // initialization
   initialize();
  //1-check if FSM in IDLE state
  Check_Output(1'b0,1'b0,1'b0,1'b0,2'b00,1'b0,1);
  //2-adding data valid =1 then check if the fsm will be in start case
  Check_Output(1'b1,1'b0,1'b0,1'b0,2'b01,1'b1,2);
  //4-checking if the state will go to send the data even if the old data after lowering the data valid signal
  Check_Output(1'b0,1'b0,1'b0,1'b1,2'b11,1'b1,3);
  //5-enabling parity and finishing seralizing the data to make sure that the fsm is in parity state
  Check_Output(1'b0,1'b1,1'b1,1'b0,2'b10,1'b1,4);
  //6-keeping the previous signals to make sure that the fsm goes to stop state
  Check_Output(1'b0,1'b1,1'b1,1'b0,2'b00,1'b1,5);
  //7-enabling the data valid before the stop bit ends to check if the fsm will go to  start state immediatly
  Check_Output(1'b1,1'b0,1'b0,1'b0,2'b01,1'b1,6);
  //7-checking if the state will keep sending the data even if the data valid signal is still high
  Check_Output(1'b1,1'b0,1'b0,1'b1,2'b11,1'b1,7);
  //8-checking if the fsm will go into the stop state even if data valid is high and without parity enable
  Check_Output(1'b1,1'b1,1'b0,1'b0,2'b00,1'b1,8);
  //9-cheking if fsm will return to the IDLE state
  Check_Output(1'b0,1'b0,1'b0,1'b0,2'b00,1'b0,9);
  //checking that only the data valid state can move the fsm from IDLE state
  Check_Output(1'b0,1'b1,1'b1,1'b0,2'b00,1'b0,10);
  #1000
  $finish;
 end
 ////////////////////signal initialization////////////////
 task initialize;
   begin
     FSM_CLK_tb = 1'b0;
     FSM_RST_SYN_tb = 1'b1;
     FSM_RST_ASYN_tb = 1'b1;
     #30
     FSM_RST_SYN_tb = 1'b0;
     #40
     FSM_RST_SYN_tb = 1'b1;
   end
 endtask
 ////////////////////check task//////////////////////////
 task Check_Output(
   input    reg             DataValid,
   input    reg             SerDone,
   input    reg             ParEn,
   input    reg             SerEn,
   input    reg    [1:0]    MuxSel,
   input    reg             Busy,
   input    integer         Test_Num
   );
   begin
    FSM_DataValid_tb = DataValid;
    FSM_ParEn_tb = ParEn;
    FSM_SerDone_tb = SerDone;
    #104.2
    if((FSM_SerEn_tb == SerEn)&&(FSM_MuxSel_tb == MuxSel)&&(FSM_Busy_tb == Busy))
      $display("test case %0d passed",Test_Num);
    else
      $display("test case %0d failed",Test_Num);
    end
 endtask    
  ////////////////////clock generation////////////////////
  always #52.1 FSM_CLK_tb = !FSM_CLK_tb;//for 9.6Khz clock
  /////////////////// DUT Instantation ///////////////////
  FSM DUT(
  .FSM_RST_SYN(FSM_RST_SYN_tb),
  .FSM_RST_ASYN(FSM_RST_ASYN_tb),
  .FSM_CLK(FSM_CLK_tb),
  .FSM_DataValid(FSM_DataValid_tb),
  .FSM_SerDone(FSM_SerDone_tb),
  .FSM_ParEn(FSM_ParEn_tb),
  .FSM_SerEn(FSM_SerEn_tb),
  .FSM_MuxSel(FSM_MuxSel_tb),
  .FSM_Busy(FSM_Busy_tb)
  );
endmodule
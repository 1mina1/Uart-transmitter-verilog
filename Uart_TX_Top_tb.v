// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 8/7/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: uart transmitter ,communication protocol vlsi,testbench
//------------------------------------------------
// PURPOSE: this is the testbench for the top module for the uart transmitter\
`timescale 1us/1ns
module Uart_TX_Top_tb ();
  ///////////////////testbench signals////////////////
  reg    [7:0]    P_DATA_tb;
  reg             CLK_tb;
  reg             RST_SYN_tb;
  reg             RST_ASYN_tb;
  reg             Data_Valid_tb;
  reg             PAR_EN_tb;
  reg             PAR_TYP_tb;
  reg    [7:0]    DataCompare;
  wire            TX_OUT_tb;
  wire            busy_tb;
  integer         pass;
  integer         pass2;
  integer         i;
  
  ////////////////////initial block///////////////////////
  initial 
   begin
  // Save Waveform
   $dumpfile("Uart_TX_Top.vcd") ;       
   $dumpvars;
  // initialization
   initialize();
   //transmit data with no options
   DataTX_NoOptions();
   //transmit two data frames one with even parity and one with odd parity without going to idle state
   DataTX_Parity(8'b11011001,1'b1,1'b0,pass);//even Parity
   DataTX_Parity(8'b11011001,1'b1,1'b1,pass2);//oddparity
   Frames_close_Check(pass,pass2);
   //changing the data during transmission and making sure that uart doesn't transmitter doesn't accept any data
   NoDisturbance_Check();
   #1000
   $finish;
 end
  
  ////////////////////signal initialization////////////////
 task initialize;
   begin
     CLK_tb = 1'b0;
     RST_SYN_tb = 1'b1;
     RST_ASYN_tb = 1'b1;
     PAR_EN_tb = 1'b0;
     Data_Valid_tb = 1'b0;
     #30
     RST_SYN_tb = 1'b0;
     #40
     RST_SYN_tb = 1'b1;
   end
 endtask
  ///////////////////check normal data transmission without parity//////////////
  task DataTX_NoOptions;
    begin
      P_DATA_tb = 8'b11011001;
      PAR_EN_tb = 1'b0;
      Data_Valid_tb = 1'b1;
      pass = 1;
      #104.2
      Data_Valid_tb = 1'b0;
      if(!((TX_OUT_tb == 1'b0)&&(busy_tb == 1'b1)))
        begin
         pass = 0;
        end
      #104.2
      DataCompare[0] = TX_OUT_tb;
      for(i=1;i<8;i=i+1)
      begin
        if(!busy_tb)
        begin
         pass = 0;
        end
        #104.2
       DataCompare[i] = TX_OUT_tb; 
      end
      if(!((DataCompare == 8'b11011001)&& busy_tb))
        begin
         pass = 0;
        end
      #104.2
      if(!((TX_OUT_tb == 1'b1)&&(busy_tb == 1'b1)))
        begin
         pass = 0;
        end
      #104.2 
      if(!((TX_OUT_tb == 1'b1)&&(busy_tb == 1'b0)))
        begin
         pass = 0;
        end
      if(pass)
        $display("data with no options send successfully");
      else
        $display("data with no options send unsuccessfully");
    end
  endtask
  ////////////////////////check for transmitting two close frames with different parities/////////////
  task DataTX_Parity(
  input    reg    [7:0]    IN_P_DATA,
  input    reg             IN_PAR_EN,
  input    reg             IN_PAR_TYP,
  output   integer         PPass
  );
    begin
      P_DATA_tb = IN_P_DATA;
      PAR_EN_tb = IN_PAR_EN;
      PAR_TYP_tb = IN_PAR_TYP;
      Data_Valid_tb = 1'b1;
      PPass = 1;
      #104.2
      Data_Valid_tb = 1'b0;
      if(!((TX_OUT_tb == 1'b0)&&(busy_tb == 1'b1)))
        begin
         PPass = 0;
        end
      #104.2
      DataCompare[0] = TX_OUT_tb;
      for(i=1;i<8;i=i+1)
      begin
        if(!busy_tb)
        begin
         PPass = 0;
        end
        #104.2
       DataCompare[i] = TX_OUT_tb; 
      end
      if(!((DataCompare == IN_P_DATA)&& busy_tb))
        begin
         PPass = 0;
        end
      #104.2
      if(IN_PAR_TYP == 1'b0)
        begin
         if(!((TX_OUT_tb == (^IN_P_DATA))&&(busy_tb == 1'b1)))
          begin
           PPass = 0;
          end
       end
     else if(IN_PAR_TYP == 1'b1)
       begin
         if(!((TX_OUT_tb == ~(^IN_P_DATA))&&(busy_tb == 1'b1)))
          begin
           PPass = 0;
          end
       end
      #104.2
      if(!((TX_OUT_tb == 1'b1)&&(busy_tb == 1'b1)))
        begin
         PPass = 0;
        end
      if(IN_PAR_TYP == 1'b0)
        if(PPass)
          $display("data with even parity send successfully");
        else
          $display("data with even parity are not send");
      else if(IN_PAR_TYP == 1'b1)
        if(PPass)
          $display("data with odd parity send successfully");
        else
          $display("data with odd parity are not send");
    end
  endtask
  ////////////////////close frames check//////////////////
  task Frames_close_Check(
    input    integer     IN_pass1,
    input    integer     IN_pass2
    );
    begin
      if(IN_pass1 & IN_pass2)
        $display("two frames send without idle state between them successfully");
      else
        $display("two frames are not send without idle state between them");
    end
  endtask
  ////////////////////No Disturbance Check////////////////
  task NoDisturbance_Check;
    begin
      P_DATA_tb = 8'b11011001;
      PAR_EN_tb = 1'b0;
      Data_Valid_tb = 1'b1;
      pass = 1;
      #104.2
      if(!((TX_OUT_tb == 1'b0)&&(busy_tb == 1'b1)))
        begin
         pass = 0;
        end
      P_DATA_tb = 8'b11011111;
      #104.2
      DataCompare[0] = TX_OUT_tb;
      P_DATA_tb = 8'b11000111;
      for(i=1;i<8;i=i+1)
      begin
        if(!busy_tb)
        begin
         pass = 0;
        end
        #104.2
       DataCompare[i] = TX_OUT_tb; 
      end
      if(!((DataCompare == 8'b11011001)&& busy_tb))
        begin
         pass = 0;
        end
      #104.2
      if(!((TX_OUT_tb == 1'b1)&&(busy_tb == 1'b1)))
        begin
         pass = 0;
        end
       Data_Valid_tb = 1'b0;
      #104.2 
      if(!((TX_OUT_tb == 1'b1)&&(busy_tb == 1'b0)))
        begin
         pass = 0;
        end
      if(pass)
        $display("data is not disturbted and send successfully");
      else
        $display("data is disturbted and not send");
    end
  endtask
  ////////////////////clock generation////////////////////
  always #52.1 CLK_tb = !CLK_tb;//for 9.6Khz clock
  /////////////////// DUT Instantation ///////////////////
  Uart_TX_Top #(.DATAWIDTH(3)) DUT (
  .P_DATA(P_DATA_tb),
  .CLK(CLK_tb),
  .RST_SYN(RST_SYN_tb),
  .RST_ASYN(RST_ASYN_tb),
  .Data_Valid(Data_Valid_tb),
  .PAR_EN(PAR_EN_tb),
  .PAR_TYP(PAR_TYP_tb),
  .TX_OUT(TX_OUT_tb),
  .busy(busy_tb));
endmodule
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
// KEYWORDS: UART controller, finite state machine, moore state machine
//------------------------------------------------
// PURPOSE:   finite state machine act as controller for uart TX\
module FSM(//defining the FSM input and outputs ports
  input     wire             FSM_RST_SYN,
  input     wire             FSM_RST_ASYN,
  input     wire             FSM_CLK,
  input     wire             FSM_DataValid,
  input     wire             FSM_SerDone,
  input     wire             FSM_ParEn,
  output    reg              FSM_SerEn,
  output    reg    [1:0]     FSM_MuxSel,
  output    reg              FSM_Busy
  );
  
  /////////defining the states , gray encoding is used////////
  
  reg      [2:0]     Current_State;
  reg      [2:0]     Next_State;
  
  localparam IDLE       = 3'b000,
  Transmission_Start    = 3'b001,
  Transmission_Data     = 3'b011,
  Transmission_Parity   = 3'b010,
  Transmission_Stop     = 3'b110;
  
  /////////////////////state transition///////////////////
  always@(posedge FSM_CLK or negedge FSM_RST_ASYN)
  begin
    if(!FSM_RST_ASYN)
      Current_State <= IDLE ;
    else if((!FSM_RST_SYN))
      Current_State <= IDLE ;
    else
      Current_State <= Next_State ;
  end
  
  //////////////////next state logic///////////////////
  always@(*)
  begin
    case(Current_State)
      IDLE                   : begin
                                if(FSM_DataValid)
                                  Next_State = Transmission_Start;
                                else
                                  Next_State = IDLE; 
                              end
      Transmission_Start    :  begin
                                Next_State = Transmission_Data;
                              end
      Transmission_Data     :  begin
                                if(FSM_SerDone)
                                  begin
                                    if(FSM_ParEn)
                                      Next_State = Transmission_Parity;
                                    else
                                      Next_State = Transmission_Stop;
                                  end
                                else
                                  begin
                                   Next_State = Transmission_Data; 
                                  end
                              end
      Transmission_Parity   :  begin
                                Next_State = Transmission_Stop;
                             end
      Transmission_Stop     :  begin
                                if(FSM_DataValid)
                                  Next_State = Transmission_Start;
                                else
                                  Next_State = IDLE;
                             end
      default               :  begin
                                Next_State = IDLE;
                             end
    endcase
  end
  
  ////////////////////output logic////////////////////
  always@(*)
  begin
    case(Current_State)
      IDLE                   : begin
                                FSM_MuxSel = 2'b00;
                                FSM_Busy = 1'b0;
                                FSM_SerEn = 1'b0; 
                              end
      Transmission_Start    :  begin
                                FSM_MuxSel = 2'b01;
                                FSM_Busy = 1'b1;
                                FSM_SerEn = 1'b0;                                
                              end
      Transmission_Data     :  begin
                                FSM_MuxSel = 2'b11;
                                FSM_Busy = 1'b1;
                                FSM_SerEn = 1'b1;                                 
                              end
      Transmission_Parity   :  begin
                                FSM_MuxSel = 2'b10;
                                FSM_Busy = 1'b1;
                                FSM_SerEn = 1'b0; 
                             end
      Transmission_Stop     :  begin
                                FSM_MuxSel = 2'b00;
                                FSM_Busy = 1'b1;
                                FSM_SerEn = 1'b0;  
                             end
      default               :  begin
                                FSM_MuxSel = 2'b00;
                                FSM_Busy = 1'b0;
                                FSM_SerEn = 1'b0;   
                             end
    endcase
  end
endmodule


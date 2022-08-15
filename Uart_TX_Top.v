// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 8/7/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: uart transmitter communication protocol vlsi
//------------------------------------------------
// PURPOSE: this is the top module for the uart transmitter\

/////////input and outputs ports declaration////////////
module Uart_TX_Top #(parameter DATAWIDTH = 3) (//data width is calculated by 2*n
input    wire    [2**DATAWIDTH-1:0]    P_DATA,
input    wire                          CLK,
input    wire                          RST_ASYN,
input    wire                          Data_Valid,
input    wire                          PAR_EN,
input    wire                          PAR_TYP,
output   wire                          TX_OUT,
output   wire                          busy);


wire    [2**DATAWIDTH-1:0]    Parallel_Data;
wire    [1:0]                 FSM_MUXSelection;
wire                          Ser_En;
wire                          Ser_Done;
wire                          Parity_En;
wire                          Parity_bit;
wire                          Parity_bit_To_Buffer;
wire                          Seralizer_RST;
wire                          BuffEn;
wire                          Serial_Data;

////////////////////model instantiations///////////////
InputBuffer #(.DataWIDTH(DATAWIDTH)) U0_InputBuffer (
.Buffer_Pdata_in(P_DATA),
.Buffer_ParityEn_in(PAR_EN),
.Buffer_ParBit_in(Parity_bit_To_Buffer),
.Buffer_EN(BuffEn),
.Buffer_CLK(CLK),
.Buffer_RST_ASYN(RST_ASYN),
.Buffer_Pdata_out(Parallel_Data),
.Buffer_ParityEn_out(Parity_En),
.Buffer_ParBit_out(Parity_bit));

Parity_Calc #(.DataWIDTH(DATAWIDTH)) U0_Parity_Calc (
.ParityCalc_PDATA(P_DATA),
.ParityCalc_DataValid(Data_Valid),
.ParityCalc_ParType(PAR_TYP),
.ParityCalc_ParBit(Parity_bit_To_Buffer));

FSM U0_FSM (
.FSM_RST_ASYN(RST_ASYN),
.FSM_CLK(CLK),
.FSM_DataValid(Data_Valid),
.FSM_SerDone(Ser_Done),
.FSM_ParEn(Parity_En),
.FSM_SerEn(Ser_En),
.FSM_MuxSel(FSM_MUXSelection),
.FSM_Busy(busy),
.FSM_BuffEn(BuffEn));

Seralizer #(.WIDTH(DATAWIDTH)) U0_Seralizer (
.Seralizer_ParallelData(Parallel_Data),
.Seralizer_CLK(CLK),
.Seralizer_RST_ASYN(RST_ASYN ),
.Seralizer_En(Ser_En),
.Seralizer_done(Ser_Done),
.Seralizer_SerialData(Serial_Data));

MUX U0_MUX (
.Selection_Bits(FSM_MUXSelection),
.in_00(1'b1),
.in_01(1'b0),
.in_10(Parity_bit),
.in_11(Serial_Data),
.MUX_Out(TX_OUT));
endmodule

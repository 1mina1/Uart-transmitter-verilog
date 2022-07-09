// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 8/7/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: input buffer, uart memory
//------------------------------------------------
// PURPOSE: this acts as buffer of uart because uart doesn' accept new data while transmitting\

/////////input and outputs ports declaration////////////
module InputBuffer #(parameter DataWIDTH=3) (
  input    wire    [2**(DataWIDTH)-1:0]    Buffer_Pdata_in,
  input    wire                            Buffer_ParityEn_in,
  input    wire                            Buffer_ParBit_in,
  input    wire                            Buffer_EN,
  input    wire                            Buffer_CLK,
  input    wire                            Buffer_RST_SYN,
  input    wire                            Buffer_RST_ASYN,
  output   reg     [2**(DataWIDTH)-1:0]    Buffer_Pdata_out,
  output   reg                             Buffer_ParityEn_out,
  output   reg                             Buffer_ParBit_out);
  
  
  /////////////buffer sequentional logic/////////////////
  always@(posedge Buffer_CLK or negedge Buffer_RST_ASYN)
  begin
    if(!Buffer_RST_ASYN)
      begin
       Buffer_Pdata_out <= 'b0;
       Buffer_ParityEn_out <= 1'b0;
       Buffer_ParBit_out <= 1'b0;
     end
   else if(!Buffer_RST_SYN)
     begin
       Buffer_Pdata_out <= 'b0;
       Buffer_ParityEn_out <= 1'b0;
       Buffer_ParBit_out <= 1'b0;
     end
   else if(Buffer_EN)
     begin
       Buffer_Pdata_out <= Buffer_Pdata_in;
       Buffer_ParityEn_out <= Buffer_ParityEn_in;
       Buffer_ParBit_out <= Buffer_ParBit_in;
     end
  end
  
endmodule


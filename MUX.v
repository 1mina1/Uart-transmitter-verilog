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
// KEYWORDS: multiplexer ,4x1 mux
//------------------------------------------------
// PURPOSE: this is the multiplexer for the uart\

/////////input and outputs ports declaration////////////
module MUX (
  input     wire    [1:0]    Selection_Bits,
  input     wire             in_00,
  input     wire             in_01,
  input     wire             in_10,
  input     wire             in_11,
  output    reg              MUX_Out);
  ////////////////MUX Logic///////////////////////////
  always@(*)
  begin
    case(Selection_Bits)
      2'b00        : begin
                      MUX_Out = in_00;
                    
                     end
      2'b01        : begin
                      MUX_Out = in_01;
                    
                     end
      2'b10        : begin
                      MUX_Out = in_10;
                    
                     end
      2'b11        : begin
                      MUX_Out = in_11;
                    
                     end
      default      : begin
                      MUX_Out = in_00;
                    
                     end
    endcase
  end
endmodule

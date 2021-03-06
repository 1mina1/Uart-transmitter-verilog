# Uart Transmitter
this is the uart transmitter done using verilog-HDL and it has the following specifications:<br />
1-the uart can only recieve data only when Data_valid signal is high and doesn't accept any data during transmission<br />
2-the uart has a busy signal high during transmission process<br />
3-the uart has one start bit which is low signal and one stop bit which is high signal<br />
4-the uart can send data without parity or with even or odd parity (o for even and 1 for odd)<br />
5-the uart output is high during idle case<br />

so the uart waveform should be as following<br />

![Screenshot 2022-07-09 211413](https://user-images.githubusercontent.com/81904314/178119751-25a4b61f-17c4-4eae-ad20-d9cffc55978d.png)

<br />the uart was simplified into 5 Blocks as following:
1-FSM (finite state machine)<br />
2-Seralizer<br />
3-Parity calculator<br />
4-mux<br />
5-input buffer<br />




![Untitled Diagram drawio](https://user-images.githubusercontent.com/81904314/178120592-2cb83ce1-d832-4594-bcfa-ac3563aff66c.png)

<br />next is a brief of all the blocks<br />
# FSM
the finite state machine is done using moore states and gray encoding for less switching power and has the following states : <br />
1-IDLE state in which the multiplexer is set at the at 00 which is the stop bit as it is high the same value for TX_out during idle and busy signal is low.<br />
2- start state in which mux is set at 01 and busy signal is high.<br />
3-transmission state in which mux is set at 11 and busy signal is high and seralizer is enabled .<br />
4-Parity state if enable mux is set at 10 and busy signal is high to transmit parity bit.<br />
5-stop state mux is again at 00 and busy signal is high.<br />
# seralizer
with a help of a counter the seralizer transforms parallel data into serial data<br />
# parity calculator
calculate the parity then stores it into the buffer, it is done by xor all bits of the data for even parity and inverting it for odd parity<br />
# mux
a simple 4x1 multiplexer<br />
# input buffer
used to help keep the uart from changing the data during transmission<br />

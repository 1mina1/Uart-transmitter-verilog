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



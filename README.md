# Uart Transmitter
this is the uart transmitter done using verilog-HDL and it has the following specifications:
1-the uart can only recieve data only when Data_valid signal is high and doesn't accept any data during transmission
2-the uart has a busy signal high during transmission process
3-the uart has one start bit which is low signal and one stop bit which is high signal
4-the uart can send data without parity or with even or odd parity (o for even and 1 for odd)
5-the uart output is high during idle case

so the uart waveform should be as following

![Uploading Screenshot 2022-07-09 211413.png…]()

the uart was simplified into 5 Blocks as following:
1-FSM (finite state machine)
2-Seralizer
3-Parity calculator
4-mux
5-input buffer



`include "UART_TX.v"
`include "UART_RX.v"
`include "LFSR.v"
`include "SAR.v"
`include "Baud_rate_generator.v"

module UART_TOP (
    input clk,
    input rst_n,
    input mode,
    input i_TX_DV,
    input [7:0] tx_byte,
    input [1:0] baud_rate,
    output o_RX_DV,
    output [7:0] rx_byte,
    output [15:0] o_SAR_Tx,
    output [15:0] o_SAR_Rx
);

  wire baud_clk;
  wire [7:0] w_LFSR_Byte;
  wire w_TX_Serial;
  //wire w_RX_DV;
  //wire [7:0] w_RX_Byte;
  wire [15:0] w_SAR_Tx;
  wire [15:0] w_SAR_Rx;
  wire [7:0] input_data;

assign input_data = (mode)? w_LFSR_Byte : tx_byte;

//  BaudGenT BaudGenT_inst(rst_n, clk, baud_rate, baud_clk);

  UART_TX #(.CLK_FREQ(25000000), .BAUD_RATE(115200)) UART_TX_INST (
    .i_Rst_L(rst_n),
    .i_Clock(clk),
    .i_TX_DV(i_TX_DV),
    .i_TX_Byte(input_data),
    .o_TX_Active(),
    .o_TX_Serial(w_TX_Serial),
    .o_TX_Done()
  );
    
  UART_RX #(.CLK_FREQ(25000000), .BAUD_RATE(115200)) UART_RX_INST (
    .i_Clock(clk),
    .i_RX_Serial(w_TX_Serial),
    .o_RX_DV(o_RX_DV),
    .o_RX_Byte(rx_byte)
  );

    LFSR #(.WIDTH(16), .SEED(16'hACE1)) LFSR_INST (
    .i_Clock(clk),
    .i_Enable(i_TX_DV),
    .o_LFSR_Byte(w_LFSR_Byte)
  );

  SAR #(.WIDTH(16)) SAR_TX_INST (
    .i_Clock(clk),
    .i_Enable(i_TX_DV),
    .i_Data(w_LFSR_Byte),
    .o_SAR(w_SAR_Tx)
  );

  SAR #(.WIDTH(16)) SAR_RX_INST (
    .i_Clock(clk),
    .i_Enable(o_RX_DV),
    .i_Data(rx_byte),
    .o_SAR(w_SAR_Rx)
  );

assign o_SAR_Tx = w_SAR_Tx;
assign o_SAR_Rx = w_SAR_Rx;


endmodule
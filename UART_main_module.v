`timescale 1ns / 1ps
module UART_MAIN(
    input clk,
    input rst,
    input [7:0] data_in,
    input wr_en,
    input rdy_clr,
    output rdy,
    output tx_busy,
    output [7:0] data_out
);

wire tx_clk_en;
wire rx_clk_en;
wire tx_line;
Baud_rate_renerator BRG (.clock(clk),.reset(rst),.enb_tx(tx_clk_en),.enb_rx(rx_clk_en));
UART_TX TX (.clk(clk),.wr_en(wr_en),.enb(tx_clk_en),.rst(rst),.data_in(data_in),.tx(tx_line),.tx_busy(tx_busy));
UART_RX RX (.clk(clk),.rst(rst),.rx(tx_line),.rdy_clr(rdy_clr),.clken(rx_clk_en),.rdy(rdy),.data_out(data_out));
endmodule

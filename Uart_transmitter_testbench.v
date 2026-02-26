`timescale 1ns / 1ps
module UART_MAIN_tb();
    // Inputs
    reg clk;
    reg rst;
    reg [7:0] data_in;
    reg wr_en;
    reg rdy_clr;

    // Outputs
    wire rdy;
    wire tx_busy;
    wire [7:0] data_out;

    // Instantiate DUT
    UART_MAIN uut (.clk(clk),.rst(rst),.data_in(data_in),.wr_en(wr_en),.rdy_clr(rdy_clr),.rdy(rdy),.tx_busy(tx_busy),.data_out(data_out));

    // 100 MHz clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        wr_en = 0;
        rdy_clr = 0;
        data_in = 8'h00;

        // Apply reset
        #100;
        rst = 0;

        // Send first byte
        #200;
        data_in = 8'b10101010;
        wr_en = 1;

        #10;
        wr_en = 0;

        // Wait until receiver ready
        wait(rdy == 1);

        // Clear ready
        #50;
        rdy_clr = 1;
        #20;
        rdy_clr = 0;
        #200;
        data_in = 8'b10111010;
        wr_en = 1;

        #10;
        wr_en = 0;

        // Wait until receiver ready
        wait(rdy == 1);

        // Clear ready
        #50;
        rdy_clr = 1;
        #20;
        rdy_clr = 0;

        // Send another byte
        #200;
        data_in = 8'b11001100;
        wr_en = 1;

        #10;
        wr_en = 0;

        wait(rdy == 1);

        #1000000;

        $stop;
    end
endmodule

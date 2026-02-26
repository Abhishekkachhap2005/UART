`timescale 1ns / 1ps
module UART_TX_tb();
    // Inputs
    reg clk;
    reg wr_en;
    reg enb;
    reg rst;
    reg [7:0] data_in;

    // Outputs
    wire tx;
    wire tx_busy;

    // Instantiate DUT
    UART_TX uut (
        .clk(clk),
        .wr_en(wr_en),
        .enb(enb),
        .rst(rst),
        .data_in(data_in),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // 100 MHz Clock (10ns period)
    always #5 clk = ~clk;

    // Generate baud enable pulse (for simulation speed)
    // Instead of real 9600 timing, we generate enb every 100ns
    always begin
        #100 enb = 1;
        #10  enb = 0;
    end

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        wr_en = 0;
        enb = 0;
        data_in = 8'h00;

        // Apply reset
        #50;
        rst = 0;

        // Send a byte
        #100;
        data_in = 8'b10101011;
        wr_en = 1;

        #10;
        wr_en = 0;

        // Wait until transmission completes
        wait(tx_busy == 0);

        #500;

        $stop;
    end

endmodule

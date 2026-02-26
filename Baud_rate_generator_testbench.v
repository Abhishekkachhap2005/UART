`timescale 1ns / 1ps

module Baud_rate_renerator_tb();
    // Inputs
    reg clock;
    reg reset;

    // Outputs
    wire enb_tx;
    wire enb_rx;

    // Instantiate the DUT (Device Under Test)
    Baud_rate_renerator uut (
        .clock(clock),
        .reset(reset),
        .enb_tx(enb_tx),
        .enb_rx(enb_rx)
    );

    // 100 MHz Clock Generation (10ns period)
    always #5 clock = ~clock;

    initial begin
        // Initialize Inputs
        clock = 0;
        reset = 1;

        // Apply reset for some time
        #50;
        reset = 0;

        // Run simulation for sufficient time
        // For 9600 baud, one pulse ≈ 10416 clock cycles
        // 10416 * 10ns ≈ 104160ns
        #500000;

        $stop;
    end


endmodule

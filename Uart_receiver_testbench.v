`timescale 1ns / 1ps
module UART_RX_tb();
    // Inputs
    reg clk;
    reg rst;
    reg rx;
    reg rdy_clr;
    reg clken;

    // Outputs
    wire rdy;
    wire [7:0] data_out;

    // Instantiate DUT
    UART_RX uut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rdy_clr(rdy_clr),
        .clken(clken),
        .rdy(rdy),
        .data_out(data_out)
    );

    // 100 MHz clock (10ns period)
    always #5 clk = ~clk;

    // Generate 16x sampling clock enable (FAST for simulation)
    always begin
        #20 clken = 1;   // pulse
        #10 clken = 0;
    end

    // Task to send one UART frame
    task send_byte;
        input [7:0] data;
        integer i;
        begin
            // Start bit
            rx = 0;
            #(16*30);

            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(16*30);
            end

            // Stop bit
            rx = 1;
            #(16*30);
        end
    endtask

    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        rx = 1;          // Idle line HIGH
        rdy_clr = 0;
        clken = 0;

        // Release reset
        #100;
        rst = 0;

        // Send test byte
        #200;
        send_byte(8'b10101011);

        // Wait for receiver ready
        wait(rdy == 1);

        #50;
        rdy_clr = 1;
        #20;
        rdy_clr = 0;

        #5000;
        $stop;
    end

endmodule

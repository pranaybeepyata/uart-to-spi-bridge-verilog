`timescale 1ns/1ps

module spi_master_tb;

    reg clk = 0;
    reg rst = 0;
    reg start = 0;
    reg [7:0] data_in = 0;

    wire mosi;
    wire sclk;
    wire cs;

    // Instantiate SPI Master
    spi_master uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .mosi(mosi),
        .sclk(sclk),
        .cs(cs)
    );

    // Clock generation (10ns → 100MHz)
    always #5 clk = ~clk;

    initial begin
        // Reset
        rst = 1;
        #20;
        rst = 0;

        // Send first data
        #10;
        data_in = 8'b10001000;
        start = 1;
        #10;
        start = 0;

        // Wait for SPI to finish
        #300;

        // Send another data
        data_in = 8'b10101010;
        start = 1;
        #10;
        start = 0;

        #300;

        $stop;
    end

endmodule

`timescale 1ns/1ps

module uart_to_spi_bridge_tb;

// ---------------- PARAMETERS ----------------
parameter CLKS_PER_BIT = 8;

// ---------------- SIGNALS ----------------
reg clk = 0;
reg rst = 0;
reg rx_serial = 1;   // UART idle = 1

wire mosi;
wire sclk;
wire cs;

// ---------------- DUT ----------------
uart_to_spi_bridge uut (
    .clk(clk),
    .rst(rst),
    .rx_serial(rx_serial),
    .mosi(mosi),
    .sclk(sclk),
    .cs(cs)
);

// ---------------- CLOCK ----------------
always #5 clk = ~clk;   // 10ns clock

// -------- UART BIT SEND TASK --------
task send_uart_bit;
    input b;
    integer i;
begin
    for (i = 0; i < CLKS_PER_BIT; i = i + 1) begin
        @(posedge clk);
        rx_serial <= b;
    end
end
endtask

// -------- UART BYTE SEND TASK --------
task send_uart_byte;
    input [7:0] data;
    integer i;
begin
    // Idle before start
    send_uart_bit(1);

    // Start bit
    send_uart_bit(0);

    // Data bits (LSB first)
    for (i = 0; i < 8; i = i + 1)
        send_uart_bit(data[i]);

    // Stop bit
    send_uart_bit(1);
end
endtask

// -------- TEST SEQUENCE --------
initial begin
    rst = 1;
    rx_serial = 1;
    #50;
    rst = 0;

    // Wait for stability
    repeat(20) @(posedge clk);

    // Send data
    send_uart_byte(8'b10001000);

    // Wait enough time
    repeat(2000) @(posedge clk);

    $stop;
end

endmodule

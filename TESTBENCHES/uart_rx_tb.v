`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2026 01:41:41 PM
// Design Name: 
// Module Name: uart_rx_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////




module uart_rx_tb;

    reg clk = 0;
    reg rst = 0;
    reg rx = 1;

    wire [7:0] data;
    wire dv;

    // Instantiate UART RX
    uart_rx #(.CLKS_PER_BIT(8)) uut (
        .i_clk(clk),
        .i_rst(rst),
        .i_rx_serial(rx),
        .o_rx_dv(dv),
        .o_rx_byte(data)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    // Task to send 1 bit
   task send_bit;
    input b;
        begin
            rx = b;
            #80; // 8 clocks × 10ns
        end
    endtask

    initial begin

        // Reset
        rst = 1;
        #20;
        rst = 0;

        // Start bit
        send_bit(0);

        // Data bits (LSB first)
        send_bit(0); // D0
        send_bit(0); // D1
        send_bit(0); // D2
        send_bit(1); // D3
        send_bit(0); // D4
        send_bit(0); // D5
        send_bit(0); // D6
        send_bit(1); // D7

        // Stop bit
        send_bit(1);

        #200;
        $stop;
    end

endmodule

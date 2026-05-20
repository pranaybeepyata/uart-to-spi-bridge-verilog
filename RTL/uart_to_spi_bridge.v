module uart_to_spi_bridge(
    input wire clk,
    input wire rst,

    // UART side
    input wire rx_serial,

    // SPI outputs
    output wire mosi,
    output wire sclk,
    output wire cs,output wire uart_dv_debug,
output wire start_spi_debug
);


assign uart_dv_debug = uart_dv;
assign start_spi_debug = start_spi;


reg [7:0] r_clk_count = 0;
reg [7:0] r_bit_index = 0;
// ---------------- UART RX ----------------
wire [7:0] uart_data;
wire uart_dv;

uart_rx uart_inst (
    .i_clk(clk),
    .i_rst(rst),
    .i_rx_serial(rx_serial),
    .o_rx_dv(uart_dv),
    .o_rx_byte(uart_data)
);

// ---------------- SPI MASTER ----------------
reg start_spi = 0;
reg [7:0] spi_data = 0;

spi_master spi_inst (
    .clk(clk),
    .rst(rst),
    .start(start_spi),
    .data_in(spi_data),
    .mosi(mosi),
    .sclk(sclk),
    .cs(cs)
);

// ---------------- BRIDGE LOGIC ----------------
always @(posedge clk) begin
    if (rst) begin
        start_spi <= 0;
        spi_data <= 0;
    end
    else begin

        // Generate 1-cycle pulse
        if (uart_dv) begin
            spi_data <= uart_data;
            start_spi <= 1;
        end
        else begin
            start_spi <= 0;
        end

    end
end

endmodule
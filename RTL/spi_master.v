module spi_master(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] data_in,

    output reg mosi,
    output reg sclk,
    output reg cs
);

    reg [7:0] shift_reg = 0;
    reg [2:0] bit_index = 0;
    reg busy = 0;

    always @(posedge clk) begin
        if (rst) begin
            cs <= 1;
            sclk <= 0;
            busy <= 0;
            bit_index <= 0;
        end 
        else begin

            // Start transmission
            if (start && !busy) begin
                cs <= 0;
                shift_reg <= data_in;
                busy <= 1;
                bit_index <= 0;
                sclk <= 0;
            end

            // During transmission
            if (busy) begin
                sclk <= ~sclk;

                // Send data on falling edge
                if (sclk == 0) begin
                    mosi <= shift_reg[7];
                    shift_reg <= shift_reg << 1;
                    bit_index <= bit_index + 1;

                    if (bit_index == 7) begin
                        busy <= 0;
                        cs <= 1;
                        sclk <= 0;
                    end
                end
            end

        end
    end

endmodule

module uart_rx #(
    parameter CLKS_PER_BIT = 16
)(
    input wire i_clk,
    input wire i_rst,
    input wire i_rx_serial,
    output reg o_rx_dv,
    output reg [7:0] o_rx_byte
);

    parameter IDLE = 3'b000;
    parameter START_BIT = 3'b001;
    parameter DATA_BITS = 3'b010;
    parameter STOP_BIT = 3'b011;
    parameter CLEANUP = 3'b100;

    reg [2:0] r_state = IDLE;
    reg [7:0] r_clk_count = 0;
    reg [7:0] r_bit_index = 0;
    reg [7:0] r_rx_byte = 0;
    
   

    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            r_state <= IDLE;
            r_clk_count <= 0;
            r_bit_index <= 0;
            o_rx_dv <= 0;
        end else begin
            case (r_state)

                IDLE: begin
                    o_rx_dv <= 0;
                    r_clk_count <= 0;
                    r_bit_index <= 0;
                    if (i_rx_serial == 0)
                        r_state <= START_BIT;
                end

                START_BIT: begin
                    if (r_clk_count == (CLKS_PER_BIT-1)/2) begin
                        if (i_rx_serial == 0) begin
                            r_clk_count <= 0;
                            r_state <= DATA_BITS;
                        end else
                            r_state <= IDLE;
                    end else
                        r_clk_count <= r_clk_count + 1;
                end

              DATA_BITS: begin
                 if (r_clk_count < CLKS_PER_BIT-1)
        r_clk_count <= r_clk_count + 1;
    else begin
        r_clk_count <= 0;
        r_rx_byte[r_bit_index] <= i_rx_serial;

        if (r_bit_index < 7)
            r_bit_index <= r_bit_index + 1;
        else begin
            r_bit_index <= 0;
            r_state <= STOP_BIT;
        end
    end
end 

                STOP_BIT: begin
                    if (r_clk_count < CLKS_PER_BIT-1)
                        r_clk_count <= r_clk_count + 1;
                    else begin
                        o_rx_dv <= 1;
                        o_rx_byte <= r_rx_byte;
                        r_clk_count <= 0;
                        r_state <= CLEANUP;
                    end
                end

                CLEANUP: begin
                    r_state <= IDLE;
                    o_rx_dv <= 0;
                end

                default: r_state <= IDLE;

            endcase
        end
    end

endmodule
module multiplier (
    input  wire               clk,
    input  wire               rst,
    input  wire               ce_m,
    input  wire signed [24:0] ad_reg,
    input  wire signed [17:0] b_reg,
    output reg  signed [42:0] m_reg
);

    wire signed [42:0] mult_result;

    assign mult_result = ad_reg * b_reg;

    always @(posedge clk) begin
        if (rst) begin
            m_reg <= 43'sd0;
        end else if (ce_m) begin
            m_reg <= mult_result;
        end
    end
endmodule
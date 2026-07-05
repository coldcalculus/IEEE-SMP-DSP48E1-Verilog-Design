module input_reg_bank (
    input  wire               clk,
    input  wire               rst,
    input  wire               ce_a,
    input  wire               ce_b,
    input  wire               ce_c,
    input  wire               ce_d,
    input  wire signed [24:0] data_a,
    input  wire signed [17:0] data_b,
    input  wire signed [47:0] data_c,
    input  wire signed [24:0] data_d,
    output reg  signed [24:0] a_reg,
    output reg  signed [17:0] b_reg,
    output reg  signed [47:0] c_reg,
    output reg  signed [24:0] d_reg
);

    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 25'sd0;
            b_reg <= 18'sd0;
            c_reg <= 48'sd0;
            d_reg <= 25'sd0;
        end else begin
            if (ce_a) a_reg <= data_a;
            if (ce_b) b_reg <= data_b;
            if (ce_c) c_reg <= data_c;
            if (ce_d) d_reg <= data_d;
        end
    end
endmodule
`include "dsp_slice_params.vh"

module pre_adder (
    input  wire               clk,
    input  wire               rst,
    input  wire               ce_ad,
    input  wire        [1:0]  inmode,
    input  wire signed [24:0] a_reg,
    input  wire signed [24:0] d_reg,
    output reg  signed [24:0] ad_reg
);

    reg signed [24:0] pre_adder_result;

    always @(*) begin
        case (inmode)
            INMODE_BYPASS: pre_adder_result = a_reg;
            INMODE_ADD:    pre_adder_result = a_reg + d_reg;
            INMODE_SUB:    pre_adder_result = a_reg - d_reg;
            default:       pre_adder_result = a_reg;
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            ad_reg <= 25'sd0;
        end else if (ce_ad) begin
            ad_reg <= pre_adder_result;
        end
    end
endmodule
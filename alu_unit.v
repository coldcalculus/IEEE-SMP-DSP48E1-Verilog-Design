`include "dsp_slice_params.vh"

module alu_unit (
    input  wire signed [47:0] x_out,
    input  wire signed [47:0] y_out,
    input  wire signed [47:0] z_out,
    input  wire        [1:0]  alu_sel,
    output reg  signed [47:0] alu_result
);

    always @(*) begin
        case (alu_sel)
            ALU_ADD_Z:  alu_result = z_out + (x_out + y_out);
            ALU_SUB_Z:  alu_result = z_out - (x_out + y_out);
            ALU_ADD_XY: alu_result = x_out + y_out;
            default:    alu_result = 48'sd0;
        endcase
    end
endmodule
`include "dsp_slice_params.vh"

module operand_mux (
    input  wire        [5:0]  opmode,
    input  wire signed [24:0] a_reg,
    input  wire signed [17:0] b_reg,
    input  wire signed [47:0] c_reg,
    input  wire signed [42:0] m_reg,
    input  wire signed [47:0] p_reg,
    output reg  signed [47:0] x_out,
    output reg  signed [47:0] y_out,
    output reg  signed [47:0] z_out
);

    wire [42:0] concat_ab = {a_reg[24:0], b_reg[17:0]};

    // X MUX
    always @(*) begin
        case (opmode[1:0])
            X_ZERO:   x_out = 48'sd0;
            X_CONCAT: x_out = $signed({{5{concat_ab[42]}}, concat_ab});
            X_M_REG:  x_out = $signed({{5{m_reg[42]}}, m_reg});
            default:  x_out = 48'sd0;
        endcase
    end

    // Y MUX
    always @(*) begin
        case (opmode[3:2])
            Y_ZERO:  y_out = 48'sd0;
            Y_M_REG: y_out = $signed({{5{m_reg[42]}}, m_reg});
            Y_C_REG: y_out = c_reg;
            default: y_out = 48'sd0;
        endcase
    end

    // Z MUX
    always @(*) begin
        case (opmode[5:4])
            Z_ZERO:  z_out = 48'sd0;
            Z_P_REG: z_out = p_reg;
            Z_C_REG: z_out = c_reg;
            default: z_out = 48'sd0;
        endcase
    end
endmodule
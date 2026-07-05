module dsp_slice_top (
    input  wire               clk,
    input  wire               rst,
    input  wire [2:0]         cmd,
    input  wire               start,
    input  wire signed [24:0] data_a,
    input  wire signed [17:0] data_b,
    input  wire signed [47:0] data_c,
    input  wire signed [24:0] data_d,
    output wire signed [47:0] data_p,
    output wire               busy,
    output wire               result_valid
);

    // Internal wires for Control Path
    wire ce_a, ce_b, ce_c, ce_d, ce_ad, ce_m, ce_p;
    wire [1:0] inmode;
    wire [5:0] opmode;
    wire [1:0] alu_sel;

    // Internal wires for Data Path
    wire signed [24:0] a_reg, d_reg, ad_reg;
    wire signed [17:0] b_reg;
    wire signed [47:0] c_reg, p_reg;
    wire signed [42:0] m_reg;
    wire signed [47:0] x_out, y_out, z_out, alu_result;

    // Assign final output
    assign data_p = p_reg;

    // 1. Control FSM
    slice_ctrl_fsm u_fsm (
        .clk(clk),
        .rst(rst),
        .cmd(cmd),
        .start(start),
        .ce_a(ce_a),
        .ce_b(ce_b),
        .ce_c(ce_c),
        .ce_d(ce_d),
        .ce_ad(ce_ad),
        .ce_m(ce_m),
        .ce_p(ce_p),
        .inmode(inmode),
        .opmode(opmode),
        .alu_sel(alu_sel),
        .busy(busy),
        .result_valid(result_valid)
    );

    // 2. Input Register Bank
    input_reg_bank u_input_regs (
        .clk(clk),
        .rst(rst),
        .ce_a(ce_a),
        .ce_b(ce_b),
        .ce_c(ce_c),
        .ce_d(ce_d),
        .data_a(data_a),
        .data_b(data_b),
        .data_c(data_c),
        .data_d(data_d),
        .a_reg(a_reg),
        .b_reg(b_reg),
        .c_reg(c_reg),
        .d_reg(d_reg)
    );

    // 3. Pre-Adder
    pre_adder u_pre_adder (
        .clk(clk),
        .rst(rst),
        .ce_ad(ce_ad),
        .inmode(inmode),
        .a_reg(a_reg),
        .d_reg(d_reg),
        .ad_reg(ad_reg)
    );

    // 4. Multiplier
    multiplier u_multiplier (
        .clk(clk),
        .rst(rst),
        .ce_m(ce_m),
        .ad_reg(ad_reg),
        .b_reg(b_reg),
        .m_reg(m_reg)
    );

    // 5. Operand Mux
    operand_mux u_operand_mux (
        .opmode(opmode),
        .a_reg(a_reg),
        .b_reg(b_reg),
        .c_reg(c_reg),
        .m_reg(m_reg),
        .p_reg(p_reg),
        .x_out(x_out),
        .y_out(y_out),
        .z_out(z_out)
    );

    // 6. ALU Unit
    alu_unit u_alu_unit (
        .x_out(x_out),
        .y_out(y_out),
        .z_out(z_out),
        .alu_sel(alu_sel),
        .alu_result(alu_result)
    );

    // 7. Output Register
    output_reg u_output_reg (
        .clk(clk),
        .rst(rst),
        .ce_p(ce_p),
        .alu_result(alu_result),
        .p_reg(p_reg)
    );

endmodule
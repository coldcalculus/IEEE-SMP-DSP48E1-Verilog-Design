`include "dsp_slice_params.vh"

module slice_ctrl_fsm (
    input  wire       clk,
    input  wire       rst,
    input  wire [2:0] cmd,
    input  wire       start,
    output reg        ce_a,
    output reg        ce_b,
    output reg        ce_c,
    output reg        ce_d,
    output reg        ce_ad,
    output reg        ce_m,
    output reg        ce_p,
    output reg  [1:0] inmode,
    output reg  [5:0] opmode,
    output reg  [1:0] alu_sel,
    output reg        busy,
    output reg        result_valid
);

    // State definitions
    localparam IDLE   = 3'b000;
    localparam LOAD   = 3'b001;
    localparam MULT   = 3'b010;
    localparam ALU_OP = 3'b011;
    localparam OUTPUT = 3'b100;

    reg [2:0] state, next_state;
    
    // Control pipeline registers
    reg [5:0] opmode_r1, opmode_r2;
    reg [1:0] alu_sel_r1, alu_sel_r2;

    // Command decoding variables
    reg [1:0] dec_inmode;
    reg [5:0] dec_opmode;
    reg [1:0] dec_alu_sel;

    // Command Decoder
    always @(*) begin
        case (cmd)
            CMD_MACC, CMD_CHAIN: begin
                dec_inmode  = INMODE_BYPASS;
                dec_opmode  = {Z_P_REG, Y_ZERO, X_M_REG};
                dec_alu_sel = ALU_ADD_Z;
            end
            CMD_LOAD_C: begin
                dec_inmode  = INMODE_BYPASS;
                dec_opmode  = {Z_C_REG, Y_ZERO, X_ZERO};
                dec_alu_sel = ALU_ADD_Z;
            end
            default: begin
                dec_inmode  = INMODE_BYPASS;
                dec_opmode  = {Z_ZERO, Y_ZERO, X_ZERO};
                dec_alu_sel = ALU_ADD_XY;
            end
        endcase
    end

    // State Register
    always @(posedge clk) begin
        if (rst) state <= IDLE;
        else     state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        case (state)
            IDLE:   next_state = start ? LOAD : IDLE;
            LOAD:   next_state = MULT;
            MULT:   next_state = ALU_OP;
            ALU_OP: next_state = OUTPUT;
            OUTPUT: next_state = (cmd == CMD_CHAIN) ? LOAD : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output Logic (Moore style)
    always @(*) begin
        ce_a         = (state == LOAD);
        ce_b         = (state == LOAD);
        ce_c         = (state == LOAD);
        ce_d         = (state == LOAD);
        ce_ad        = (state == LOAD);
        ce_m         = (state == MULT);
        ce_p         = (state == ALU_OP);
        busy         = (state != IDLE);
        result_valid = (state == OUTPUT);
    end

    // Control Pipeline
    always @(posedge clk) begin
        if (rst) begin
            inmode     <= 2'b0;
            opmode_r1  <= 6'b0;
            alu_sel_r1 <= 2'b0;
            opmode_r2  <= 6'b0;
            alu_sel_r2 <= 2'b0;
        end else begin
            if (state == LOAD) begin
                inmode     <= dec_inmode;
                opmode_r1  <= dec_opmode;
                alu_sel_r1 <= dec_alu_sel;
            end
            if (ce_m) begin
                opmode_r2  <= opmode_r1;
                alu_sel_r2 <= alu_sel_r1;
            end
        end
    end

    // Drive final outputs mapped to the actual modules
    always @(*) begin
        opmode  = opmode_r2;
        alu_sel = alu_sel_r2;
    end
endmodule
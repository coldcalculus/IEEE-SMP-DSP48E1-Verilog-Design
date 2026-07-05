// dsp_slice_params.vh
// X Mux Encodings
localparam X_ZERO   = 2'b00;
localparam X_CONCAT = 2'b01;
localparam X_M_REG  = 2'b10;

// Y Mux Encodings
localparam Y_ZERO   = 2'b00;
localparam Y_M_REG  = 2'b01;
localparam Y_C_REG  = 2'b10;

// Z Mux Encodings
localparam Z_ZERO   = 2'b00;
localparam Z_P_REG  = 2'b01;
localparam Z_C_REG  = 2'b10;

// ALU Select Encodings
localparam ALU_ADD_Z  = 2'b00; // Z + (X + Y)
localparam ALU_SUB_Z  = 2'b01; // Z - (X + Y)
localparam ALU_ADD_XY = 2'b10; // X + Y

// Pre-adder Encodings
localparam INMODE_BYPASS = 2'b00;
localparam INMODE_ADD    = 2'b01;
localparam INMODE_SUB    = 2'b10;

// High-Level Commands
localparam CMD_MACC       = 3'b001; // Standard Multiply-Accumulate
localparam CMD_CHAIN      = 3'b010; // Chained Multiply-Accumulate
localparam CMD_LOAD_C     = 3'b011; // Load C into Accumulator
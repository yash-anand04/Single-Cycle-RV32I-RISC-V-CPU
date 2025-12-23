
// main_decoder.v - logic for main decoder

module main_decoder (
    input  [6:0] op,
    output [1:0] ResultSrc,
    output       MemWrite, MemRead ,Branch, ALUSrc,
    output       ASrc, RegWrite, Jump,
    output [2:0] ImmSrc,
    output [1:0] ALUOp
);

reg [13:0] controls;

always @(*) begin
    case (op)
        // RegWrite_ImmSrc_ASrc_ALUSrc_MemWrite_MemRead_ResultSrc_Branch_ALUOp_Jump
        7'b0000011: controls = 14'b1_000_0_1_0_1_01_0_00_0; // lw
        7'b0100011: controls = 14'b0_001_0_1_1_0_00_0_00_0; // sw
        7'b0110011: controls = 14'b1_xxx_0_0_0_0_00_0_10_0; // R–type
        7'b1100011: controls = 14'b0_010_0_0_0_0_10_1_01_0; // B-type   
        7'b0010011: controls = 14'b1_000_0_1_0_0_00_0_10_0; // I–type ALU
        7'b1100111: controls = 14'b1_000_1_0_0_0_10_0_00_1; // jalr 
        7'b1101111: controls = 14'b1_011_1_1_0_0_10_0_00_1; // jal
        7'b0110111: controls = 14'b1_100_0_1_0_0_00_0_11_0; // LUI
        7'b0010111: controls = 14'b1_100_1_1_0_0_00_0_00_0; // auipc

        default:    controls = 14'bx_xxx_x_x_xx_x_xx_x; // ???
    endcase
end

assign {RegWrite, ImmSrc, ASrc, ALUSrc, MemWrite, MemRead, ResultSrc, Branch, ALUOp, Jump} = controls;

endmodule



// controller.v - controller for RISC-V CPU

module controller (
    input [6:0]  op,
    input [2:0]  funct3,
    input        funct7b5,
    output       [1:0] ResultSrc,
    output       MemWrite, MemRead,
    output       Branch , ALUSrc,
    output       ASrc,RegWrite, Jump,
    output [2:0] ImmSrc,
    output [3:0] ALUControl
);

wire [1:0] ALUOp;

main_decoder    md (op, ResultSrc, MemWrite, MemRead, Branch,
                    ALUSrc, ASrc, RegWrite, Jump, ImmSrc, ALUOp);

alu_decoder     ad (op[5], funct3, funct7b5, ALUOp, ALUControl);


endmodule



// datapath.v
module datapath (
    input         clk, reset,
    input [1:0]   ResultSrc,
    input         Branch, Jump, ALUSrc,
    input         ASrc,RegWrite,
    input [2:0]   ImmSrc,
    input [3:0]   ALUControl,
    output [31:0] PC,
    input  [31:0] Instr,
    input  MemRead,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result
);

wire [31:0] PCNext, PCPlus4, PCTarget , PCStored;
wire [31:0] ImmExt, SrcA, SrcB, WriteData, ALUResult,Regdata;

wire [2:0] funct3;
assign funct3 = Instr[14:12];
wire [31:0] modified_load;
wire PCsel;
wire [31:0] BranchPC;

// next PC logic
reset_ff #(32) pcreg(clk, reset, PCNext, PC);
adder          pcadd4(PC, 32'd4, PCPlus4);
adder          pcaddbranch(PC, ImmExt, PCTarget);
mux2 #(32)     pcmux(PCPlus4, PCTarget, PCsel, BranchPC);

// register file logic
reg_file       rf (clk, RegWrite, Instr[19:15], Instr[24:20], Instr[11:7], Result, Regdata, WriteData);
imm_extend     ext (Instr[31:7], ImmSrc, ImmExt);

// ALU logic
mux2 #(32)     srcamux(Regdata, PC, ASrc, SrcA);
mux2 #(32)     srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
alu            alu (SrcA, SrcB, ALUControl, ALUResult, Zero);
load_extend le  (ReadData, funct3, MemRead, modified_load);

mux3 #(32)     resultmux(ALUResult, modified_load, PCStored, ResultSrc, Result);

//branch logic
branch_unit bu (Regdata, WriteData,funct3,Branch, Jump,PCsel);

//Jump Logic       
mux2 #(32)    jumpmux(BranchPC,ALUResult,Jump,PCNext);
mux2 #(32)    jumpplus4mux(PCNext,PCPlus4,Jump,PCStored);

assign Mem_WrData = WriteData;
assign Mem_WrAddr = ALUResult;

endmodule


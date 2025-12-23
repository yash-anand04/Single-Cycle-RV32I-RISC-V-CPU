
// alu.v - ALU module

module alu #(parameter WIDTH = 32) (
    input       [WIDTH-1:0] a, b,       // operands
    input       [3:0] alu_ctrl,         // ALU control
    output reg  [WIDTH-1:0] alu_out,    // ALU output
    output      zero                    // zero flag
);

wire [4:0] shamt = b[4:0]; // shift amount

always @(a, b, alu_ctrl) begin
    case (alu_ctrl)
        4'b0000:begin
                    //$display("a = %b, b= %b" ,a,b );
                    alu_out <= a + b;       // ADD
                end
        4'b0001:  alu_out <= a + ~b + 1;  // SUB
        4'b0010:  alu_out <= a & b;       // AND
        4'b0011:  alu_out <= a | b;       // OR
        4'b0100:  alu_out <= a << shamt;   // SLL / SLLI
        4'b0101:  begin                   // SLT
                     if (a[31] != b[31]) alu_out <= a[31] ? 1 : 0;
                     else alu_out <= a < b ? 1 : 0;
                 end
        4'b0110: alu_out <= $signed(a) >>> shamt;   // SRA / SRAI
        4'b0111: alu_out <= a >> shamt;             // SRL / SRLI
        4'b1000: alu_out <= (a < b) ? 1 : 0;
        4'b1001: alu_out <= (a ^ b);
        4'b1111: alu_out <= b;
        default: alu_out = 0;
    endcase
end

assign zero = (alu_out == 0) ? 1'b1 : 1'b0;

endmodule


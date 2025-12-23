module load_extend (
    input [31:0] raw_mem_data,    // From data_mem ReadData
    input [2:0] funct3,           // From instruction decode
    input MemRead,               // Load enable signal
    output reg [31:0] extended_data
);

always @(*) begin
    if (MemRead) begin
        case (funct3)
            3'b000: extended_data = {{24{raw_mem_data[7]}}, raw_mem_data[7:0]};   // lb
            3'b001: extended_data = {{16{raw_mem_data[15]}}, raw_mem_data[15:0]}; // lh  
            3'b010: extended_data = raw_mem_data;                                 // lw
            3'b100: extended_data = {24'b0, raw_mem_data[7:0]};                 // lbu
            3'b101: extended_data = {16'b0, raw_mem_data[15:0]};                // lhu
            default: extended_data = raw_mem_data;
        endcase
    end else begin
        extended_data = raw_mem_data;
    end
end

endmodule
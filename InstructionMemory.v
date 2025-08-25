module InstructionMemory(
    input  [31:0] Address,
    output [31:0] Instruction
);
    reg [31:0] mem[0:1023];

    initial begin
        $readmemh("instructions.mem", mem);
    end

    assign Instruction = mem[Address[31:2]];

endmodule
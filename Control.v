module Control(
    input  [6:0] Opcode,
    output reg   RegWrite,
    output reg   ALUSrc,
    output reg   MemtoReg,
    output reg   MemRead,
    output reg   MemWrite,
    output reg   Branch,
    output reg [1:0] ALUOp
);

    parameter R_TYPE           = 7'b0110011;
    parameter I_TYPE_IMMEDIATE = 7'b0010011;
    parameter I_TYPE_LOAD      = 7'b0000011;
    parameter S_TYPE_STORE     = 7'b0100011;
    parameter B_TYPE_BRANCH    = 7'b1100011;

    always @(*) begin
        RegWrite = 0;
        ALUSrc   = 0;
        MemtoReg = 0;
        MemRead  = 0;
        MemWrite = 0;
        Branch   = 0;
        ALUOp    = 2'bxx;

        case (Opcode)
            R_TYPE: begin
                RegWrite = 1;
                ALUSrc   = 0;
                MemtoReg = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b10;
            end

            I_TYPE_IMMEDIATE: begin
                RegWrite = 1;
                ALUSrc   = 1;
                MemtoReg = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b10;
            end

            I_TYPE_LOAD: begin
                RegWrite = 1;
                ALUSrc   = 1;
                MemtoReg = 1;
                MemRead  = 1;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b00;
            end

            S_TYPE_STORE: begin
                RegWrite = 0;
                ALUSrc   = 1;
                MemtoReg = 0;
                MemRead  = 0;
                MemWrite = 1;
                Branch   = 0;
                ALUOp    = 2'b00;
            end

            B_TYPE_BRANCH: begin
                RegWrite = 0;
                ALUSrc   = 0;
                MemtoReg = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 1;
                ALUOp    = 2'b01;
            end
        endcase
    end

endmodule
module ALUControl (
    input  [1:0]  ALUOp,
    input  [2:0]  Funct3,
    input         Funct7b5,
    output reg [3:0]  ALUOperation
);
    
    // Sinais de operação da ALU expandidos
    parameter ALU_AND = 4'b0000;
    parameter ALU_OR  = 4'b0001;
    parameter ALU_ADD = 4'b0010;
    parameter ALU_SUB = 4'b0110;
    parameter ALU_SLT = 4'b0111; // Adicionado para Set on Less Than
    parameter ALU_XOR = 4'b1100; // Adicionado para XOR
    parameter ALU_SLL = 4'b1000; // Adicionado para Shift Left Logical
    parameter ALU_SRL = 4'b1001; // Adicionado para Shift Right Logical


    always @(*) begin
        case (ALUOp)
            2'b00: // LD ou SD
                ALUOperation = ALU_ADD;
            2'b01: // BEQ
                ALUOperation = ALU_SUB;
            2'b10: // R-type ou I-type (imediato)
                case (Funct3)
                    3'b000: ALUOperation = Funct7b5 ? ALU_SUB : ALU_ADD; // ADD, SUB (R-type) ou ADDI
                    3'b001: ALUOperation = ALU_SLL; // SLL (R-type) ou SLLI
                    3'b010: ALUOperation = ALU_SLT; // SLT (R-type) ou SLTI
                    3'b100: ALUOperation = ALU_XOR; // XOR (R-type) ou XORI
                    3'b101: ALUOperation = ALU_SRL; // SRL (R-type) ou SRLI
                    3'b110: ALUOperation = ALU_OR;  // OR (R-type) ou ORI
                    3'b111: ALUOperation = ALU_AND; // AND (R-type) ou ANDI
                    default: ALUOperation = 4'bxxxx;
                endcase
            default:
                ALUOperation = 4'bxxxx;
        endcase
    end
endmodule
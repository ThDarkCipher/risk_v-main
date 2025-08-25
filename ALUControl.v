module ALUControl (
    input  [1:0]  ALUOp,
    input  [2:0]  Funct3,
    input         Funct7b5,
    output reg [3:0]  ALUOperation
);
    
    
    parameter ALU_AND = 4'b0000;
    parameter ALU_OR  = 4'b0001;
    parameter ALU_ADD = 4'b0010;
    parameter ALU_SUB = 4'b0110;
    parameter ALU_SLT = 4'b0111; 
    parameter ALU_XOR = 4'b1100; 
    parameter ALU_SLL = 4'b1000; 
    parameter ALU_SRL = 4'b1001; 


    always @(*) begin
        case (ALUOp)
            2'b00:
                ALUOperation = ALU_ADD;
            2'b01:
                ALUOperation = ALU_SUB;
            2'b10:
                case (Funct3)
                    3'b000: ALUOperation = Funct7b5 ? ALU_SUB : ALU_ADD;
                    3'b001: ALUOperation = ALU_SLL;
                    3'b010: ALUOperation = ALU_SLT;
                    3'b100: ALUOperation = ALU_XOR;
                    3'b101: ALUOperation = ALU_SRL;
                    3'b110: ALUOperation = ALU_OR;
                    3'b111: ALUOperation = ALU_AND;
                    default: ALUOperation = 4'bxxxx;
                endcase
            default:
                ALUOperation = 4'bxxxx;
        endcase
    end
endmodule
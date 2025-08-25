// Módulo Gerador de Imediatos (Imm Gen)
// Extrai e estende o sinal do imediato de acordo com o tipo de instrução (I, S, B)
module ImmGen(
    input  [31:0] instruction, // Instrução completa
    output reg [31:0] immediate    // Imediato de 32 bits com sinal estendido
);

    // Imediatos são gerados com base no opcode
    // I-type (loads, addi, etc.), S-type (stores), B-type (branches)
    // O opcode está em instruction[6:0]
    
    // O 'case' seleciona o formato correto de imediato
    always @(*) begin
        case (instruction[6:0])
            // I-type (LD - Load) op: 0000011 | (ADDI, etc) op: 0010011
            7'b0000011, 7'b0010011: 
                // Estende o sinal do bit mais significativo do imediato (instruction[31])
                immediate = {{20{instruction[31]}}, instruction[31:20]};
                
            // S-type (SD - Store) op: 0100011
            7'b0100011: 
                // Recombina os bits do imediato do formato S e estende o sinal
                immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

            // B-type (BEQ - Branch) op: 1100011
            7'b1100011: 
                // Recombina os bits do imediato do formato B, adiciona um 0 no final e estende o sinal
                immediate = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};

            default: 
                immediate = 32'hxxxxxxxx; // Indefinido para outros tipos
        endcase
    end

endmodule
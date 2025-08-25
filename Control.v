// Módulo da Unidade de Controle Principal (Versão Completa)
module Control(
    input  [6:0] Opcode,      // Bits de opcode da instrução [6:0]
    output reg   RegWrite,    // Habilita escrita no banco de registradores
    output reg   ALUSrc,      // Seleciona a segunda entrada da ALU (registrador ou imediato)
    output reg   MemtoReg,    // Seleciona o dado a ser escrito no registrador (ALU ou memória)
    output reg   MemRead,     // Habilita leitura da memória de dados
    output reg   MemWrite,    // Habilita escrita na memória de dados
    output reg   Branch,      // Habilita o desvio (branch)
    output reg [1:0] ALUOp      // Sinal para o Controle da ALU
);

    // --- Definição dos Opcodes do RISC-V ---
    // (Conforme a Tabela de Instruções do trabalho)
    parameter R_TYPE           = 7'b0110011; // add, sub, and, or, xor, sll, srl
    parameter I_TYPE_IMMEDIATE = 7'b0010011; // addi, andi, ori, xori
    parameter I_TYPE_LOAD      = 7'b0000011; // lb, lh, lw
    parameter S_TYPE_STORE     = 7'b0100011; // sb, sh, sw
    parameter B_TYPE_BRANCH    = 7'b1100011; // beq, bne

    // Decodifica o opcode para gerar os sinais de controle corretos para cada instrução
    always @(*) begin
        // Inicializa com valores padrão para evitar latches indesejados
        RegWrite = 0;
        ALUSrc   = 0;
        MemtoReg = 0;
        MemRead  = 0;
        MemWrite = 0;
        Branch   = 0;
        ALUOp    = 2'bxx; // 'x' representa "don't care"

        case (Opcode)
            // Instruções R-Type: add, sub, and, or, xor, sll, srl
            R_TYPE: begin
                RegWrite = 1;       // Escreve o resultado no registrador de destino (rd)
                ALUSrc   = 0;       // A segunda entrada da ALU vem do registrador (rs2)
                MemtoReg = 0;       // O valor a ser escrito vem do resultado da ALU
                MemRead  = 0;       // Não lê da memória de dados
                MemWrite = 0;       // Não escreve na memória de dados
                Branch   = 0;       // Não é um desvio
                ALUOp    = 2'b10;   // A ALU deve usar funct3/funct7 para decidir a operação
            end

            // Instruções I-Type (Lógicas/Aritméticas): addi, andi, ori, xori
            I_TYPE_IMMEDIATE: begin
                RegWrite = 1;       // Escreve o resultado no registrador de destino (rd)
                ALUSrc   = 1;       // A segunda entrada da ALU vem do imediato
                MemtoReg = 0;       // O valor a ser escrito vem do resultado da ALU
                MemRead  = 0;       // Não lê da memória de dados
                MemWrite = 0;       // Não escreve na memória de dados
                Branch   = 0;       // Não é um desvio
                ALUOp    = 2'b10;   // A ALU deve usar funct3 para decidir (similar ao R-Type)
            end

            // Instruções I-Type (Load): lw, lh, lb
            I_TYPE_LOAD: begin
                RegWrite = 1;       // Escreve o dado lido no registrador de destino (rd)
                ALUSrc   = 1;       // A segunda entrada da ALU vem do imediato (para calcular endereço)
                MemtoReg = 1;       // O valor a ser escrito vem da memória de dados
                MemRead  = 1;       // Habilita a leitura da memória de dados
                MemWrite = 0;       // Não escreve na memória de dados
                Branch   = 0;       // Não é um desvio
                ALUOp    = 2'b00;   // A ALU deve sempre somar para calcular o endereço (reg + offset)
            end

            // Instruções S-Type (Store): sw, sh, sb
            S_TYPE_STORE: begin
                RegWrite = 0;       // Não escreve no banco de registradores
                ALUSrc   = 1;       // A segunda entrada da ALU vem do imediato (para calcular endereço)
                MemtoReg = 0;       // "Don't care"
                MemRead  = 0;       // Não lê da memória de dados
                MemWrite = 1;       // Habilita a escrita na memória de dados
                Branch   = 0;       // Não é um desvio
                ALUOp    = 2'b00;   // A ALU deve sempre somar para calcular o endereço (reg + offset)
            end

            // Instruções B-Type (Branch): beq, bne
            B_TYPE_BRANCH: begin
                RegWrite = 0;       // Não escreve no banco de registradores
                ALUSrc   = 0;       // A segunda entrada da ALU vem do registrador (para comparação)
                MemtoReg = 0;       // "Don't care"
                MemRead  = 0;       // Não lê da memória de dados
                MemWrite = 0;       // Não escreve na memória de dados
                Branch   = 1;       // Sinaliza que esta instrução é um desvio
                ALUOp    = 2'b01;   // A ALU deve subtrair para comparar (se resultado for 0, são iguais)
            end
        endcase
    end

endmodule
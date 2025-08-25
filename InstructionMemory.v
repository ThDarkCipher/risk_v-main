// Módulo da Memória de Instrução (ROM)
module InstructionMemory(
    input  [31:0] Address,      // Endereço da instrução (valor do PC)
    output [31:0] Instruction   // Instrução lida da memória
);
    
    // Memória para armazenar até 1024 instruções (4KB)
    reg [31:0] mem[0:1023];

    // No início da simulação, carrega as instruções de um arquivo externo
    // O arquivo 'instructions.mem' deve conter o código de máquina em hexadecimal.
    initial begin
        $readmemh("instructions.mem", mem);
    end

    // A leitura é combinacional. Como as instruções são de 32 bits (4 bytes),
    // dividimos o endereço por 4 para obter o índice do array.
    assign Instruction = mem[Address[31:2]];

endmodule
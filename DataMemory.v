// Módulo da Memória de Dados (RAM)
module DataMemory(
    input         clk,          // Clock
    input         MemRead,      // Sinal que habilita a leitura
    input         MemWrite,     // Sinal que habilita a escrita
    input  [31:0] Address,      // Endereço da memória para ler/escrever
    input  [31:0] WriteData,    // Dado a ser escrito na memória
    output [31:0] ReadData      // Dado lido da memória
);

    // Memória para armazenar até 1024 palavras de 32 bits (4KB)
    reg [31:0] mem[0:1023];

    // Comportamento de escrita (síncrono)
    always @(posedge clk) begin
        if (MemWrite) begin
            // O endereço é dividido por 4 para indexar a memória de palavras
            mem[Address[31:2]] <= WriteData;
        end
    end

    // Comportamento de leitura (combinacional)
    assign ReadData = MemRead ? mem[Address[31:2]] : 32'hxxxxxxxx;

    // Opcional: inicializa a memória com zero
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = 32'b0;
        end
    end
    
endmodule
// Módulo do Banco de Registradores
module RegisterFile(
    input         clk,         // Clock
    input         RegWrite,    // Sinal que habilita a escrita no registrador
    input  [4:0]  ReadAddr1,   // Endereço do registrador de leitura 1 (rs1)
    input  [4:0]  ReadAddr2,   // Endereço do registrador de leitura 2 (rs2)
    input  [4:0]  WriteAddr,   // Endereço do registrador de escrita (rd)
    input  [31:0] WriteData,   // Dado a ser escrito
    output [31:0] ReadData1,   // Dado lido do registrador 1
    output [31:0] ReadData2    // Dado lido do registrador 2
);

    // Declaração dos 32 registradores de 32 bits
    reg [31:0] registers[0:31];
    
    // Comportamento de escrita (síncrono com o clock)
    // A escrita acontece na borda de subida do clock
    always @(posedge clk) begin
        // Se RegWrite estiver ativo e o endereço de escrita não for x0
        if (RegWrite && (WriteAddr != 5'b0)) begin
            registers[WriteAddr] <= WriteData;
        end
    end

    // Comportamento de leitura (assíncrono/combinacional)
    // O registrador x0 (endereço 0) sempre retorna zero
    assign ReadData1 = (ReadAddr1 == 5'b0) ? 32'b0 : registers[ReadAddr1];
    assign ReadData2 = (ReadAddr2 == 5'b0) ? 32'b0 : registers[ReadAddr2];

    // Opcional: inicializa todos os registradores com zero no início da simulação
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0;
        end
    end

endmodule
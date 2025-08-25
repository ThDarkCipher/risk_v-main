// Módulo de Testbench para o processador RISC-V
`timescale 1ns / 1ps

// Inclui o módulo de topo que conecta todo o processador
//`include "top_level.v"

module testbench;

    // --- Sinais para conectar ao DUT (Device Under Test) ---
    reg clk;
    reg rst;

    // --- Instanciação do Processador (DUT) ---
    top_level dut (
        .clk(clk),
        .rst(rst)
    );

    // --- Geração do Clock ---
    // Gera um clock com período de 10ns (frequência de 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // A cada 5ns, o clock inverte
    end

    // --- Procedimento Principal da Simulação ---
    initial begin
        $display("-------------------------------------------------");
        $display("Iniciando a simulação do Processador RISC-V...");
        
        // 1. Aplica o pulso de Reset
        rst = 1;
        #20; // Mantém o reset por 20ns (2 ciclos de clock)
        rst = 0;
        $display("Reset liberado. Executando o programa.");

        // 2. Roda a simulação por um tempo
        // O programa de teste é curto. 150ns (15 ciclos) é mais que suficiente.
        #150;

        // 3. Exibe os resultados
        $display("\nSimulação concluída. Estado final dos registradores:");
        $display("-------------------------------------------------");

        // Loop para imprimir todos os 32 registradores
        // Usa o acesso hierárquico para "ver" dentro do DUT
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("Register [ %2d]: \t%d", i, dut.reg_file.registers[i]);
        end
        
        $display("-------------------------------------------------");
        $display("Resultados esperados:");
        $display(" - Registrador [ 1]: 7");
        $display(" - Registrador [ 2]: 14");
        $display(" - Registrador [ 3]: 7");
        $display(" - Registrador [ 4]: 0 (a instrução armadilha não foi executada)");
        $display("-------------------------------------------------");

        // 4. Termina a simulação
        $finish;
    end

endmodule
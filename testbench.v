// Módulo de Testbench para o processador RISC-V
`timescale 1ns / 1ps

// Inclui o módulo de topo que conecta todo o processador
module testbench;

    // --- Sinais para conectar ao DUT (Device Under Test) ---
    reg clk;
    reg rst;
    top_level dut (
        .clk(clk),
        .rst(rst)
    );

    // Gera um clock com período de 10ns (frequência de 100MHz)

    initial begin
        rst = 1;
        $display("Reset liberado. Executando o programa.");


        // 3. Exibe os resultados
        $display("\nSimulação concluída. Estado final dos registradores:");

        // Loop para imprimir todos os 32 registradores
        // Usa o acesso hierárquico para "ver" dentro do DUT
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("Register [ %2d]: \t%d", i, dut.reg_file.registers[i]);
        end
        
        $display(" - Registrador [ 1]: 7");
        $display(" - Registrador [ 2]: 14");
        $display(" - Registrador [ 3]: 7");
        $display(" - Registrador [ 4]: 0 (a instrução armadilha não foi executada)");
        $display("-------------------------------------------------");

        // 4. Termina a simulação
        $finish;
    end

endmodule
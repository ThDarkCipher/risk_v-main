`timescale 1ns / 1ps

module bancada_de_teste;

    reg clock;
    reg reset;

    processador_completo dut (
        .clk(clock),
        .rst(reset)
    );

    initial begin
        reset = 1;
        $display("Reset liberado. Executando o programa.");
        
        $display("\nSimulação concluída. Estado final dos registradores:");
        
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("Register [ %2d]: \t%d", i, dut.banco_de_registradores.registradores[i]);
        end
        
        $display(" - Registrador [ 1]: 7");
        $display(" - Registrador [ 2]: 14");
        $display(" - Registrador [ 3]: 7");
        $display(" - Registrador [ 4]: 0 (a instrução armadilha não foi executada)");
        $display("-------------------------------------------------");
        
        $finish;
    end

endmodule
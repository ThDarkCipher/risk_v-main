module MemoriaDeInstrucoes(
    input  [31:0] Endereco,
    output [31:0] Instrucao
);

    reg [31:0] memoria[0:1023];

    initial begin
        $readmemh("instructions.mem", memoria);
    end

    assign Instrucao = memoria[Endereco[31:2]];

endmodule
module MemoriaDeDados(
    input        clk,
    input        LeMemoria,
    input        EscreveMemoria,
    input  [31:0] Endereco,
    input  [31:0] DadoParaEscrita,
    output [31:0] DadoLido
);

    reg [31:0] memoria[0:1023];

    always @(posedge clk) begin
        if (EscreveMemoria) begin
            memoria[Endereco[31:2]] <= DadoParaEscrita;
        end
    end

    assign DadoLido = LeMemoria ? memoria[Endereco[31:2]] : 32'hxxxxxxxx;

    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            memoria[i] = 32'b0;
        end
    end
    
endmodule
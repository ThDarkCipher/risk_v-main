module BancoDeRegistradores(
    input        clk,
    input        EscreveRegistrador,
    input  [4:0] EnderecoLeitura1,
    input  [4:0] EnderecoLeitura2,
    input  [4:0] EnderecoEscrita,
    input  [31:0] DadoParaEscrita,
    output [31:0] DadoLido1,
    output [31:0] DadoLido2
);

    reg [31:0] registradores[0:31];

    always @(posedge clk) begin
        if (EscreveRegistrador && (EnderecoEscrita != 5'b0)) begin
            registradores[EnderecoEscrita] <= DadoParaEscrita;
        end
    end

    assign DadoLido1 = (EnderecoLeitura1 == 5'b0) ? 32'b0 : registradores[EnderecoLeitura1];
    assign DadoLido2 = (EnderecoLeitura2 == 5'b0) ? 32'b0 : registradores[EnderecoLeitura2];

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registradores[i] = 32'b0;
        end
    end

endmodule
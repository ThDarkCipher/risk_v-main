module Controle(
    input  [6:0] CodigoDaOperacao,
    output reg     EscreveRegistrador,
    output reg     FonteULA,
    output reg     MemParaReg,
    output reg     LeMemoria,
    output reg     EscreveMemoria,
    output reg     Desvio,
    output reg [1:0] OperacaoULA
);

    parameter TIPO_R             = 7'b0110011;
    parameter TIPO_I_IMEDIATO    = 7'b0010011;
    parameter TIPO_I_CARGA       = 7'b0000011;
    parameter TIPO_S_ARMAZENAMENTO = 7'b0100011;
    parameter TIPO_B_DESVIO      = 7'b1100011;

    always @(*) begin
        EscreveRegistrador = 0;
        FonteULA           = 0;
        MemParaReg         = 0;
        LeMemoria          = 0;
        EscreveMemoria     = 0;
        Desvio             = 0;
        OperacaoULA        = 2'bxx;

        case (CodigoDaOperacao)
            TIPO_R: begin
                EscreveRegistrador = 1;
                FonteULA           = 0;
                OperacaoULA        = 2'b10;
            end

            TIPO_I_IMEDIATO: begin
                EscreveRegistrador = 1;
                FonteULA           = 1;
                OperacaoULA        = 2'b10;
            end

            TIPO_I_CARGA: begin
                EscreveRegistrador = 1;
                FonteULA           = 1;
                MemParaReg         = 1;
                LeMemoria          = 1;
                OperacaoULA        = 2'b00;
            end

            TIPO_S_ARMAZENAMENTO: begin
                FonteULA           = 1;
                EscreveMemoria     = 1;
                OperacaoULA        = 2'b00;
            end

            TIPO_B_DESVIO: begin
                FonteULA           = 0;
                Desvio             = 1;
                OperacaoULA        = 2'b01;
            end
        endcase
    end

endmodule
module processador_completo(
    input clk,
    input rst
);

    wire EscreveRegistrador, FonteULA, MemParaReg, LeMemoria, EscreveMemoria, Desvio;
    wire [1:0] OperacaoULA_Ctrl;
    wire [3:0] OperacaoULA_Final;
    wire Zero;
    wire FontePC;

    wire [31:0] PC_atual, PC_proximo, PC_mais_4, EnderecoDesvio;
    wire [31:0] instrucao;
    wire [31:0] DadoLido1, DadoLido2;
    wire [31:0] imediato;
    wire [31:0] Entrada_B_ULA;
    wire [31:0] resultado_ULA;
    wire [31:0] dado_lido_memoria;
    wire [31:0] dado_para_escrita_reg;
    
    reg [31:0] registrador_PC;

    always @(posedge clk or posedge rst) begin
        if (rst)
            registrador_PC <= 32'h00000000;
        else
            registrador_PC <= PC_proximo;
    end
    
    assign PC_atual = registrador_PC;
    assign PC_mais_4 = PC_atual + 32'd4;

    MemoriaDeInstrucoes mem_inst (
        .Endereco(PC_atual),
        .Instrucao(instrucao)
    );

    Controle controle_principal (
        .CodigoDaOperacao(instrucao[6:0]),
        .EscreveRegistrador(EscreveRegistrador),
        .FonteULA(FonteULA),
        .MemParaReg(MemParaReg),
        .LeMemoria(LeMemoria),
        .EscreveMemoria(EscreveMemoria),
        .Desvio(Desvio),
        .OperacaoULA(OperacaoULA_Ctrl)
    );

    BancoDeRegistradores banco_de_registradores (
        .clk(clk),
        .EscreveRegistrador(EscreveRegistrador),
        .EnderecoLeitura1(instrucao[19:15]),
        .EnderecoLeitura2(instrucao[24:20]),
        .EnderecoEscrita(instrucao[11:7]),
        .DadoParaEscrita(dado_para_escrita_reg),
        .DadoLido1(DadoLido1),
        .DadoLido2(DadoLido2)
    );

    GeradorDeImediato gerador_imm (
        .instrucao(instrucao),
        .imediato(imediato)
    );

    ControleULA controle_ula (
        .ALUOp(OperacaoULA_Ctrl),
        .Funct3(instrucao[14:12]),
        .Funct7b5(instrucao[30]),
        .ALUOperation(OperacaoULA_Final)
    );

    assign Entrada_B_ULA = FonteULA ? imediato : DadoLido2;

    ULA instancia_ula (
        .A(DadoLido1),
        .B(Entrada_B_ULA),
        .ALUControl(OperacaoULA_Final),
        .Result(resultado_ULA),
        .Zero(Zero)
    );

    MemoriaDeDados mem_dados (
        .clk(clk),
        .LeMemoria(LeMemoria),
        .EscreveMemoria(EscreveMemoria),
        .Endereco(resultado_ULA),
        .DadoParaEscrita(DadoLido2),
        .ReadData(dado_lido_memoria)
    );

    assign dado_para_escrita_reg = MemParaReg ? dado_lido_memoria : resultado_ULA;
    assign EnderecoDesvio = PC_atual + imediato;
    assign FontePC = Desvio & Zero;
    assign PC_proximo = FontePC ? EnderecoDesvio : PC_mais_4;

endmodule
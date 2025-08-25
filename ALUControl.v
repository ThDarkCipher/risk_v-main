module ControleULA (
    input  [1:0]  OperacaoULA,
    input  [2:0]  Funct3,
    input         Funct7b5,
    output reg [3:0]  OperacaoSaida
);

    parameter E_AND      = 4'b0000;
    parameter E_OR       = 4'b0001;
    parameter E_SOMA     = 4'b0010;
    parameter E_SUB      = 4'b0110;
    parameter E_MENOR    = 4'b0111;
    parameter E_XOR      = 4'b1100;
    parameter E_DESL_ESQ = 4'b1000;
    parameter E_DESL_DIR = 4'b1001;

    always @(*) begin
        case (OperacaoULA)
            2'b00:
                OperacaoSaida = E_SOMA;
            2'b01:
                OperacaoSaida = E_SUB;
            2'b10:
                case (Funct3)
                    3'b000: OperacaoSaida = Funct7b5 ? E_SUB : E_SOMA;
                    3'b001: OperacaoSaida = E_DESL_ESQ;
                    3'b010: OperacaoSaida = E_MENOR;
                    3'b100: OperacaoSaida = E_XOR;
                    3'b101: OperacaoSaida = E_DESL_DIR;
                    3'b110: OperacaoSaida = E_OR;
                    3'b111: OperacaoSaida = E_AND;
                    default: OperacaoSaida = 4'bxxxx;
                endcase
            default:
                OperacaoSaida = 4'bxxxx;
        endcase
    end
endmodule

module ULA(
    input  [31:0] EntradaA,
    input  [31:0] EntradaB,
    input  [3:0]  ControleULA,
    output [31:0] Resultado,
    output        Zero
);

    reg [31:0] resultado_ula;

    always @(*) begin
        case (ControleULA)
            4'b0000: resultado_ula = EntradaA & EntradaB;
            4'b0001: resultado_ula = EntradaA | EntradaB;
            4'b0010: resultado_ula = EntradaA + EntradaB;
            4'b0110: resultado_ula = EntradaA - EntradaB;
            4'b0111: resultado_ula = ($signed(EntradaA) < $signed(EntradaB)) ? 32'd1 : 32'd0;
            4'b1100: resultado_ula = EntradaA ^ EntradaB;
            4'b1000: resultado_ula = EntradaA << EntradaB[4:0];
            4'b1001: resultado_ula = EntradaA >> EntradaB[4:0];
            default: resultado_ula = 32'hxxxxxxxx;
        endcase
    end

    assign Resultado = resultado_ula;
    assign Zero = (resultado_ula == 32'b0);

endmodule

module ALU(
    input  [31:0] A,         
    input  [31:0] B,         
    input  [3:0]  ALUControl, 
    output [31:0] Result,     
    output        Zero        
);

    reg [31:0] alu_result;

    always @(*) begin
        case (ALUControl)
            4'b0000: alu_result = A & B;        
            4'b0001: alu_result = A | B;         
            4'b0010: alu_result = A + B;         
            4'b0110: alu_result = A - B;         
            4'b0111: alu_result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; 
            4'b1100: alu_result = A ^ B;         
            4'b1000: alu_result = A << B[4:0];   
            4'b1001: alu_result = A >> B[4:0];   
            default: alu_result = 32'hxxxxxxxx; 
        endcase
    end

    assign Result = alu_result;
    
    assign Zero = (alu_result == 32'b0);

endmodule
/*`include "ALU.v"
`include "RegisterFile.v"      
`include "InstructionMemory.v" 
`include "DataMemory.v"        
`include "Control.v"           
`include "ALUControl.v"        
`include "ImmGen.v"            

module top_level(
    input clk,    
    input rst     
);
    
    
    
    wire RegWrite, ALUSrc, MemtoReg, MemRead, MemWrite, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUOperation;
    wire Zero;
    wire PCSrc;

    
    wire [31:0] PC_current, PC_next, PC_plus_4, Branch_addr;
    wire [31:0] instruction;
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] immediate;
    wire [31:0] ALU_input_B;
    wire [31:0] ALU_result;
    wire [31:0] Memory_read_data;
    wire [31:0] WriteData_for_Reg;
    
    

    
    reg [31:0] PC_reg;
    always @(posedge clk or posedge rst) begin
        if (rst)
            PC_reg <= 32'h00000000; 
        else
            PC_reg <= PC_next;
    end
    assign PC_current = PC_reg;
    
    
    assign PC_plus_4 = PC_current + 32'd4;
    
    
    InstructionMemory inst_mem (
        .Address(PC_current),
        .Instruction(instruction)
    );
    
    
    Control main_control (
        .Opcode(instruction[6:0]),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );
    
    
    RegisterFile reg_file (
        .clk(clk),
        .RegWrite(RegWrite),
        .ReadAddr1(instruction[19:15]),
        .ReadAddr2(instruction[24:20]),
        .WriteAddr(instruction[11:7]),
        .WriteData(WriteData_for_Reg),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );
    
    
    ImmGen imm_gen (
        .instruction(instruction),
        .immediate(immediate)
    );
    
    
    ALUControl alu_control (
        .ALUOp(ALUOp),
        .Funct3(instruction[14:12]),
        .Funct7b5(instruction[30]),
        .ALUOperation(ALUOperation)
    );
    
    
    assign ALU_input_B = ALUSrc ? immediate : ReadData2;
    
    
    ALU alu_inst (
        .A(ReadData1),
        .B(ALU_input_B),
        .ALUControl(ALUOperation),
        .Result(ALU_result),
        .Zero(Zero)
    );
    
    
    DataMemory data_mem (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Address(ALU_result),
        .WriteData(ReadData2),
        .ReadData(Memory_read_data)
    );
    
    
    assign WriteData_for_Reg = MemtoReg ? Memory_read_data : ALU_result;

    
    
    assign Branch_addr = PC_current + immediate; 
    
   
    assign PCSrc = Branch & Zero; 
    
    assign PC_next = PCSrc ? Branch_addr : PC_plus_4;

endmodule
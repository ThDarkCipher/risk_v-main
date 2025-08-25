module DataMemory(
    input         clk,
    input         MemRead,
    input         MemWrite,
    input  [31:0] Address,
    input  [31:0] WriteData,
    output [31:0] ReadData
);

    reg [31:0] mem[0:1023];

    always @(posedge clk) begin
        if (MemWrite) begin
            mem[Address[31:2]] <= WriteData;
        end
    end

    assign ReadData = MemRead ? mem[Address[31:2]] : 32'hxxxxxxxx;

    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = 32'b0;
        end
    end
    
endmodule
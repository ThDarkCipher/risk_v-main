module RegisterFile(
    input         clk,
    input         RegWrite,
    input  [4:0]  ReadAddr1,
    input  [4:0]  ReadAddr2,
    input  [4:0]  WriteAddr,
    input  [31:0] WriteData,
    output [31:0] ReadData1,
    output [31:0] ReadData2
);

    reg [31:0] registers[0:31];
    always @(posedge clk) begin
        if (RegWrite && (WriteAddr != 5'b0)) begin
            registers[WriteAddr] <= WriteData;
        end
    end

    assign ReadData1 = (ReadAddr1 == 5'b0) ? 32'b0 : registers[ReadAddr1];
    assign ReadData2 = (ReadAddr2 == 5'b0) ? 32'b0 : registers[ReadAddr2];

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0;
        end
    end

endmodule
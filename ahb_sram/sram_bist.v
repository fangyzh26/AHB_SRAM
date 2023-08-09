//signal port sram: storage space = 8K byte
module sram_bist#(
    parameter MEM_DEPTH     = 8192,//8K = 2^13
    parameter DATA_WIDTH    = 8,
    parameter BITW          = $clog2(MEM_DEPTH)//log2(8192)=13
    )
    (
    input                           clk,
    input                           csn,
    input                           we,
    input [BITW-1:0]                addr,//need 13 address lines
    input [DATA_WIDTH-1:0]          din,
    output reg [DATA_WIDTH-1:0]     dout
    );
    
    reg [DATA_WIDTH-1:0] mem [MEM_DEPTH:0];//depth=2^13, data width=8bit, 1bist's space = 8Kbyte

    always @(posedge clk) begin
        if(!csn) begin
            if(we)
                mem[addr] <= din;
            else 
                dout <= mem[addr];
        end
        else begin
            dout <= 8'bx;
        end
    end

endmodule
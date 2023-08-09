// sram core has 2 banks,each bank has 4 bists;
// bank0 = bist3 + bist2 + bist1 + bist0 = 32Kbits
// bank1 = bist7 + bist6 + bist5 + bist4 = 32Kbits
// sram_core = 32Kbits + 32Kbits = 64Kbits
module sram_core(
    input           clk,
    input [3:0]     bank0_csn,
    input [3:0]     bank1_csn,
    input           sram_we,
    input [12:0]    sram_addr,//need 13 address lines
    input [31:0]    sram_wdata,
    
    output [7:0]    sram_q0,//bank0
    output [7:0]    sram_q1,
    output [7:0]    sram_q2,
    output [7:0]    sram_q3,
    output [7:0]    sram_q4,//bank1
    output [7:0]    sram_q5,
    output [7:0]    sram_q6,
    output [7:0]    sram_q7
    );

    //------------------------ bank 0 ----------------------------------------
    sram_bist bist_0 (
        .clk  (clk),
        .csn  (bank0_csn[0]),
        .we   (sram_we),
        .addr (sram_addr[9:0]),
        .din  (sram_wdata[7:0]),
        .dout (sram_q0)
    );
    sram_bist bist_1 (
        .clk  (clk),
        .csn  (bank0_csn[1]),
        .we   (sram_we),
        .addr (sram_addr[9:0]),
        .din  (sram_wdata[15:8]),
        .dout (sram_q1)
    );
    sram_bist bist_2 (
        .clk  (clk),
        .csn  (bank0_csn[2]),
        .we   (sram_we),
        .addr (sram_addr[9:0]),
        .din  (sram_wdata[23:16]),
        .dout (sram_q2)
    );
    sram_bist bist_3 (
        .clk  (clk),
        .csn  (bank0_csn[3]),
        .we   (sram_we),
        .addr (sram_addr[9:0]),
        .din  (sram_wdata[31:24]),
        .dout (sram_q3)
    );

    //------------------------ bank 1 ----------------------------------------
    sram_bist bist_4 (
        .clk  (clk),
        .csn  (bank1_csn[0]),
        .we   (sram_we),
        .addr (sram_addr[9:0]),
        .din  (sram_wdata[7:0]),
        .dout (sram_q4)
    );
    sram_bist bist_5 (
        .clk  (clk),
        .csn  (bank1_csn[1]),
        .we   (sram_we),
        .addr (sram_addr[9:0]),
        .din  (sram_wdata[15:8]),
        .dout (sram_q5)
    );
    sram_bist bist_6 (
        .clk  (clk),
        .csn  (bank1_csn[2]),
        .we   (sram_we),
        .addr (sram_addr[9:0]),
        .din  (sram_wdata[23:16]),
        .dout (sram_q6)
    );
    sram_bist bist_7 (
        .clk  (clk),
        .csn  (bank1_csn[3]),
        .we   (sram_we),
        .addr (sram_addr[9:0]),
        .din  (sram_wdata[31:24]),
        .dout (sram_q7)
    );


    
endmodule
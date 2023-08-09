module ahb_sram_top(
    input           hclk,
    input           hrstn,
    input           hsel,
    input [1:0]     htrans,
    input [2:0]     hsize,
    input [2:0]     hburst,
    input           hwrite,
    input [31:0]    haddr,
    input [31:0]    hwdata,
    input           hready_in,

    output          hready_out,
    output          hresp,
    output [31:0]   hrdata 
    );

    wire [7:0]     sram_q0;//bank0
    wire [7:0]     sram_q1;
    wire [7:0]     sram_q2;
    wire [7:0]     sram_q3;
    wire [7:0]     sram_q4;//bank1
    wire [7:0]     sram_q5;
    wire [7:0]     sram_q6;
    wire [7:0]     sram_q7;   

    wire [3:0]    bank0_csn;
    wire [3:0]    bank1_csn;
    wire          sram_we;
    wire [12:0]   sram_addr;
    wire [31:0]   sram_wdata;
    

	ahb_sram inst_ahb_sram 
    (
        .hclk       (hclk),
        .hrstn      (hrstn),
        .hsel       (hsel),
        .htrans     (htrans),
        .hsize      (hsize),
        .hburst     (hburst),
        .hwrite     (hwrite),
        .haddr      (haddr),
        .hwdata     (hwdata),
        .hready_in  (hready_in),

        .hready_out (hready_out),
        .hresp      (hresp),
        .hrdata     (hrdata),

        .sram_q0    (sram_q0),
        .sram_q1    (sram_q1),
        .sram_q2    (sram_q2),
        .sram_q3    (sram_q3),
        .sram_q4    (sram_q4),
        .sram_q5    (sram_q5),
        .sram_q6    (sram_q6),
        .sram_q7    (sram_q7),

        .bank0_csn  (bank0_csn),
        .bank1_csn  (bank1_csn),
        .sram_we    (sram_we),
        .sram_addr  (sram_addr),
        .sram_wdata (sram_wdata)
    );

    sram_core inst_sram_core
    (
        .clk        (hclk),
        .bank0_csn  (bank0_csn),
        .bank1_csn  (bank1_csn),
        .sram_we    (sram_we),
        .sram_addr  (sram_addr),
        .sram_wdata (sram_wdata),

        .sram_q0    (sram_q0),
        .sram_q1    (sram_q1),
        .sram_q2    (sram_q2),
        .sram_q3    (sram_q3),
        .sram_q4    (sram_q4),
        .sram_q5    (sram_q5),
        .sram_q6    (sram_q6),
        .sram_q7    (sram_q7)
    );

endmodule
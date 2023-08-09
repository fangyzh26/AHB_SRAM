`timescale 1ns/10ps
module ahb_ahb_sram_tb;

parameter T = 20;

reg             hclk;
reg             hrstn;
reg             hsel;
reg [1:0]       htrans;
reg [2:0]       hburst;
reg [2:0]       hsize;
reg             hwrite;
reg [31:0]      haddr;
reg [31:0]      hwdata;
reg             hready_in;

wire            hready_out;
wire [1:0]      hresp;
wire [31:0]     hrdata;


initial begin
    hclk = 1'b0;
    repeat(60) #10 hclk = ~hclk;
end

initial begin
    hrstn     = 1'b0; 
    hsel      = 1'b0;
    hready_in = 1'b0;
    htrans    = 2'b0;
    #31 
    hrstn       = 1'b1; 
    hsel        = 1'b1; 
    hburst      = 3'b000; //singal burst
    hready_in   = 1'b1;
    htrans      = 2'b10; //NONSEQ
end

initial begin
    hwrite = 0;
    #51 hwrite = 1; hsize = 3'b010; haddr = 32'hffff_8000; 
    #20 hwrite = 1; hsize = 3'b010; haddr = 32'hffff_8004; hwdata = 32'h8000_0001;
    #20 hwrite = 1; hsize = 3'b010; haddr = 32'hffff_8008; hwdata = 32'h8000_0002;
    #20 hwrite = 1; hsize = 3'b010; haddr = 32'hffff_800c; hwdata = 32'h8000_0003;
    #20 hwrite = 1; hsize = 3'b010; haddr = 32'hffff_8010; hwdata = 32'h8000_0004;
    #20 hwrite = 1; hsize = 3'b010; haddr = 32'hffff_8014; hwdata = 32'h8000_0005;
    #20 hwrite = 1; hsize = 3'b010; haddr = 32'hffff_8018; hwdata = 32'h8000_0006;
    #20 hwrite = 1; hsize = 3'b010; haddr = 32'hffff_801c; hwdata = 32'h8000_0007;
    #20 hwrite = 1; hsize = 3'b010; haddr = 32'hffff_8020; hwdata = 32'h8000_0008;
    #20 hwrite = 1; hsize = 3'b010; haddr = 32'hffff_8024; hwdata = 32'h8000_0009;
    #20 hwrite = 1; hsize = 3'b010; haddr = 32'hffff_8028; hwdata = 32'h8000_000a;
    #20 hwrite = 1; hsize = 3'b010; haddr = 32'hffff_802c; hwdata = 32'h8000_000b;

    #20 hwrite = 0; hsize = 3'b000; haddr = 32'hffff_8000;
    #20 hwrite = 0; hsize = 3'b001; haddr = 32'hffff_8004;
    #20 hwrite = 0; hsize = 3'b010; haddr = 32'hffff_8008;
    #20 hwrite = 0; hsize = 3'b000; haddr = 32'hffff_800c;
    #20 hwrite = 0; hsize = 3'b001; haddr = 32'hffff_8010;
    #20 hwrite = 0; hsize = 3'b010; haddr = 32'hffff_8014;
    #20 hwrite = 0; hsize = 3'b000; haddr = 32'hffff_801c;
    #20 hwrite = 0; hsize = 3'b001; haddr = 32'hffff_8020;
    #20 hwrite = 0; hsize = 3'b010; haddr = 32'hffff_8024;
    #20 hwrite = 0; hsize = 3'b000; haddr = 32'hffff_8028;
    #20 hwrite = 0; hsize = 3'b001; haddr = 32'hffff_802c;
end

ahb_sram_top inst_ahb_sram_top
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
    .hrdata     (hrdata)
);

initial begin
    $fsdbDumpfile("ahb_sram_top.fsdb");
    $fsdbDumpvars(0);
    $fsdbDumpMDA();// add to see memory
end


// initial begin
//     hrstn = 1'b0;

//     #20
//     hrstn = 1'b1;
//     hready_in = 1'b0;
//     hsel = 1'b0;
//     htrans = 2'b10;
//     hburst = 3'd0;
//     //32bit write;
//     hsize = 3'b010;
//     hwrite = 1'b1;
//     haddr = 32'h1000_9ffc;
//     hwdata = 32'h1234_5678;

//     //test hsel;
//     #40
//     hsel = 1'b1;
//     //test hready;
//     #40
//     hready_in = 1'b1;
//     #20
//     hready_in = 1'b0;
//     //8bit read;
//     #40
//     hready_in = 1'b1;
//     hsize = 3'b000;
//     hwrite = 1'b0;
//     haddr = 32'h1000_9ffc;
//     //16bit read;
//     #40
//     hready_in = 1'b1;
//     hsize = 3'b001;
//     hwrite = 1'b0;
//     haddr = 32'h1000_9ffc;
//     //32bit read;
//     #40
//     hready_in = 1'b1;
//     hsize = 3'b010;
//     hwrite = 1'b0;
//     haddr = 32'h1000_9ffc;
//     #80
//     $finish;
// end


endmodule
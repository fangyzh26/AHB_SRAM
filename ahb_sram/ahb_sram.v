module ahb_sram(
    //input signals from Master
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

    //output signals to Master
    output          hready_out,
    output          hresp,
    output [31:0]   hrdata,

    //input signals from sram_core(read data)
    input [7:0]     sram_q0,//bank0
    input [7:0]     sram_q1,
    input [7:0]     sram_q2,
    input [7:0]     sram_q3,
    input [7:0]     sram_q4,//bank1
    input [7:0]     sram_q5,
    input [7:0]     sram_q6,
    input [7:0]     sram_q7,   

    //output signals to sram_core, as sram_core contrl signals
    output [3:0]    bank0_csn,
    output [3:0]    bank1_csn,
    output          sram_we,
    output [12:0]   sram_addr,
    output [31:0]   sram_wdata
    );

    //---- htrans type ----
    parameter IDLE      = 2'b00;
    parameter BUSY      = 2'b01;
    parameter NONSEQ    = 2'b10;
    parameter SEQ       = 2'b11;

    //---- hsize type ----
    parameter BIT8      = 3'b000;
    parameter BIT16     = 3'b001;
    parameter BIT32     = 3'b010;
    // parameter BIT64     = 3'b011;
    // parameter BIT128    = 3'b100;
    // parameter BIT256    = 3'b101;
    // parameter BIT512    = 3'b110;
    // parameter BIT1024   = 3'b111;

    //---- hburst type ----   
    parameter SINGAL    = 3'b000; //SRAM operation just need SINGAL mode
    // parameter INCR      = 3'b001;
    // parameter WRAP4     = 3'b010;
    // parameter INCR4     = 3'b011;
    // parameter WRAP8     = 3'b100;
    // parameter INCR8     = 3'b101;
    // parameter WRAP16    = 3'b110;
    // parameter INCR16    = 3'b111;

    //----- hresp type -----
    parameter OKAY      = 1'b0;
    parameter ERROR     = 1'b1;

    //------ address and control signals delay, to meet  SRAM -----------------------------------------
    reg [1:0]       htrans_r;
    reg [2:0]       hsize_r;
    reg [2:0]       hburst_r;
    reg             hwrite_r;
    reg [31:0]      haddr_r;
    always @(posedge hclk, negedge hrstn) begin
        if(!hrstn) begin
            htrans_r <= 'd0;
            hsize_r  <= 'd0;
            hburst_r <= 'd0;
            hwrite_r <= 'd0;
            haddr_r  <= 'd0;
        end
        else if (hready_in&&hsel) begin //AHB transfer has 2 phase: address phase and data phase,while address phase is
            htrans_r <= htrans;         //a clock ahead of data phase.
            hsize_r  <= hsize;          //SRAM: address and data phase is in a same phase.
            hburst_r <= hburst;         //thus, AHB's address and control signals need to lag a clock,then address phase and 
            hwrite_r <= hwrite;         // data phase is in the same phase, which meet the access behavior of SRAM.
            haddr_r  <= haddr;
        end
        else begin
            htrans_r <= 'd0;
            hsize_r  <= 'd0;
            hburst_r <= 'd0;
            hwrite_r <= 'd0;
            haddr_r  <= 'd0;
        end
    end

    //----- -------------------------------------------------------------
    wire sram_write;
    wire sram_read;
    wire sram_we;
    wire sram_en;
    assign sram_write = (htrans_r==NONSEQ || htrans_r==SEQ) && (hwrite_r);
    assign sram_read  = (htrans_r==NONSEQ || htrans_r==SEQ) && (!hwrite_r);
    assign sram_en    = sram_write|sram_read;
    assign sram_we    = sram_write;//*

    wire [15:0]  sram_addr_64K;
    assign sram_addr_64K = haddr_r[15:0]; //sram totally has 64K data, means need 16 address lines
    assign sram_addr     = sram_addr_64K[14:2];//* a bank line has 32bits data,need 4 bit address
                                               // a signal sram has 8K stroage space, which needs 13 address lines
    reg [3:0] sram_csn;
    wire bank_sel;
    assign bank_sel  = sram_en && (sram_addr_64K[15]==0);//1:select bank0,  0:select bank1
    assign bank1_csn =  bank_sel ?  4'b1111  : sram_csn ;//*
    assign bank0_csn =  bank_sel ?  sram_csn : 4'b1111  ;//*
    always @(haddr_r[1:0], hsize_r[1:0]) begin
        if(hsize_r[1:0]==BIT32) begin// transfer 32bit data, a bank line is all selected, 0 is valid
            sram_csn = 4'b0000;
        end
        else if(hsize_r[1:0]==BIT16)begin// transfer 16bit data, half of bank line is selected
            case (haddr_r[1])
                1'b0:sram_csn = 4'b1100; // select low 16bits
                1'b1:sram_csn = 4'b0011; // select high 16bits
            endcase      
        end
        else if(hsize_r[1:0]==BIT8) begin// transfer 8bit data, 1/4 bank line is selected
            case (haddr_r[1:0])
                2'b00: sram_csn = 4'b1110;//select 1st byte
                2'b01: sram_csn = 4'b1101;//select 2nd byte
                2'b10: sram_csn = 4'b1011;//select 3th byte
                2'b11: sram_csn = 4'b0111;//select 4th byte
            endcase
        end
    end

    assign sram_wdata   = hwdata;//*

    assign hrdata       = bank_sel ? {sram_q3,sram_q2,sram_q1,sram_q0} : {sram_q7,sram_q6,sram_q5,sram_q4};//*
    assign hready_out   = 1'b1; //* slave always ready
    assign hresp        = OKAY; //* slave always OKAY
    
endmodule
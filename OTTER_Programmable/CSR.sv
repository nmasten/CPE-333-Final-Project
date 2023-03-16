`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  J. Callenes
// 
// Create Date: 02/02/2019 03:01:38 PM
// Design Name: 
// Module Name: CSR
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module CSR(input clk,
           input rst,
           input intTaken,
           input intRet,
           input [11:0] addr,
           input [31:0] next_pc,
           input [31:0] wd,
           input wr_en,
           output logic [31:0] rd,
           output logic [31:0] mepc=0, //return address after handling trap-interrupt 
           output logic [31:0] mtvec=0,  //trap handler address
           output logic mstatus,
           output logic mie
    );
    
    // CSR addresses
    typedef enum logic [11:0] {
        MSTATUS   = 12'h300,
        MIE       = 12'h304,
        MTVEC     = 12'h305,
        MEPC      = 12'h341
    } csr_t;

    always_ff @ (posedge clk)
    begin
        if(rst) begin
            mtvec <= 'h0;
            mepc  <= 'h0;
            mie <= 'h0;
            mstatus <= 'h0;
        end
        if(wr_en)
            case(addr)
                MTVEC:  mtvec <= wd;    // where to go on interrupt
                MEPC:   mepc  <= wd;    // return address set by hardware
                MIE:    mie <= wd[0];   // enable interrupts
                MSTATUS: mstatus <= wd[0];
            endcase
            
         if(intTaken)
         begin
            mepc <= next_pc;
            mstatus <= 1'b0;
         end
         if(intRet)
            mstatus <=1'b1;
    end
    
    always_comb
       case(addr)
            MTVEC:  rd = mtvec;
            MEPC:   rd = mepc;
            MIE:    rd ={{32{1'b0}},mie};
            MSTATUS: rd = {{32{1'b0}},mstatus};
            default:rd = 32'd0;
       endcase
    
endmodule
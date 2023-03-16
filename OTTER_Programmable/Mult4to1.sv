`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  J. Callenes
// 
// Create Date: 01/04/2019 04:49:55 PM
// Design Name: 
// Module Name: Mult4to1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//  J. Callenes
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.10 - (Keefe Johnson, 1/14/2020) Commented out unused modules.
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module Mult6to1(In1, In2, In3, In4, In5, In6, Sel, Out);
    input [31:0] In1, In2, In3, In4, In5, In6; //32-bit inputs 
    input [3:0] Sel; //selector signal
    output logic [31:0] Out; //64-bit output
    always_comb
        case (Sel) //a 5->1 multiplexor
            0: Out <= In1; 
            1: Out <= In2; 
            2: Out <= In3;
            3: Out <= In4;
            4: Out <= In5;
            5: Out <= In6;
            default: Out <= In1; 
        endcase
endmodule

/*
module Mult5to1(In1, In2, In3, In4, In5, Sel, Out);
    input [31:0] In1, In2, In3, In4, In5; //four 64-bit inputs 
    input [2:0] Sel; //selector signal
    output logic [31:0] Out; //64-bit output
    always_comb
        case (Sel) //a 5->1 multiplexor
            0: Out <= In1; 
            1: Out <= In2; 
            2: Out <= In3;
            3: Out <= In4;
            4: Out <= In5;
            default: Out <= In1; 
        endcase
endmodule
*/

module Mult4to1(In1, In2, In3, In4, Sel, Out);
    input [31:0] In1, In2, In3, In4; //four 64-bit inputs 
    input [1:0] Sel; //selector signal
    output logic [31:0] Out; //64-bit output
    always_comb
        case (Sel) //a 4->1 multiplexor
            0: Out <= In1; 
            1: Out <= In2; 
            2: Out <= In3;
            default: Out <= In4; 
        endcase
endmodule

module Mult2to1(In1, In2, Sel, Out);
    input [31:0] In1, In2; //four 64-bit inputs 
    input Sel; //selector signal
    output logic [31:0] Out; //64-bit output
    always_comb
        case (Sel) //a 4->1 multiplexor
            0: Out <= In1;            
            default: Out <= In2; 
        endcase
endmodule
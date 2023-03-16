`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: J. Callenes 
// 
// Create Date: 06/07/2018 05:03:50 PM
// Design Name: 
// Module Name: ArithLogicUnit
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

module OTTER_ALU(ALU_fun, A, B, ALUOut);
        input [3:0] ALU_fun;  //func7[5],func3
        input [31:0] A,B;
        output logic [31:0] ALUOut; 
       
        always_comb
        begin //reevaluate If these change
            case(ALU_fun)
                0:  ALUOut = A + B;     //add
                8:  ALUOut = A - B;     //sub
                6:  ALUOut = A | B;     //or
                7:  ALUOut = A & B;     //and
                4:  ALUOut = A ^ B;     //xor
                5:  ALUOut =  A >> B[4:0];    //srl
                1:  ALUOut =  A << B[4:0];    //sll
               13:  ALUOut =  $signed(A) >>> B[4:0];    //sra
                2:  ALUOut = $signed(A) < $signed(B) ? 1: 0;       //slt
                3:  ALUOut = A < B ? 1: 0;      //sltu
                9:  ALUOut = A; //copy op1 (lui)
                10: ALUOut = A * B;
                default: ALUOut = 0; 
            endcase
        end
    endmodule
   
  
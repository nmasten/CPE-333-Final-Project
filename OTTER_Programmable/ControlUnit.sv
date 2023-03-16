`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2019 11:51:23 AM
// Design Name: 
// Module Name: ControlUnit
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
//`include "opcodes.svh"

module OTTER_CU_FSM(
    input CU_CLK,
    input CU_INT,
    input CU_prevINT,
    input CU_RESET,
    input [6:0] CU_OPCODE,
    input [2:0] CU_FUNC3,
    input [11:0] CU_FUNC12,
    output logic CU_PCWRITE,  //PCWrite
    output logic CU_REGWRITE,    
    output logic CU_MEMWRITE,
    output logic CU_MEMREAD1,
    output logic CU_MEMREAD2,
    output logic CU_intTaken,
    output logic CU_csrWrite,
    output logic CU_intCLR
   );
        //IR[6:2]  opcode for 32-bit instructions   //first two bits are always 11
        typedef enum logic [6:0] {
                   LUI      = 7'b0110111,
                   AUIPC    = 7'b0010111,
                   JAL      = 7'b1101111,
                   JALR     = 7'b1100111,
                   BRANCH   = 7'b1100011,
                   LOAD     = 7'b0000011,
                   STORE    = 7'b0100011,
                   OP_IMM   = 7'b0010011,
                   OP       = 7'b0110011,
                   SYSTEM   = 7'b1110011
        } opcode_t;
        //wire CU_OPCODE =CU_IR[6:0];
        //wire func3 = CU_IR[14:12];
      
        opcode_t OPCODE;
        assign OPCODE = opcode_t'(CU_OPCODE);
        
        typedef enum logic [2:0] {
                Func3_CSRRW  = 3'b001,
                Func3_CSRRS  = 3'b010,
                Func3_CSRRC  = 3'b011,
                Func3_CSRRWI = 3'b101,
                Func3_CSRRSI = 3'b110,
                Func3_CSRRCI = 3'b111,
                Func3_PRIV   = 3'b000       //mret
        } funct3_system_t;

        typedef enum logic[1:0] {FETCH,EXECUTE,WB,INTER} state_type;
        state_type state;
        
        logic MRET;
        assign MRET = (CU_OPCODE==SYSTEM) && (CU_FUNC3==Func3_PRIV) && (CU_FUNC12==12'h302);         
                      
       //DECODING (depends on state) ////////////////////////////////////////////////////
        assign CU_MEMREAD1 = (state ==0);         
        assign CU_MEMREAD2 = (state==1 && CU_OPCODE==LOAD);
        assign CU_MEMWRITE = (state == 1) && (CU_OPCODE == STORE);
        
        assign CU_PCWRITE = (state==1 && CU_OPCODE!=LOAD)|| (state==2 && CU_OPCODE==LOAD)||(state==INTER); //(state == 0) || (state==1 && (CU_OPCODE ==JAL || CU_OPCODE==JALR || (CU_OPCODE==BRANCH && brn_cond)));
        
        // assign CU_RF_WR_SEL = ((state == 2) && (CU_OPCODE == OP || CU_OP_CODE)) ? 0 : 1;
        assign CU_REGWRITE = (state == 2) || ((state == 1) && (CU_OPCODE != BRANCH && CU_OPCODE !=LOAD && CU_OPCODE !=STORE && ~MRET) );
      
     
         
    initial begin state = FETCH; end // start the state machine in state 1 
    // Here is the state machine, which only has to sequence states
    always @(posedge CU_CLK)
    begin // all state updates on a positive clock edge
            if(CU_RESET)    state<=FETCH;
            else begin
                case (state)       
                    FETCH: state <= EXECUTE; // FETCH, MEM[PC]->IR, unconditional next state
                    EXECUTE: begin
                                if(CU_OPCODE !=LOAD) begin
                                    state <= FETCH;
                                    if(CU_INT || CU_prevINT) state <= INTER;
                                end else
                                    state <= WB;                            
                             //   state <= (CU_OPCODE !=LOAD)? FETCH:WB; // EX all but LOAD
                             end
                    WB: begin 
                            state <= FETCH;
                            if(CU_INT || CU_prevINT) state <= INTER; 
                        end
                    INTER:  state <= FETCH;
                    default: state <= FETCH;
                endcase
            end
    end
    assign CU_intCLR = ((CU_OPCODE==LOAD && state==WB) || (CU_OPCODE!=LOAD && state==EXECUTE)|| state==INTER);
    assign CU_csrWrite = ((state==EXECUTE) && (CU_OPCODE==SYSTEM) && (CU_FUNC3==Func3_CSRRW));
    assign CU_intTaken = (state==INTER);//((state==EXECUTE) && ~MRET);
    
endmodule


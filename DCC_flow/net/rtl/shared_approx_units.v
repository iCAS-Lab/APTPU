`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2021 04:32:52 PM
// Design Name: 
// Module Name: shared_approx_units
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


module shared_approx_units #( 
    parameter MULT_DW = 4,              //Accurate multiplier size 
    parameter A_BW    = 8              // Operand A bitwith 
    )                     (
    input  [A_BW-1:0] a,
    output [MULT_DW-1:0] mult_a_in,                     // The accurate multiplier input 
    output a_sign,                                      // The sign bit of an operand (a)
    output [$clog2(A_BW)-1:0] a_shamt                   // Shift amount of the operand (The Power of an operand) 
    );

    wire [A_BW-1:0] uns_a;                      // The unsigend copy of the operand
    wire [A_BW-1:0] lod_AO;                     // LOD of A-Operand output
    wire [$clog2(A_BW)-1:0] log_a;              // Log of A-Operand (P_Encoder output)
    wire [MULT_DW-3:0] trunc_a;                 // truncated A-operand (MUX output)

    wire [(MULT_DW*2)-1:0] accurate_mult;       // Accurate Multiplier output DW
    
    unsign #(.A_BW(A_BW)) unsign_unit(.a(a),.uns_a(uns_a),.a_sign(a_sign));   
    LOD #(.BW(A_BW)) LOD_A (.in_a(uns_a),.out_a(lod_AO));
    P_Encoder #(.BW(A_BW)) PE_A (.in_a(lod_AO),.out_a(log_a));
    mux #(.BW(A_BW),.MULT_DW(MULT_DW)) mux_A (.in_a(uns_a),.select(log_a),.out(trunc_a));
        
    assign a_shamt = (log_a > (MULT_DW-1)) ?  log_a - (MULT_DW-1) : 0; 
    assign mult_a_in = (log_a > (MULT_DW-1)) ? ({1'b1,trunc_a,1'b1}) : uns_a[MULT_DW-1:0]; 

endmodule

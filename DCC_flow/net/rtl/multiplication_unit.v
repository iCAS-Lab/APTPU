`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 02/26/2021 03:55:26 PM
// Design Name: 
// Module Name: multiplication_unit
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


module multiplication_unit #(
    parameter A_BW=8,
    parameter B_BW = 8,
    parameter ACCURATE_DW = 4                       //Accurate multiplier core size 
    )                       (
    input [ACCURATE_DW-1:0] mult_a_in,                  // truncated_A-Operand for MULTIPLICATION
    input [ACCURATE_DW-1:0] mult_b_in,               // truncated_B-Operand for MULTIPLICATION 
    input  w_sign,i_sign,                    // Sign bits of the weight and the input data (pixel data)
    input [$clog2(A_BW)-1:0] a_shamt,            // Amount of shifting for A-Operand
    input [$clog2(B_BW)-1:0] b_shamt,            // Amount of shifting for B-Operand
    output[(A_BW+B_BW)-1:0] mult_product
    );
    
    wire [(ACCURATE_DW*2)-1:0] accurate_mult;        // Accurate Multiplier output DW
    wire [$clog2(B_BW):0] t_shamt;            // Total shift amount (Input for Barrel Shifter)   
    wire [(A_BW+B_BW)-1:0] unsigned_product;            //Unsigned approximated result  

    assign t_shamt = a_shamt + b_shamt;
    
    accurate_multiplier #(.a_BW(ACCURATE_DW),.b_BW(ACCURATE_DW)) accurate_multiplier (.a(mult_a_in),.b(mult_b_in),.product(accurate_mult));
    
    barrel_shifter#(.A_BW(A_BW),.MULT_DW(ACCURATE_DW),.B_BW(B_BW)) barrel_shifter (.mult_out(accurate_mult),.shift_amt(t_shamt),.out(unsigned_product));
    
    signed_product #(.BW((A_BW+B_BW))) signed_unit (.a_sign(i_sign),.b_sign(w_sign),.unsigned_product(unsigned_product),.signed_product(mult_product));
    
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 02/26/2021 03:54:42 PM
// Design Name: 
// Module Name: accurate_multiplier
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


module accurate_multiplier #(
    parameter a_BW = 4, 
    parameter b_BW = 4
    
    )                       (
    input [a_BW-1:0] a,
    input [b_BW-1:0] b,
    output [(b_BW+a_BW)-1:0] product
    );
    
    
    assign product = a * b;
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 02/26/2021 04:27:39 PM
// Design Name: 
// Module Name: unsign
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


module unsign #(
    parameter A_BW = 8                                  // The number of bits in the operand
    )                             (
    input [A_BW-1:0] a,
    output [A_BW-1:0] uns_a,
    output a_sign
    );
    
    assign uns_a = (a[A_BW-1] == 1'b1) ? ~a + 1'b1 : a;
    assign a_sign = a[A_BW-1]; 
endmodule

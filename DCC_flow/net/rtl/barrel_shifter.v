`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 02/26/2021 03:54:20 PM
// Design Name: 
// Module Name: barrel_shifter
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


module barrel_shifter#(
    parameter A_BW=8,
    parameter MULT_DW=6,
    parameter B_BW=8
    )                  (
    input [(MULT_DW*2)-1:0] mult_out,
    input [$clog2(B_BW):0] shift_amt,
    output [(A_BW+B_BW)-1:0] out
    );
    
    wire [(A_BW+B_BW)-1:0] w;
    
    assign w = {{((A_BW+B_BW)-(MULT_DW*2)){1'b0}}, mult_out}; 
    
    
    assign out = (w<<shift_amt); 
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 04/06/2021 05:22:06 PM
// Design Name: 
// Module Name: full_adder
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


module full_adder (
   
   input  a , b, carry_in,
   output s , carry_out

    );
    
    wire w1,w2,w3;
    
    assign w1 = a^b; 
    
    assign s = w1 ^ carry_in; 
    
    assign w2 = w1 & carry_in; 
    assign w3 = a & b; 
    
    assign carry_out = w2 | w3  ; 
    
    
endmodule
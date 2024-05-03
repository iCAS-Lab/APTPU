`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 02/26/2021 03:53:55 PM
// Design Name: 
// Module Name: signed_product
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

module signed_product #(
    parameter BW = 8
    )                   (
    
    input a_sign, b_sign,
    input [BW-1:0] unsigned_product,
    output [BW-1:0] signed_product
    );
    
    wire sign;
    
    assign sign = a_sign ^ b_sign; 
    assign signed_product = sign ? ~ unsigned_product +1'b1 : unsigned_product; 
    
    
endmodule

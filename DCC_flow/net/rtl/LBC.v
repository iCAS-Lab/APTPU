`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/14/2023 09:22:32 PM
// Design Name: 
// Module Name: LBC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Logarithmic-Binary converter (LBC)
//  anti-logarithmic converter
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


	
module LBC #(parameter LOG2_WIDTH = 4, WIDTH = 2**LOG2_WIDTH) //WIDTH --> input data width
(
input	wire	[WIDTH-2:0]			fraction, // fraction part
input	wire	[LOG2_WIDTH:0]		exp_sum, //sum of exponent
output          [2*WIDTH-1:0]       result  // original form = 2*BW 
);

wire [WIDTH-1:0] conct_fraction; 

wire [LOG2_WIDTH:0] t_shamt_r,t_shamt_l;

assign t_shamt_r = (WIDTH-1)-exp_sum;           // Shift right if Width-1 is greater than exp_sum 
assign t_shamt_l = exp_sum-(WIDTH-1);           // Shift left if Width-1 is less than exp_sum 
/* Note: Later we can change them in a way that we  
    can compute one and let the one be the two's 
    complement of the other Because one is the 
    negative form of the other                          */


assign conct_fraction = {1'b1,fraction} ;              // We do this for error reduction (read the paper for more information about why we do this in the implementation - Elbtity)

assign result = (exp_sum<(WIDTH-1))? conct_fraction >> t_shamt_r :  conct_fraction << t_shamt_l;  

endmodule

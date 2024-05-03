`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/28/2023 12:47:35 AM
// Design Name: 
// Module Name: adder_RoBA
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


module adder_RoBA#(parameter WIDTH = 16, LOG2_WIDTH = 4) //WIDTH --> input data width
(
input	wire	[2*WIDTH-1:0] 	A,B,
output	wire	[2*WIDTH:0] 	R
);

assign R = A+B ;

endmodule
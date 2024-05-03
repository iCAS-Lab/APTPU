`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/15/2023 06:01:04 AM
// Design Name: 
// Module Name: pre_comp_bank
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
module pre_comp_bank #(parameter LOG2_WIDTH = 4, WIDTH = 2**LOG2_WIDTH)
(
input	wire	[WIDTH-1:0]		I, //Multiplier
output	wire	[WIDTH+2:0]		I1,I3,I5,I7 //Bank Output
);

assign I1 = I ; // I*1
assign I3 = I + (I << 1) ; // I*3
assign I5 = I + (I << 2) ; // I*5
assign I7 = I3 + (I << 2) ; // I*7

//assign I1 = I ; // I*1
//assign I3 = I + (I << 1) ; // I*3
//assign I5 = I + (I << 2) ; // I*5
//assign I7 = I + (I << 1) + (I << 2) ; // I*7


endmodule
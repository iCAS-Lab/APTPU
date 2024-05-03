`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/14/2023 09:22:32 PM
// Design Name: 
// Module Name: BLC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Binary-Logarithmic converter (BLC)
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//this mux shift the input to the left to subtract one from the term (1+x) in log2(A) = k + log2(1+x) 
// and let the x only to be concatenated with k

	 
module BLC #(parameter LOG2_WIDTH = 4, WIDTH = 2**LOG2_WIDTH) //WIDTH --> input data width
(
input	wire	[WIDTH-1:0]						Operand, // input data
input	wire	[LOG2_WIDTH-1:0]				K, //index of first one
//output	reg		[LOG2_WIDTH+WIDTH-2:0]			log_format //logarithmic format
//output		[LOG2_WIDTH+WIDTH-2:0]			log_formt //logarithmic format
output		[WIDTH-2:0]			log_formt //logarithmic format
				// WIDTH-2 because if k = 15 only 15 out of 16 bits will get out
);

reg		[WIDTH-1:0]	log_frac ; // logarithmic fraction

wire		[WIDTH-1:0]	shamt ; // Shift Amount 
wire		[WIDTH-1:0]	log_amnt ; // logarithmic fraction

assign shamt = WIDTH - K;
//assign log_amnt = {Operand, {shamt{1'b0}}}; 
assign log_amnt = Operand << shamt; 

//assign log_formt = {K,log_amnt[WIDTH-1:1]} ;
assign log_formt = log_amnt[WIDTH-1:1] ;

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/28/2023 12:47:35 AM
// Design Name: 
// Module Name: subtractor
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


module subtractor #(parameter WIDTH = 16,ROUN_WIDTH = WIDTH+1, LOG2_WIDTH = $clog2(WIDTH)) //WIDTH --> input data width
(
input	wire	[2*WIDTH:0] 	A,B,
output	wire	[2*WIDTH:0] 	R
);

wire	[2*WIDTH:0]	sub ;

assign sub = A-B ;
assign R = sub[2*WIDTH] ? ~sub+1 : sub ; //2's complement

endmodule

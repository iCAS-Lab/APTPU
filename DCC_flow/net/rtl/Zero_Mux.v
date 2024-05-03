`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/15/2023 06:01:04 AM
// Design Name: 
// Module Name: Zero_Mux
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

module Zero_Mux #(parameter LOG2_WIDTH = 4, WIDTH = 2**LOG2_WIDTH, WEIGHT_NIBBLE = 0,
								 LOG2_NIBBLE_WIDTH = 2, NIBBLE_WIDTH = 2**LOG2_NIBBLE_WIDTH)
(
input	wire	[NIBBLE_WIDTH-1:0]	NIBBLE,
input	wire	[2*WIDTH-1:0]		IN,
output	wire	[2*WIDTH-1:0]		OUT
);

assign OUT = &(~NIBBLE) ? 'd0: IN;

//assign OUT = (~NIBBLE[3] & ~NIBBLE[2] & ~NIBBLE[1] & ~NIBBLE[0]) ? 'd0 : IN ;

endmodule
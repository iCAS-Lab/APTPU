`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/15/2023 06:01:04 AM
// Design Name: 
// Module Name: control_unit
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

module control_unit #(parameter LOG2_WIDTH = 3, 
                      parameter WIDTH = 2**LOG2_WIDTH, 
					  parameter LOG2_NIBBLE_WIDTH = 2, 
					  parameter NIBBLE_WIDTH = 2**LOG2_NIBBLE_WIDTH
					  )
(
input	wire	[NIBBLE_WIDTH-1:0]			operand, // Nibble (4 bits)
output	wire	[LOG2_NIBBLE_WIDTH-1:0]		SEL, // Alphapet selection,
output	wire	[LOG2_NIBBLE_WIDTH-1:0]		SL	// Shift left value
);

assign	SEL[LOG2_NIBBLE_WIDTH-1] = (operand[3] & operand[1])                 | (~operand[3] & operand[2] & operand[0]) ;
assign	SEL[LOG2_NIBBLE_WIDTH-2] = (operand[2] & (operand[3] | operand[1] )) | (~operand[3] & operand[1] & operand[0]) ;

assign	SL[LOG2_NIBBLE_WIDTH-1] = ~operand[1] & (operand[3]  | (operand[2] & ~operand[0])) ; 
assign	SL[LOG2_NIBBLE_WIDTH-2] = (operand[1] & ~operand[0]) | (operand[3] & (operand[1] | ~operand[2])) ;
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/15/2023 06:01:04 AM
// Design Name: 
// Module Name: select_unit
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


module select_unit #(parameter LOG2_WIDTH = 4, WIDTH = 2**LOG2_WIDTH, 
								 LOG2_NIBBLE_WIDTH = 2, NIBBLE_WIDTH = 2**LOG2_NIBBLE_WIDTH)
(
input	wire	[WIDTH+2:0]					I1,I3,I5,I7, // pre_comp_bank_output
input	wire	[LOG2_NIBBLE_WIDTH-1:0]		SEL, // Alphabet selection,
output	reg		[WIDTH+2:0]					IX	// Selected alphabet
);


always@(*)
begin
IX = 'd0 ;
case(SEL)
	2'b00:	IX = I1 ;
	2'b01:	IX = I3 ;
	2'b10:	IX = I5 ;
	2'b11:	IX = I7 ;
endcase

end

endmodule

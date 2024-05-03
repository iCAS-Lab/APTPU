`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/28/2023 12:47:35 AM
// Design Name: 
// Module Name: decision_mux_Rounding
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


module decision_mux_Rounding #(parameter WIDTH = 16, LOG2_WIDTH = 4) //Decide to shift left by one or no according to bit at k-1
(
input	wire	[WIDTH-1:0]		IN, //2**k 
input	wire					decision_bit, //bit postion k-1 in multiplicant
output	reg		[WIDTH:0]		IN_r	//(rounded IN) width is larger because the number may be rounded to 2**16
);


always@(*)
begin
if(decision_bit)
	IN_r = IN << 1 ; //multiplied by 2
else
	IN_r = IN ;
end

endmodule
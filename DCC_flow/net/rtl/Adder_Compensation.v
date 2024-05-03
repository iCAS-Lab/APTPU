`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/26/2023 12:15:48 AM
// Design Name: 
// Module Name: Adder_Compensation
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


module Adder_Compensation #(parameter DataIN_width = 16, truncation_width = 6, DataK_width = 4)
(
input	wire	[DataK_width+truncation_width:0]	AC_OP1,AC_OP2,
output	reg		[DataK_width+truncation_width+1:0]	AC_L
);

always@(*)
begin
AC_L = AC_OP1 + AC_OP2 + 'd1 ;
//A logic one is added to the addition product to compensate the result.
//{k1,x1t}+{k2,x2t}+1
end

endmodule
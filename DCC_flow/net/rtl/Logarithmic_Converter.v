`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/26/2023 12:15:48 AM
// Design Name: 
// Module Name: Logarithmic_Converter
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


module Logarithmic_Converter #(parameter DataIN_width = 16, truncation_width = 6, DataK_width = 4)
(
input	wire	[DataK_width-1:0]					LC_K, //index of first one
input	wire	[truncation_width:0]				LC_X, //fraction part of log2(operand) but it's truncated
output	reg		[DataK_width+truncation_width:0]	LC_OP
);

always@(*)
begin
LC_OP = {LC_K,LC_X} ;
end

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2023 02:14:08 AM
// Design Name: 
// Module Name: ASM_B_pre_approximate
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


module ASM_B_pre_approximate #(parameter WIDTH = 32, LOG2_WIDTH = $clog2(WIDTH), NIBBLE_WIDTH = 4, LOG2_NIBBLE_WIDTH = $clog2(NIBBLE_WIDTH),NIBBLES = WIDTH/4 )
(
input      [WIDTH-1:0]      B,
output     [WIDTH+2:0]      I1_wire, I3_wire, I5_wire, I7_wire
);


pre_comp_bank #(.LOG2_WIDTH(LOG2_WIDTH)) pre_comp_bank(.I(B), .I1(I1_wire),.I3(I3_wire),.I5(I5_wire),.I7(I7_wire));

endmodule


// MIT License
// 
// Copyright (c) 2021-2024 iCAS Lab
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// Company: iCAS Lab, University of South Carolina
// Engineer: Mohammed E. Elbtity
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


`timescale 1ns / 1ps

module ASM_B_pre_approximate #(parameter WIDTH = 32, LOG2_WIDTH = $clog2(WIDTH), NIBBLE_WIDTH = 4, LOG2_NIBBLE_WIDTH = $clog2(NIBBLE_WIDTH),NIBBLES = WIDTH/4 )
(
input      [WIDTH-1:0]      B,
output     [WIDTH+2:0]      I1_wire, I3_wire, I5_wire, I7_wire
);


pre_comp_bank #(.LOG2_WIDTH(LOG2_WIDTH)) pre_comp_bank(.I(B), .I1(I1_wire),.I3(I3_wire),.I5(I5_wire),.I7(I7_wire));

endmodule


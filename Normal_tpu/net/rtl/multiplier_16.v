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
// Create Date: 02/05/2024 05:31:47 AM
// Design Name: 
// Module Name: multiplier_16
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

module multiplier_16#(
    parameter BW_A = 16,
    parameter BW_B = 16
    ) (
    input [BW_A-1:0] op1, 
    input [BW_B-1:0] op2,
    output [(BW_A+BW_B)-1:0] res
    );
    
    wire	[BW_A/2-1:0]	AL,AH,BL,BH ;
    wire    [BW_A-1:0]      Z1,Z2,Z3,Z4 ;
    
    
    assign    AL = op1[BW_A/2-1:0] ;  //LSBs
    assign    AH = op1[BW_A-1:BW_A/2] ; //MSBs
    
    assign    BL = op2[BW_A/2-1:0] ;  //LSBs
    assign    BH = op2[BW_A-1:BW_A/2] ; //MSBs
    
    multiplier_8 #(.BW_A(BW_A/2),.BW_B(BW_B/2)) AL_BL (.op1(AL),.op2(BL),.res(Z1));
    multiplier_8 #(.BW_A(BW_A/2),.BW_B(BW_B/2)) AH_BL (.op1(AH),.op2(BL),.res(Z2));
    multiplier_8 #(.BW_A(BW_A/2),.BW_B(BW_B/2)) AL_BH (.op1(AL),.op2(BH),.res(Z3));
    multiplier_8 #(.BW_A(BW_A/2),.BW_B(BW_B/2)) AH_BH (.op1(AH),.op2(BH),.res(Z4));
              
    assign    res = Z1 + (Z2 << (BW_A/2)) + (Z3 << (BW_A/2)) + (Z4 << BW_A) ;
    
    
endmodule

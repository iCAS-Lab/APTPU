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
// Create Date: 04/23/2021 06:11:57 PM
// Design Name: 
// Module Name: mat_mult_unit
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

module mat_mult_unit #(
    
    parameter DW = 8,                   // Datawidth = Pixels data width 
    parameter WW = 8,                   // Wights width = parameters or factors width
    parameter M  = 3,                   // Number of Units in each column
    parameter OUTWIDTH= (DW+WW)+(M-1)           // Output width 

    )                 (
    input      signed   [DW-1:0]       pixel_data,               //Data 
    input      signed   [WW-1:0]       weight,                   // Weight
    input                              clk,rst_n,
    input                              refresh,                  // Refresh signal to start accumulating from the begining                
    output reg          [DW-1:0]       pypas_data,               // Data pypassing register
    output reg          [WW-1:0]       pypas_weight,             // Weight Pypassing register
    output reg signed   [OUTWIDTH-1:0] acc_result                // Result register

    );
    
    /* Multipling the coming image's data by filter's weight */
    wire signed [DW+WW-1:0] mult;
    
    generate 
    if (DW==8) 
         multiplier_8 #(.BW_A(DW),.BW_B(WW)) multiplier_8 (.op1(weight),.op2(pixel_data),.res(mult));
    else if (DW==16)
         multiplier_16 #(.BW_A(DW),.BW_B(WW)) multiplier_16 (.op1(weight),.op2(pixel_data),.res(mult));
    else if (DW==32) 
         multiplier_32 #(.BW_A(DW),.BW_B(WW)) multiplier_32 (.op1(weight),.op2(pixel_data),.res(mult));
    else
        assign mult = weight * pixel_data;
  
  endgenerate   
    
    /* Pypassing logic */ 
   always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin 
        pypas_data <= 'sd0; 
        pypas_weight <= 'sd0; 
    end else begin  
        pypas_data <= pixel_data; 
        pypas_weight <= weight; 
    end
   end      // always
    
    /* Acculmulating the result */ 
   always @(posedge clk or negedge rst_n) begin 
    if (!rst_n) begin 
        acc_result <= 'sd0;
    end else if (refresh) begin
        acc_result <= mult;
    end else begin 
        acc_result <= acc_result + mult;
    end  
   end                  //always 
    
endmodule

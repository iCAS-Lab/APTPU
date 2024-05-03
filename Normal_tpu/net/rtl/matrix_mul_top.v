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
// Create Date: 05/01/2021 08:38:35 AM
// Design Name: 
// Module Name: matrix_mul_top
// Project Name: 
// Target Devices: ASIC 
// Tool Versions: 
// Description: Matrix multiplication unit - Parameterized so it can be modified to any number 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps


module matrix_mul_top#(

    parameter DW = 8,                   // Datawidth = 1 Pixel data width 
    parameter WW = 8,                   // Wights width = 1 parameter or 1 factor width
    parameter N  = 3,                   // Number of Units in each row
    parameter M  = 3,                   // Number of Units in each column
    parameter OUTWIDTH= (DW+WW)+(N-1)           // Output width  

    )                 (
    input  [DW*M-1:0]         pic_data_in,
    input  [WW*N-1:0]         filter_weight,
    input                     clk,rst_n,
    input  [N*M-1:0]          refresh_sig_bus,
    output [DW*M-1:0]         pypas_pic,
    output [WW*N-1:0]         pypas_filter,
    output [OUTWIDTH*N*M-1:0] acc_result                // Result register
    );
    
    wire [WW*N-1:0] filter_weight_out [0:M];
    
    genvar m; 
    
    generate 
        for (m=0; m<M; m=m+1) begin 
            matrix_multiplier #(
               .DW(DW),                   // Datawidth = 1 Pixel data width 
               .WW(WW),                   // Wights width = 1 parameter or 1 factor width
               .N (N) ,                   // Number of Units in each row
               .M (M) ,                   // Number of Units in each column
               .OUTWIDTH(OUTWIDTH)                  // Output width 
        
            )   Array_m    (
               .pic_data_in(pic_data_in[(DW*(m+1))-1:DW*m]), 
               .filter_weight(filter_weight_out[m]),        
               .clk(clk),.rst_n(rst_n),         
               .refresh_sig_bus(refresh_sig_bus[(N*(m+1))-1:N*m]),        
               .pypas_pic(pypas_pic[(DW*(m+1))-1:DW*m]), 
               .pypas_filter(filter_weight_out[m+1]), 
               .acc_result(acc_result[(OUTWIDTH*N*(m+1))-1:OUTWIDTH*N*m])                // Result register
            );
        end
        
    endgenerate 
                
    assign filter_weight_out[0] = filter_weight;
    assign pypas_filter = filter_weight_out[M];
    
endmodule

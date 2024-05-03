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
// Create Date: 04/29/2021 09:25:55 AM
// Design Name: 
// Module Name: matrix_multiplier
// Project Name: Systolic Array design - Matrix Multiplications 
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

module matrix_multiplier #(

       parameter DW = 8,                   // Datawidth = 1 Pixel data width 
       parameter WW = 8,                   // Wights width = 1 parameter or 1 factor width
       parameter N  = 3,                   // Number of Units in each row
       parameter M  = 3,                   // Number of Units in each column
       parameter OUTWIDTH= (DW+WW)+(N-1)           // Output width 
    )                     (
       input  [DW-1:0]   pic_data_in,
       input  [WW*N-1:0] filter_weight,
       input             clk,rst_n,
       input  [N-1:0]    refresh_sig_bus,
       output [DW-1:0]   pypas_pic,
       output [WW*N-1:0] pypas_filter,
       output [OUTWIDTH*N-1:0] acc_result                // Result register
    );
    
       wire [DW-1:0] pic_data_out[0:N];
       
       genvar n; 
       
       generate //begin 
       
        //for (m=0; m<M; m=m+1) begin 
            for (n=0; n<N; n=n+1) begin 
                
                mat_mult_unit #(
                
                .DW(DW),                  
                .WW(WW),                 
                .M (M),                  
                .OUTWIDTH(OUTWIDTH)
                ) unit_n (
                .pixel_data(pic_data_out[n]),               //Data 
                .weight(filter_weight[(WW*(n+1))-1:WW*n]),                   // Weight
                .clk(clk),.rst_n(rst_n),
                .refresh(refresh_sig_bus[n]),                  // Refresh signal to start accumulating from the begining                
                .pypas_data(pic_data_out[n+1]),               // Data pypassing register**
                .pypas_weight(pypas_filter[(WW*(n+1))-1:WW*n]),             // Weight Pypassing register
                .acc_result(acc_result[(OUTWIDTH*(n+1))-1:OUTWIDTH*n])                // Result register
            
                ); 
            end 
      endgenerate
 
      assign pic_data_out[0] = pic_data_in;
      assign pypas_pic = pic_data_out[N];
      

endmodule

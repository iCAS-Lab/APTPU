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
// Create Date: 09/09/2021 04:04:39 PM
// Design Name: 
// Module Name: fifo_array
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


module fifo_array#( parameter DW = 8,                    // Input Featuremap data width
                    parameter DEPTH = 8,                 // Depth of each FIFO
                    parameter ADDRESS = $clog2(DEPTH),   // Address for each FIFO
                    parameter WW = 8,                    // Filter (Weights) width
                    parameter M = 8,                     // Number of FIFOs in each COLUMN
                    parameter N = 8                      // Number of FIFOs in each ROW 
    )             ( //input  [DW*M-1:0] in_ifmap,          // Input "INPUT" FEATURE MAP
                    input  [(DW*(M+N))-1:0] in_data,       // Input "INPUT" data (IFMap & Weights)
                    //input  [WW*N-1:0] filter_weights,
                    input             clk,rst_n,
                    //input  [M-1:0]    wr_fm_en,          // Enable Feature Map writing        
                    input  [(M+N)-1:0]    wr_en,             // Enable writing        
                    input  [(M+N)-1:0]    rd_en,         // Enable  reading        
                    output [(M+N)-1:0]    empty,         // Empty signals from Input Feature Map FIFOs
                    output [(M+N)-1:0]    full,          // FIFOs full flags 
                    //input  [N-1:0]    wr_filter_en,      // Enable Filter Weights writing
                   // input  [M-1:0]    rd_fm_en,          // Enable Feature Map reading        
                   // input  [N-1:0]    rd_filter_en,      // Enable Filter Weights reading
                    output [DW*M-1:0] out_ifmap,         // Ouput "INPUT" FEATURE MAP
                    output [WW*N-1:0] out_filters       // Filter Weights output port from FIFO
                    //output [M-1:0]    empty_ifmap,       // Empty signals from Input Feature Map FIFOs
                    //output [N-1:0]    empty_filters,     // Empty Signals from Filters FIFOs
                    //output [M-1:0]    full_ifmap,        // IFMAP FIFOs full flags 
                    //output [N-1:0]    full_filters       // Filters FIFOS full flags
    );
    
    genvar m,n;
    
    /* Instantiation of Input Feature Map FIFOs Array */
    generate begin : IFMAP_FIFO
        for (m=0; m<M; m=m+1) begin
            fifo #(.WIDTH(DW),.DEPTH(DEPTH),.ADDRESS(ADDRESS)) ifmap_fifo (
                      .clk(clk),
                      .rst_n(rst_n),    
                      .wr_en(wr_en[m]),
                      .rd_en(rd_en[m]), 
                      .data_in(in_data[(DW*(m+1))-1:DW*m]),  
                       
                      //Outputs
                      .data_out(out_ifmap[(DW*(m+1))-1:DW*m]), 
                      .empty(empty[m]),    
                      .full(full[m])    
                   );
         end            // End For loop
       end
    endgenerate                 // End Generate blk
          
    /* Instantiation of Input Feature Map FIFOs Array */
    generate begin : Filter_FIFO
        for (n=M;n<(N+M);n=n+1) begin
            fifo #(.WIDTH(WW),.DEPTH(DEPTH),.ADDRESS(ADDRESS)) ifmap_fifo (
                      .clk(clk),
                      .rst_n(rst_n),    
                      .wr_en(wr_en[n]),
                      .rd_en(rd_en[n]), 
                      .data_in(in_data[(WW*(n+1))-1:WW*n]),  
                      //Outputs
                      .data_out(out_filters[(WW*(n-M+1))-1:WW*(n-M)]), 
                      .empty(empty[n]),    
                      .full(full[n])    
                   );
            end            // End For loop
          end
    endgenerate                 // End Generate blk
        
endmodule

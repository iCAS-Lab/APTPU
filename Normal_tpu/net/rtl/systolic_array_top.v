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
// Create Date: 09/10/2021 10:07:43 AM
// Design Name: Systolic Array top module
// Module Name: systolic_array_top
// Project Name: Systolic Array Chip
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

module systolic_array_top #(  parameter DW               = 8,                                  // Datawidth = 1 Pixel = IFmap datawidth                           
                              parameter WW               = 8,                                  // Wights width = Filter weight datawidth
                              parameter N                = 8,                                  // Number of Units in each row
                              parameter M                = 8,                                  // Number of Units in each column
                              parameter DEPTH            = (N+M-1),                            // Depth of each FIFO
                              parameter OUTWIDTH         = (DW+WW)+ $clog2(N),                 // Output width  
                              parameter WR_EN_VEC        = $clog2(N+M),                        // Decoder input port width (Filters)
                              parameter RESULT_CONT      = $clog2(N*M)
    )                      (  input  [WW-1:0]           data_in,                               // Weights/IFMap input to Demux then to FIFOs
                              output [OUTWIDTH-1:0]     result,                                // Results  from MUX
                              input  [WR_EN_VEC-1:0]    fifo_sel,                                 // Filters & IFMap FIFOs write enable (Inputs to decoder)
                              //input  [WR_EN_VEC-1:0]    wr_en,                                 // Filters & IFMap FIFOs write enable (Inputs to decoder)
                              input                     wr_en,
                              input                     clk,rst_n,                              
                              input                     rd_en,                                 // FIFOs Read Enable
                              input  [RESULT_CONT-1:0]  pe_sel_init,                           // Select certain PE | OR | Initialzing cedrtain PE Accumulation operation
                              input                     en_sel_init,                           // Enable selecting PE (HIGH) |OR| enable initializing certain PE (LOW). 
                              output                    empty_fifos,                           // Empty Signals from all FIFOs
                              output [M-1:0]            full_ifmap,                            // IFMAP FIFOs full flags 
                              output [N-1:0]            full_filters                           // Filters FIFOS full flags
    );
    
    wire [N*M-1:0]          initialize_bus_sign;
    wire [(M+N)-1:0]        wr_en_ctrl;                                                        // Enable writing control signals coming from the decoder    
    wire [(M+N)-1:0]        wr_en_sign;                                                        // Enable writing signals   
    wire [DW*M-1:0]         ifmap_data;                                                        // Input Feature Map data (Concatenated)
    wire [WW*N-1:0]         filter_weights;                                                    // Filter Weights (Concatenated)
    wire [OUTWIDTH*N*M-1:0] acc_result;                                                        // Results
    wire [RESULT_CONT-1:0]  result_select;                                                     // Select Result to be read from Systolic Array and written to the memory 
    wire [RESULT_CONT-1:0]  initial_pe;                                                        // Select Result to be read from Systolic Array and written to the memory 
    wire [DW*M-1:0]         ifmap_fifo_systolic;                                               // Input Feature Map data From FIFO to Systolic Array Matrix Multiplier
    wire [WW*N-1:0]         weights_fifo_systolic;                                             // Filter Weights From FIFO to Systolic Array Matrix Multiplier
    wire [(N+M)-1:0]        read_enable;
    wire [(M+N)-1:0]        empty;                                                            // Empty signals from FIFOs
    wire [(M+N)-1:0]        full;                                                             // FIFOs full flags 
    
    wire [((WW*N)+(DW*M))-1:0]         filter_ifmap;                                                    // Filter  Weights & INFmap (Concatenated)
    
    assign filter_ifmap = {filter_weights,ifmap_data};
    assign empty_fifos = & empty; 
    assign full_filters = full[(M+N)-1:M];
    assign full_ifmap = full[M-1:0];
    assign read_enable = {(N+M){rd_en}};
    assign result_select = (en_sel_init)? pe_sel_init : 'd0 ;
    assign initial_pe = (en_sel_init)? 'd0: pe_sel_init;
    assign wr_en_sign = (wr_en)? wr_en_ctrl : 'd0;                                              // If wr_en, enable write to the FIFOs, else, disable
    
    matrix_mul_top#(.DW(DW),.WW(WW), .N(N),.M(M),.OUTWIDTH(OUTWIDTH))        matrix_multiplier  (.pic_data_in(ifmap_fifo_systolic),.filter_weight(weights_fifo_systolic),.clk(clk),.rst_n(rst_n),
                                                                                                 .refresh_sig_bus(initialize_bus_sign),.pypas_pic(),.pypas_filter(),.acc_result(acc_result));
    
    /* Writing process is processing sequentially. In other words, we need to fill the data in the IFMap FIFOs sequentially and then the same procedures for the Filters' FIFOs. 
       We have a write enable decoder to control every FIFO in the design. The same wr_en signals it also controls the path of the data (weight/ifmap) from the DEMUX.         
       Reading from the FIFOs and pushing the data is pretty much easy task. Only one enable read signals that goes to every FIFO in the design and let it push the data.
       Full flags are needed to make sure that all the weights and data have been written to every corresponding FIFO. Empty flag (one pin) means that we have finished all the 
       process of the systolic array. It means also that now we can write another data to the FIFOs and restart the systolic array process. Refresh or initializing signals are
       required in the second iteration of the systolic array operation; to make sure that we are accumulating the right data at the right time.  */
    
    /* Writing control modules are here */
    demux #(.DW(WW),.N(N+M))  in_data_demux  (.in_a(data_in),.select(fifo_sel),.out_a(filter_ifmap));               // Filters/IFMap DEMUX
    fifo_array#(.DW(DW),.DEPTH(DEPTH),.WW(WW),.M(M),.N(N)) FIFOs  ( .in_data(filter_ifmap),.clk(clk),.rst_n(rst_n),.wr_en(wr_en_sign),.rd_en(read_enable),.empty(empty),.full(full),.out_ifmap(ifmap_fifo_systolic),.out_filters(weights_fifo_systolic));
    decoder#(.OUT_DW(M+N))  wr_en_dec     (.in_data(fifo_sel),.dec_out(wr_en_ctrl));                                // Write  Enable Signals
    
    
    /* Reading control modules are here */
    mux #(.BW(OUTWIDTH),.N(N*M))  result_mux   (.in_a(acc_result),.select(result_select),.out_a(result));
    decoder#(.OUT_DW(N*M)) initial_decoder (.in_data(initial_pe),.dec_out(initialize_bus_sign));                      // Initializing Signals Decoder
    
    
    
endmodule

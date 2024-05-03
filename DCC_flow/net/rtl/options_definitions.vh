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


//`define ASM
//`define HIGH_REG
`define ALM                         // Choose the multiplier type 
`define ROUN_WIDTH 1                // Choose rounding width of the IFMap of Weight. Valid in ROBA multiplier 
`define NIBBLE_WIDTH 4              // Choose nibble width. Important for ASM multiplier. Please ==> use only 4 for now 
`define DW 32                        // Choose IFMAP bitwidth 
`define WW 32                        // Choose Filter weights bitwdith
`define M 16                         // Choose M dimensions of the systolic array = Number of rows = Number of units in each column 
`define N 16                         // Choose N dimensions of the systolic array = Number of columns = Number of units in each row
`define MULT_DW 16                   // Choose accurate part of approximate multipliers = Valid in DRUM and DRALM
`define ADDER_PARAM 16               // Choose Adder approximation parameter = Valid for all approximate adders = inaccurate part 
`define VBL 16

`define ACCURATE_ACCUMULATE 


`ifdef NORMAL_TPU
    `define ACCURATE_ACCUMULATE
`endif 
    
//`define SA_ADDER                    // Choose the accumulator approximation 


`ifdef MITCHELL
    `define SHARED_PRE_APPROX
`elsif ALM_MAA3
    `define SHARED_PRE_APPROX
`elsif ALM_SOA
    `define SHARED_PRE_APPROX
`elsif ALM_LOA
    `define SHARED_PRE_APPROX
`elsif ROBA
    `define SHARED_PRE_APPROX
`elsif DRUM_APTPU
    `define SHARED_PRE_APPROX
`elsif ALM
    `define SHARED_PRE_APPROX
`elsif DRALM
    `define SHARED_PRE_APPROX
`elsif ASM
    `define SHARED_PRE_APPROX
 `endif 



`ifdef ALM_MAA3
    `define ALM
`elsif ALM_SOA
    `define ALM
`elsif ALM_LOA
    `define ALM
 `endif     

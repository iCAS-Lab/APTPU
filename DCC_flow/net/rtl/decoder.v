`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 02/26/2021 04:24:40 PM
// Design Name: 
// Module Name: decoder
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


module decoder#( 
    parameter OUT_DW = 8,
    parameter IN_DW = $clog2(OUT_DW)
    )          ( 
    input [IN_DW-1:0]   in_data,
    output [OUT_DW-1:0] dec_out
    );
   
    assign dec_out = (1<<in_data);
         
endmodule

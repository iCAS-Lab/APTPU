`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 02/26/2021 04:24:08 PM
// Design Name: 
// Module Name: top_demux
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


module top_demux#( 
        parameter DW = 8,
        parameter N = 8,
        parameter SEL = $clog2(N)
    )             (
        input [DW-1:0] in_a,
        input [SEL-1:0] select,
        output reg [(DW*N)-1:0] out_a
    );
    
    integer i;
    
    always @(in_a or select) begin 
        out_a = 'd0;
        for (i=0;i<N;i=i+1) begin
            if (select == i)
                out_a[((i+1)*DW)-1 -:DW] = in_a;
        end
    end
    
endmodule 
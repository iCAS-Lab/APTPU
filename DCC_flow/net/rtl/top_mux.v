`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 02/26/2021 04:25:47 PM
// Design Name: 
// Module Name: top_mux
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


module top_mux#(
    parameter BW = 8,
    parameter N = 8,
    parameter SEL = $clog2(N)
    )          (
    input      [BW*N-1:0] in_a,
    input      [SEL-1:0] select,
    output reg [BW-1:0] out_a
    );
    
    integer i;
    //reg b = {{SEL}{'d0}};
    always @(in_a or select) begin 
        out_a = 'd0;
        for (i=0;i<N;i=i+1) begin
            if (select ==i)
               // b=i;
                out_a = in_a[((i+1)*BW)-1-:BW];
        end
   end
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 02/26/2021 04:28:27 PM
// Design Name: 
// Module Name: LOD
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


module LOD#(
    parameter BW = 8
    )       (
    input      [BW-1:0] in_a,
    output reg [BW-1:0] out_a
    );
    
    integer k; 
    reg [BW-1:0] w;
    
    always @(*) begin
        out_a[BW-1] = in_a[BW-1]; 
        w[BW-1] = ~ in_a[BW-1]; 
        for (k=BW-2; k>=0; k=k-1) begin
            w[k] = in_a[k] ? 1'b0 : w[k+1];
            out_a[k] = w[k+1] & in_a [k]; 
        end
    end
    
endmodule

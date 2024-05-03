`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/25/2023 01:53:07 AM
// Design Name: 
// Module Name: BAM_top
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

module BAM_top #(parameter DW = 8,WW = 8 ,max_bw = (DW>WW)? DW:WW, LOG2_WIDTH =$clog2(max_bw), VBL = 1)

( input    [DW-1:0] 	 A,
  input    [WW-1:0]      B, 
  output   [(DW+WW)-1:0] R       
) ;


generate 
    if(max_bw == 'd16)
        BAM_16x16 #(.LOG2_WIDTH(LOG2_WIDTH),.VBL(VBL )) BAM_16x16 ( .A(A),.B(B),.R(R));

    else if(max_bw == 'd8)
        BAM_8x8 #(.LOG2_WIDTH(LOG2_WIDTH),.VBL(VBL )) BAM_8x8 (.A(A),.B(B),.R(R) );
 
    else if(max_bw == 'd4)
        BAM_4x4 #(.LOG2_WIDTH(LOG2_WIDTH),.VBL(VBL )) BAM_4x4 (.A(A),.B(B),.R(R));
endgenerate


endmodule
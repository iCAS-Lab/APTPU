`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/26/2023 03:32:37 AM
// Design Name: 
// Module Name: EIM
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


module EIM #(parameter DW=8, WW=8, max_bw = (DW>WW)? DW:WW)
( 
  input    [DW-1:0] 	 A,
  input    [WW-1:0]      B, 
  output   [(DW+WW)-1:0] R         
) ;

 
generate  
    if(max_bw == 'd4)

	   EIM4x4 EIM4x4(.A(A),.B(B),.R(R));
    
    else if(max_bw == 'd8)

	   EIM8x8 EIM8x8(.A(A),.B(B),.R(R));
	 
	else if(max_bw == 'd16)

	   EIM16x16 EIM16x16(.A(A),.B(B),.R(R));
	   
	else if(max_bw == 'd32)
       
        EIM32x32 EIM32x32(.A(A),.B(B),.R(R));
            
	 
	 
endgenerate

endmodule
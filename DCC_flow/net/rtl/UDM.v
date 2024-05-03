`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity 
// 
// Create Date: 06/28/2023 02:14:40 AM
// Design Name: 
// Module Name: UDM
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


module UDM #(parameter DW=8, WW=8, max_bw = (DW>WW)? DW:WW)
( 
  input    [DW-1:0] 	 A,
  input    [WW-1:0]      B, 
  output   [(DW+WW)-1:0] R   
//output  wire [2*WIDTH-1:0]	Z       
) ;

 
 generate 
   if(max_bw == 'd2)
     // code 1 : 2x2 Multiplier
        UDM_BB UDM2x2 (.A(A),.B(B),.Z(R));
	 
   else	if(max_bw == 'd4)
     // code 2 : 4x4 Multiplier
        UDM_4x4 UDM_4x4 (.A(A),.B(B),.Z(R));
	 
   else if(max_bw == 'd8)
     // code 3 : 8x8 Multiplier
	    UDM_8x8 UDM_8x8(.A(A),.B(B),.Z(R));
	 
   else if(max_bw == 'd16)
     // code 4 : 16x16 Multiplier
	    UDM_16x16 UDM_16x16 (.A(A),.B(B),.Z(R));
		
   else if(max_bw == 'd32)
     // code 5 : 32x32 Multiplier
	    UDM_32x32 UDM_32x32 (.A(A),.B(B),.Z(R));
	 
	 
endgenerate

endmodule
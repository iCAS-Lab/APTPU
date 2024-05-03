`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/28/2023 02:14:40 AM
// Design Name: 
// Module Name: UDM_8x8
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


module UDM_8x8  #(parameter	WIDTH = 8) 


( input   wire [WIDTH-1:0] 	 A,B, 
  output  wire [2*WIDTH-1:0] Z       
) ;


wire	[WIDTH/2-1:0]	AL,AH,BL,BH ;
wire	[WIDTH-1:0]		Z1,Z2,Z3,Z4 ;


assign	AL = A[WIDTH/2-1:0] ;  //LSBs
assign	AH = A[WIDTH-1:WIDTH/2] ; //MSBs

assign	BL = B[WIDTH/2-1:0] ;  //LSBs
assign	BH = B[WIDTH-1:WIDTH/2] ; //MSBs

	 
		UDM_4x4 AL_BL (.A(AL),.B(BL),.Z(Z1)	);
		
		UDM_4x4 AH_BL (.A(AH),.B(BL),.Z(Z2));
		
		UDM_4x4 AL_BH (.A(AL),.B(BH),.Z(Z3));
		
		UDM_4x4 AH_BH (.A(AH),.B(BH),.Z(Z4));
    
	assign	Z = Z1 + (Z2 << 4) + (Z3 << 4) + (Z4 << 8) ;
		 
endmodule
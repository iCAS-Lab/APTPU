`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/26/2023 04:14:09 AM
// Design Name: 
// Module Name: EIM32x32
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


module EIM32x32 #(parameter WIDTH = 32)
(
input	wire	[WIDTH-1:0]		A,B,
output	wire	[2*WIDTH-1:0]		R
);

wire	[WIDTH/2-1:0]	AL,AH,BL,BH ;
wire	[WIDTH-1:0]		R1,R2,R3,R4 ;


assign	AL = A[WIDTH/2-1:0] ;  //LSBs
assign	AH = A[WIDTH-1:WIDTH/2] ; //MSBs

assign	BL = B[WIDTH/2-1:0] ;  //LSBs
assign	BH = B[WIDTH-1:WIDTH/2] ; //MSBs

	 
		EIM16x16 #(WIDTH/2) AL_BL		(
		.A(AL),//Al
		.B(BL),//Bl
		.R(R1)
		);
		
		EIM16x16 #(WIDTH/2) AH_BL
		(
		.A(AH), //Ah
		.B(BL), //Bl
		.R(R2)
		);
		
		EIM16x16 #(WIDTH/2) AL_BH
		(
		.A(AL),//Al
		.B(BH),//Bh
		.R(R3)
		);
		
		EIM16x16 #(WIDTH/2) AH_BH
		(
		.A(AH),//Ah
		.B(BH),//Bh
		.R(R4)
		);
    
	assign	R = R1 + (R2 << WIDTH/2) + (R3 << WIDTH/2) + (R4 << WIDTH) ;
		 
endmodule

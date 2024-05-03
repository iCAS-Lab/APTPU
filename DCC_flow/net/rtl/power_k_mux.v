`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/28/2023 12:47:35 AM
// Design Name: 
// Module Name: power_k_mux
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


module power_k_mux #(parameter WIDTH = 16, ROUN_WIDTH = 0, LOG2_WIDTH = 4) //WIDTH --> input data width
(	
input			[WIDTH+ROUN_WIDTH-1:0]	IN, //+ROUN_WIDTH because it may get 16 or 17 input bits depending on the instancation
input			[LOG2_WIDTH-1:0]		K, //index of first one
output		    [2*WIDTH-1:0]			OUT_2K // out data 
);



assign OUT_2K = IN << K;

/*

/// this mux mutliply the input by pow(2,k)
always@(*)
begin:	always_begin

if(WIDTH == 'd16)
begin:	if_16

case(K)
	'd0:	OUT_2K = IN ;
	'd1:	OUT_2K = IN << 1 ;
	'd2:	OUT_2K = IN << 2 ;
	'd3:	OUT_2K = IN << 3 ;
	'd4:	OUT_2K = IN << 4 ;
	'd5:	OUT_2K = IN << 5 ;
	'd6:	OUT_2K = IN << 6 ;
	'd7:	OUT_2K = IN << 7 ;
	'd8:	OUT_2K = IN << 8 ;
	'd9:	OUT_2K = IN << 9 ;
	'd10:	OUT_2K = IN << 10 ;
	'd11:	OUT_2K = IN << 11 ;
	'd12:	OUT_2K = IN << 12 ;
	'd13:	OUT_2K = IN << 13 ;
	'd14:	OUT_2K = IN << 14 ;
	'd15:	OUT_2K = IN << 15 ;
endcase

end:	if_16

else if(WIDTH == 'd8)
begin:	if_8

case(K)
	'd0:	OUT_2K = IN ;
	'd1:	OUT_2K = IN << 1 ;
	'd2:	OUT_2K = IN << 2 ;
	'd3:	OUT_2K = IN << 3 ;
	'd4:	OUT_2K = IN << 4 ;
	'd5:	OUT_2K = IN << 5 ;
	'd6:	OUT_2K = IN << 6 ;
	'd7:	OUT_2K = IN << 7 ;
endcase

end: if_8

else if(WIDTH == 'd4)
begin:	if_4

case(K)
	'd0:	OUT_2K = IN ;
	'd1:	OUT_2K = IN << 1 ;
	'd2:	OUT_2K = IN << 2 ;
	'd3:	OUT_2K = IN << 3 ;
endcase

end: if_4

end:	always_begin

*/ 

endmodule
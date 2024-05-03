`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/28/2023 12:47:35 AM
// Design Name: 
// Module Name: shift_left_mux
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


//this mux shift the input to the left to see if the next bit to the first one is equal zero or one to round the operand

module shift_left_mux #(parameter WIDTH = 16,ROUN_WIDTH = 0, LOG2_WIDTH = 4) //WIDTH --> input data width
(
input	wire	[WIDTH+ROUN_WIDTH-1:0]	Operand, // input data
input	wire	[LOG2_WIDTH-1:0]	K, //index of first one
output			[WIDTH-1:0]			Operand_SL //shift left-ed operand
);


assign Operand_SL = Operand << (WIDTH-K);

/*
always@(*)
begin:	always_begin

if(WIDTH == 'd16)
begin:	if_16

case(WIDTH-K)
	'd0:	Operand_SL = Operand ;
	'd1:	Operand_SL = Operand << 1 ;
	'd2:	Operand_SL = Operand << 2 ;
	'd3:	Operand_SL = Operand << 3 ;
	'd4:	Operand_SL = Operand << 4 ;
	'd5:	Operand_SL = Operand << 5 ;
	'd6:	Operand_SL = Operand << 6 ;
	'd7:	Operand_SL = Operand << 7 ;
	'd8:	Operand_SL = Operand << 8 ;
	'd9:	Operand_SL = Operand << 9 ;
	'd10:	Operand_SL = Operand << 10 ;
	'd11:	Operand_SL = Operand << 11 ;
	'd12:	Operand_SL = Operand << 12 ;
	'd13:	Operand_SL = Operand << 13 ;
	'd14:	Operand_SL = Operand << 14 ;
	'd15:	Operand_SL = Operand << 15 ;
endcase

end:	if_16

else if(WIDTH == 'd8)
begin:	if_8

case(WIDTH-K)
	'd0:	Operand_SL = Operand ;
	'd1:	Operand_SL = Operand << 1 ;
	'd2:	Operand_SL = Operand << 2 ;
	'd3:	Operand_SL = Operand << 3 ;
	'd4:	Operand_SL = Operand << 4 ;
	'd5:	Operand_SL = Operand << 5 ;
	'd6:	Operand_SL = Operand << 6 ;
	'd7:	Operand_SL = Operand << 7 ;
endcase

end: if_8

else if(WIDTH == 'd4)
begin:	if_4

case(WIDTH-K)
	'd0:	Operand_SL = Operand ;
	'd1:	Operand_SL = Operand << 1 ;
	'd2:	Operand_SL = Operand << 2 ;
	'd3:	Operand_SL = Operand << 3 ;
endcase

end: if_4

end:	always_begin

*/


endmodule
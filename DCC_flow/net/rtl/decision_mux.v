`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/28/2023 12:47:35 AM
// Design Name: 
// Module Name: decision_mux
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


// this mux decide if the operand will be rounded up or down

module decision_mux #(parameter WIDTH = 16, ROUN_WIDTH = 0, LOG2_WIDTH = 4) //Decide to shift left by one or no according to bit at k-1
(
input	wire	[2*WIDTH-1:0]				IN, //2**k 
input	wire								decision_bit, //bit postion k-1 in multiplicant
output	reg		[2*WIDTH+ROUN_WIDTH-1:0]	IN_r	//(rounded IN) width is larger because the number may be rounded to 2**16
);


always@(*)
begin
if(decision_bit)
	IN_r = IN << 1 ; //multiplied by 2
else
	IN_r = IN ;
end

endmodule
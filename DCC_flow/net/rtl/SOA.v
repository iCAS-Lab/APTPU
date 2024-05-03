`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2023 04:22:23 AM
// Design Name: 
// Module Name: SOA
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

module SOA #(parameter LOG2_WIDTH = 4, WIDTH = 2**LOG2_WIDTH, M = 8) //M is SOA parameter
(
input	wire		[LOG2_WIDTH+WIDTH-2:0]	OP1,OP2,
output	wire		[WIDTH-2:0]				X,
output	wire		[LOG2_WIDTH:0]			K
);

wire	[LOG2_WIDTH+WIDTH-1:0]	sum ;
wire							Cin ;
// declare for generate loop variable
genvar i ; 

  generate
    for ( i=0 ; i < M ; i = i + 1 )
	  begin
        assign sum[i] = 1'b1 ;
	  end
  endgenerate

assign	Cin = OP1[M-1] & OP2[M-1] ;

assign	sum[LOG2_WIDTH+WIDTH-1:M] = OP1[LOG2_WIDTH+WIDTH-2:M] + OP2[LOG2_WIDTH+WIDTH-2:M] + Cin;

assign	X = sum[WIDTH-2:0] ;
assign	K = sum[LOG2_WIDTH+WIDTH-1:WIDTH-1] ;

endmodule
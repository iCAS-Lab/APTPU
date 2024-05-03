`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/28/2023 02:14:40 AM
// Design Name: 
// Module Name: UDM_BB
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

module UDM_BB #(parameter WIDTH = 2) //UDM Building block
(
    input  wire   [WIDTH-1:0]     A,B,     //input
    output reg   [(2*WIDTH)-1:0] Z        //output
);

genvar i;

generate
    for (i = 0; i < WIDTH; i = i + 1) begin: GEN_BLK
        always @* begin
            Z[2*i] = A[i] & B[i];  // Assign Z[2*i] with A[i] & B[i]

            // Assign Z[2*i + 1] with A[i+1] & B[i] | A[i] & B[i+1] for i < WIDTH-1
            if (i < WIDTH - 1) 
                Z[2*i + 1] = (A[i+1] & B[i]) | (A[i] & B[i+1]);
        end
    end
endgenerate

endmodule



/*
module UDM_BB #(parameter WIDTH = 2) //UDM Building block
(
input	wire	[WIDTH-1:0]		A,B,	 //input
output	wire	[2*WIDTH-1:0]	Z		 //output
);

assign	Z[0] = A[0] & B[0] ;

assign	Z[1] = (A[1] & B[0]) | (A[0] & B[1]) ;

assign	Z[2] = A[1] & B[1] ;

assign	Z[3] = 0 ;

endmodule
*/
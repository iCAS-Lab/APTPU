`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/28/2023 12:47:35 AM
// Design Name: 
// Module Name: shifter
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


module shifter #(parameter WIDTH = 16, ROUN_WIDTH = 0, LOG2_WIDTH = 4) //WIDTH --> input data width
(
input	wire	[WIDTH-1:0]					X,
input	wire	[WIDTH-1+ROUN_WIDTH:0]		Y,
input	wire	[LOG2_WIDTH-1:0]			K, 		// K of X
output	wire	[2*WIDTH+ROUN_WIDTH-1:0]	Xr_Y	//Xr*Y
);



	// power_k_mux wires //
wire	[2*WIDTH-1:0]		OUT_2K_wire ;

	// shift_left_mux //
wire	[WIDTH-1:0]		Operand_SL_wire ;


power_k_mux #(.ROUN_WIDTH(ROUN_WIDTH),.WIDTH(WIDTH), .LOG2_WIDTH(LOG2_WIDTH))power_k_mux(.IN(Y),.K(K),.OUT_2K(OUT_2K_wire));

shift_left_mux #(.WIDTH(WIDTH), .LOG2_WIDTH(LOG2_WIDTH))shift_left_mux(.Operand(X),.K(K),.Operand_SL(Operand_SL_wire));


decision_mux #(.ROUN_WIDTH(ROUN_WIDTH),.WIDTH(WIDTH), .LOG2_WIDTH(LOG2_WIDTH)) decision_mux(.IN(OUT_2K_wire),.decision_bit(Operand_SL_wire[WIDTH-1]),.IN_r(Xr_Y));

endmodule

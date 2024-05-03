`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/28/2023 12:47:35 AM
// Design Name: 
// Module Name: Rounding_unit
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


module Rounding_unit #(parameter WIDTH = 16,ROUN_WIDTH = 0, LOG2_WIDTH = 4) //WIDTH --> input data width
(
input	wire	[WIDTH-1:0]		A,
output	wire	[WIDTH:0]		Ar	//Rounded A
);


	// LOD wires //
wire	[LOG2_WIDTH-1:0]	K_wire;

	// base2_mux wires //
wire	[WIDTH-1:0]			OUT_2K_wire ;

	// shift_left_mux //
wire	[WIDTH-1:0]			Operand_SL_wire ;
wire [WIDTH-1:0] lod_wire;                     // LOD of A-Operand output

//LOD	#(.WIDTH(WIDTH), .LOG2_WIDTH(LOG2_WIDTH))LOD (.Operand(A),.K(K_wire));

LOD #(.BW(WIDTH)) LOD (.in_a(A),.out_a(lod_wire));
P_Encoder #(.BW(WIDTH)) PE_B (.in_a(lod_wire),.out_a(K_wire));

base2_mux #(.WIDTH(WIDTH), .LOG2_WIDTH(LOG2_WIDTH)) base2_mux(.K(K_wire),.OUT_2K(OUT_2K_wire));

shift_left_mux #(.WIDTH(WIDTH), .LOG2_WIDTH(LOG2_WIDTH))shift_left_mux(.Operand(A),.K(K_wire),.Operand_SL(Operand_SL_wire));


decision_mux_Rounding #(.WIDTH(WIDTH), .LOG2_WIDTH(LOG2_WIDTH))decision_mux_Rounding(.IN(OUT_2K_wire),.decision_bit(Operand_SL_wire[WIDTH-1]),.IN_r(Ar));

endmodule
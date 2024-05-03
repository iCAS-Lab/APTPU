`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2023 04:24:12 PM
// Design Name: 
// Module Name: RoBA_A_pre_approximate
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


module RoBA_A_pre_approximate #(parameter A_BW = 32, B_BW = 32, ROUN_WIDTH = 1, max_bw = (A_BW>B_BW)? A_BW:B_BW, bw_lg = $clog2(max_bw))

(
                  input	    [A_BW-1:0]	        A,
                  //output [A_BW-1:0]	A_wired_copy,       // Copied version of A to be send to Shifters
                  output    [$clog2(A_BW)-1:0]  K_wireA,    // LOD A wire
                  output    [A_BW:0]	        Ar_wire          // Rounded A (coming from Rounding Unit) 
                  //input  [B_BW-1:0]    B,
                  //output [(A_BW+B_BW):0]	R
);


//assign A_wired_copy = A;
	// LOD A wires //
//wire	[$clog2(A_BW)-1:0]	K_wireA ;

	// LOD A wires //
//wire	[$clog2(B_BW)-1:0]	K_wireB ;

	// shifter BrxA wires //
//wire	[(A_BW+B_BW)-1:0]	BrxA_wire ;

	// shifter ArxB wires //
//wire	[(A_BW+B_BW)-1:0]	ArxB_wire ;

	// shifter ArxB wires //
//wire	[(A_BW+B_BW):0]	ArxBr_wire ;

	// Rounding Unit wires //
//wire	[A_BW:0]	Ar_wire ;

	// adder wires //
//wire	[(A_BW+B_BW):0] R_wire;

wire [A_BW-1:0] lod_AO;                     // LOD of A-Operand output
//wire [B_BW-1:0] lod_BO;                     // LOD of A-Operand output


//LOD #(.WIDTH(WIDTH), .LOG2_WIDTH(LOG2_WIDTH))LOD_A(.Operand(A),.K(K_wireA));

LOD #(.BW(A_BW)) LOD_A (.in_a(A),.out_a(lod_AO));
P_Encoder #(.BW(A_BW)) PE_A (.in_a(lod_AO),.out_a(K_wireA));

//LOD #(.WIDTH(WIDTH), .LOG2_WIDTH(LOG2_WIDTH))LOD_B(.Operand(B),.K(K_wireB));

//LOD #(.BW(B_BW)) LOD_B (.in_a(B),.out_a(lod_BO));
//P_Encoder #(.BW(B_BW)) PE_B (.in_a(lod_BO),.out_a(K_wireB));


//shifter #(.WIDTH(max_bw), .LOG2_WIDTH(bw_lg))BrxA(.X(B),.Y(A),.K(K_wireB),.Xr_Y(BrxA_wire));

//shifter #(.WIDTH(max_bw), .LOG2_WIDTH(bw_lg))ArxB(.X(A),.Y(B),.K(K_wireA),.Xr_Y(ArxB_wire));

Rounding_unit #(.WIDTH(max_bw), .LOG2_WIDTH(bw_lg))Rounding_unit (.A(A),.Ar(Ar_wire)); //to get Ar
                                            

//shifter #(.WIDTH(max_bw),.ROUN_WIDTH(ROUN_WIDTH), .LOG2_WIDTH(bw_lg))ArxBr(.X(B),.Y(Ar_wire),.K(K_wireB),.Xr_Y(ArxBr_wire));

//adder_RoBA #(.WIDTH(max_bw), .LOG2_WIDTH(bw_lg))adder(.A(ArxB_wire),.B(BrxA_wire),.R(R_wire));

//subtractor #(.WIDTH(max_bw), .LOG2_WIDTH(bw_lg))subtractor(.A(R_wire),.B(ArxBr_wire),.R(R));



endmodule
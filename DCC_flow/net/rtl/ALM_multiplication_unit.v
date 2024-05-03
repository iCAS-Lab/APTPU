`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2023 05:19:36 PM
// Design Name: 
// Module Name: ALM_multiplication_unit
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


module ALM_multiplication_unit #(parameter A_BW = 32, B_BW = 32, LOG2_WIDTH = $clog2(A_BW), WIDTH = 2**LOG2_WIDTH, M = 6)

(
    //input	[A_BW-1:0]		   A,
    input   [$clog2(A_BW)-1:0] log_a,
    input	[A_BW-2:0]	       log_format_a, 
    input   [$clog2(B_BW)-1:0] log_b,
    input	[B_BW-2:0]         log_format_b,
    
    //input   [B_BW-1:0]      B,
    output	    	[(A_BW+B_BW)-1:0]	mult_product
);

//wire [$clog2(A_BW)-1:0] log_a;              // Log of A-Operand (P_Encoder output)
//wire [$clog2(B_BW)-1:0] log_b;              // Log of B-Operand (P_Encoder output)
//wire	[A_BW-2:0]	log_format_a;
//wire	[B_BW-2:0]  log_format_b ;

wire	[WIDTH-2:0]				fraction_sum ;

wire [$clog2(A_BW):0] exp_sum;            // Exponents sum 
//wire [A_BW-1:0] lod_AO;                     // LOD of A-Operand output
//wire [B_BW-1:0] lod_BO;                     // LOD of A-Operand output


//LOD #(.BW(A_BW)) LOD_A (.in_a(A),.out_a(lod_AO));
//P_Encoder #(.BW(A_BW)) PE_A (.in_a(lod_AO),.out_a(log_a));

//LOD #(.BW(A_BW)) LOD_B (.in_a(B),.out_a(lod_BO));
//P_Encoder #(.BW(A_BW)) PE_B (.in_a(lod_BO),.out_a(log_b));

//BLC #(.LOG2_WIDTH($clog2(A_BW))) BLCa (.Operand(A),.K(log_a),.log_formt(log_format_a));
//BLC #(.LOG2_WIDTH($clog2(B_BW))) BLCb (.Operand(B),.K(log_b),.log_formt(log_format_b));

Adder #(.LOG2_WIDTH($clog2(A_BW))) Adder (.A(log_format_a),.B(log_format_b),.log_a(log_a),.log_b(log_b),.OPs_sum(fraction_sum),.log_sum(exp_sum));
LBC #(.LOG2_WIDTH($clog2(B_BW))) LBC (.fraction(fraction_sum),.exp_sum(exp_sum),.result(mult_product));

endmodule

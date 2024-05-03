`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Engineer: Mohammed E. Elbtity
// 
// Module Name: mherloa_adder
//////////////////////////////////////////////////////////////////////////////////


module mherloa_adder #(parameter ADDER_LENGTH = 32, IMPRECISE_PART = 16)
(
    // Adder's inputs
    input  wire [ADDER_LENGTH-1:0] a,
    input  wire [ADDER_LENGTH-1:0] b,
    
    // Adder's output
    output wire  [ADDER_LENGTH:0]   sum
);

wire [ADDER_LENGTH: IMPRECISE_PART-1] W1 ; 
wire xoring_p_1;
wire anding_p_2;
wire anding_p_1_2;
wire nanding_p_1_2;

assign W1[IMPRECISE_PART-1] = a[IMPRECISE_PART-1] & b[IMPRECISE_PART-1];

// Input to imprecise part of the adder
assign xoring_p_1    = a[IMPRECISE_PART-1] ^ b[IMPRECISE_PART-1];
assign anding_p_2    = a[IMPRECISE_PART-2] & b[IMPRECISE_PART-2];
assign anding_p_1_2  = xoring_p_1 & anding_p_2;
assign nanding_p_1_2 = ~(anding_p_2 & (~xoring_p_1));

generate										// This is the modification we did together with Hasib // Essa
	if (IMPRECISE_PART > 4)
		assign sum[IMPRECISE_PART-5:0] = {IMPRECISE_PART-4{1'b1}};
endgenerate 

assign sum[IMPRECISE_PART-4] = a[IMPRECISE_PART-4] | b[IMPRECISE_PART-4] | anding_p_1_2;
	  
assign sum[IMPRECISE_PART-3] = a[IMPRECISE_PART-3] | b[IMPRECISE_PART-3] | anding_p_1_2;
      
assign sum[IMPRECISE_PART-2] = (a[IMPRECISE_PART-2] | b[IMPRECISE_PART-2]) & nanding_p_1_2;
	  
assign sum[IMPRECISE_PART-1] = xoring_p_1 | anding_p_2;

genvar i; 
generate 
	for (i= IMPRECISE_PART ; i < ADDER_LENGTH ; i=i+1) begin 
        full_adder FA_k  (.a(a[i]) , .b(b[i]), .carry_in(W1[i-1]), .s(sum[i]) , .carry_out(W1[i])); 
		end
endgenerate 
  
assign sum[ADDER_LENGTH] = W1[ADDER_LENGTH-1];
endmodule
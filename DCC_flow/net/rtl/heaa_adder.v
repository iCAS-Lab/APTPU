`timescale 1ns / 1ps

module heaa_adder #(parameter ADDER_LENGTH = 32, IMPRECISE_PART = 16)
(
   
  
    // Adder's inputs
    input  wire [ADDER_LENGTH-1:0] a,
    input  wire [ADDER_LENGTH-1:0] b,
    
    // Adder's output
    output wire  [ADDER_LENGTH:0]   sum
);

wire [ADDER_LENGTH-1: IMPRECISE_PART-1] W1 ;

  assign W1[IMPRECISE_PART-1] = a[IMPRECISE_PART-1] & b[IMPRECISE_PART-1];
  
  assign sum[IMPRECISE_PART-2:0] = a[IMPRECISE_PART-2:0] | b[IMPRECISE_PART-2:0];
  
  assign sum[IMPRECISE_PART-1] = (W1[IMPRECISE_PART-1])?  1'b0 : (a[IMPRECISE_PART-1] | b[IMPRECISE_PART-1]);

  genvar i; 
  generate 
     for (i= IMPRECISE_PART ; i < ADDER_LENGTH ; i=i+1) begin 
         full_adder FA_k  (.a(a[i]) , .b(b[i]), .carry_in(W1[i-1]), .s(sum[i]) , .carry_out(W1[i])); 
     end
  endgenerate 
  
  assign sum[ADDER_LENGTH] = W1[ADDER_LENGTH-1];
endmodule
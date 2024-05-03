`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2023 02:16:39 AM
// Design Name: 
// Module Name: ASM_A_pre_approximate
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


module ASM_A_pre_approximate #(parameter WIDTH = 32, LOG2_WIDTH = $clog2(WIDTH), NIBBLE_WIDTH = 4, LOG2_NIBBLE_WIDTH = $clog2(NIBBLE_WIDTH),NIBBLES = WIDTH/4 )
(
input      [WIDTH-1:0]      A,
output reg [(LOG2_NIBBLE_WIDTH*NIBBLES)-1:0] SL_out, 
output reg [(LOG2_NIBBLE_WIDTH*NIBBLES)-1:0] SEL_out
);


wire    [LOG2_NIBBLE_WIDTH-1:0]  SEL [NIBBLES-1:0], SL [NIBBLES-1:0];

genvar i;

generate
    for (i=0; i<NIBBLES; i=i+1) 
        begin : nibble_processing
            control_unit #(.LOG2_WIDTH(LOG2_WIDTH), .LOG2_NIBBLE_WIDTH(LOG2_NIBBLE_WIDTH)) control_unit_inst (.operand(A[i*4+3:i*4]), .SEL(SEL[i]), .SL(SL[i]));
        end
endgenerate


generate                // Unpacking the SEL and SL wire memory (2D array) into a single vector 
    for (i=0; i<NIBBLES;i=i+1) begin
        always@(*) begin
            SL_out[(LOG2_NIBBLE_WIDTH*(i+1))-1:i*LOG2_NIBBLE_WIDTH] = SL[i];
            SEL_out[(LOG2_NIBBLE_WIDTH*(i+1))-1:i*LOG2_NIBBLE_WIDTH] = SEL[i];
        end
    end
endgenerate 


endmodule


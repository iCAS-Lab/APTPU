`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/25/2023 11:53:51 PM
// Design Name: 
// Module Name: Dynamic_truncation
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


`define GEN 
module Dynamic_truncation #(
    parameter BW = 16,
    parameter MULT_DW = 6                       
    )        (
    
    `ifdef GEN
        input [BW-1:0] in_a,
        input [$clog2(BW)-1:0] select, 
        output reg [MULT_DW:0] out
    `else 
        input [7:0] in_a,
        input [2:0] select,
        output reg [1:0] 
    `endif 
    
    );
    
    `ifdef GEN
        integer k; 
        always @(*) begin 
            out = 'b0;
            for (k=MULT_DW; k <(BW); k=k+1) begin : mux_gen_blk
                if(select == k[$clog2(BW)-1:0]) 
                    out = in_a [k -: (MULT_DW+1)]; 
            end
        end
    `else 
        always @(*) begin 
            case (select)        // synopsys full_case parallel_case 
                3'd4: out = [in_a[3],in_a[2]};
                3'd5: out = {in_a[4],in_a[3]} ; 
                3'd6: out = {in_a[5],in_a[4]};
                3'd7: out = [in_a[6],in_a[5]};
                default: out = 2'b00;
            endcase
        end    
    `endif 
        
endmodule

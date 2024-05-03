`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iCAS Lab, University of South Carolina  
// Engineer: Mohammed E. Elbtity
// 
// Create Date: 06/15/2023 06:01:04 AM
// Design Name: 
// Module Name: shift_unit
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


module shift_unit #(parameter LOG2_WIDTH = 4, WIDTH = 2**LOG2_WIDTH, WEIGHT_NIBBLE = 0,
								 LOG2_NIBBLE_WIDTH = 2, NIBBLE_WIDTH = 2**LOG2_NIBBLE_WIDTH)
(
input	wire	[WIDTH+2:0]					IX,	// Selected alphabet 
input	wire	[LOG2_NIBBLE_WIDTH-1:0]		SL, // Shift Vlue,
//output	reg		[2*WIDTH-1:0]				IX_SL,	// Selected alphabet
output			[2*WIDTH-1:0]				IX_SL	// Selected alphabet
);



assign IX_SL = IX << (WEIGHT_NIBBLE + SL);

//always@(*)
//begin

//IX_SL = 'd0 ;

//if(WEIGHT_NIBBLE == 'd0)
//begin
//	case(SL)                
//	'd0:	IX_SL = IX ;
//	'd1:	IX_SL = IX << 1 ;
//	'd2:	IX_SL = IX << 2 ;
//	'd3:	IX_SL = IX << 3 ;
//	endcase
//end

//else if(WEIGHT_NIBBLE == 'd4)
//	begin
//		case(SL)                
//		'd0:	IX_SL = IX << 4 ;
//		'd1:	IX_SL = IX << 5 ;
//		'd2:	IX_SL = IX << 6 ;
//		'd3:	IX_SL = IX << 7 ;
//		endcase
//	end
	
//else if(WEIGHT_NIBBLE == 'd8)
//	begin
//		case(SL)                
//		'd0:	IX_SL = IX << 8 ;
//		'd1:	IX_SL = IX << 9 ;
//		'd2:	IX_SL = IX << 10 ;
//		'd3:	IX_SL = IX << 11 ;
//		endcase
//	end
	
//else if(WEIGHT_NIBBLE == 'd12)
//	begin
//		case(SL)                
//		'd0:	IX_SL = IX << 12 ;
//		'd1:	IX_SL = IX << 13 ;
//		'd2:	IX_SL = IX << 14 ;
//		'd3:	IX_SL = IX << 15 ;
//		endcase
//	end

//else if(WEIGHT_NIBBLE == 'd16)
//	begin
//		case(SL)                
//		'd0:	IX_SL = IX << 16 ;
//		'd1:	IX_SL = IX << 17 ;
//		'd2:	IX_SL = IX << 18 ;
//		'd3:	IX_SL = IX << 19 ;
//		endcase
//	end

//else if(WEIGHT_NIBBLE == 'd20)
//	begin
//		case(SL)                
//		'd0:	IX_SL = IX << 20 ;
//		'd1:	IX_SL = IX << 21 ;
//		'd2:	IX_SL = IX << 22 ;
//		'd3:	IX_SL = IX << 23 ;
//		endcase
//	end

//else if(WEIGHT_NIBBLE == 'd24)
//	begin
//		case(SL)                
//		'd0:	IX_SL = IX << 24 ;
//		'd1:	IX_SL = IX << 25 ;
//		'd2:	IX_SL = IX << 26 ;
//		'd3:	IX_SL = IX << 27 ;
//		endcase
//	end

//else if(WEIGHT_NIBBLE == 'd28)
//	begin
//		case(SL)                
//		'd0:	IX_SL = IX << 28 ;
//		'd1:	IX_SL = IX << 29 ;
//		'd2:	IX_SL = IX << 30 ;
//		'd3:	IX_SL = IX << 31 ;
//		endcase
//	end				


//end

endmodule
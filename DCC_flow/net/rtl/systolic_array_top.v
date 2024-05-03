// MIT License
// 
// Copyright (c) 2021-2024 iCAS Lab
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// Company: iCAS Lab, University of South Carolina
// Engineer: Mohammed E. Elbtity
// Create Date: 04/05/2021 04:09:30 PM
// Design Name: 
// Module Name: systolic_array_top
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

`timescale 1ns / 1ps

`include "options_definitions.vh"

module systolic_array_top#(  
    parameter DW                = `DW,                                  // Datawidth = 1 Pixel = IFmap datawidth                           
    parameter WW                = `WW,                                  // Wights width = Filter weight datawidth
    parameter N                 = `N,                                  // Number of Units in each row
    parameter M                 = `M,                                  // Number of Units in each column
    parameter MULT_DW           = `MULT_DW,                                  // Accurate multiplier size 
    parameter DEPTH             = 64,                            // Depth of each FIFO
    parameter OUTWIDTH          = (DW+WW)+ $clog2(N),                 // Output width  
    parameter WR_EN_VEC         = $clog2(N+M),                        // Decoder input port width (Filters)
    parameter RESULT_CONT       = $clog2(N*M),
    parameter ADDER_PARAM       = `ADDER_PARAM,
    parameter ROUN_WIDTH        = `ROUN_WIDTH,
    parameter max_bw            = (DW>WW)? DW:WW,
    parameter bw_lg             = $clog2(max_bw), 
    parameter truncation_width  = MULT_DW+1,
    parameter NIBBLE_WIDTH      = `NIBBLE_WIDTH,
    parameter LOG2_NIBBLE_WIDTH = $clog2(NIBBLE_WIDTH),
    parameter VBL               = `VBL,
    parameter NIBBLES           = DW/4
    )                      (  
    input  [max_bw-1:0]       data_in,                               // Weights/IFMap input to Demux then to FIFOs
    output [OUTWIDTH-1:0]     result,                                // Results  from MUX
    input  [WR_EN_VEC-1:0]    fifo_sel,                              // Filters & IFMap FIFOs write enable (Inputs to decoder)
    //input  [WR_EN_VEC-1:0]    wr_en,                                                          // Filters & IFMap FIFOs write enable (Inputs to decoder)
    input                     wr_en,
    input                     clk,rst_n,                              
    input                     rd_en,                                 // FIFOs Read Enable
    input                     clear,                                 // Clears all Accumulators' data
//    input  [RESULT_CONT-1:0]  pe_sel_init,                                                    // Select certain PE | OR | Initialzing cedrtain PE Accumulation operation
    input  [RESULT_CONT-1:0]  pe_sel,                                // Select certain PE | OR | Initialzing cedrtain PE Accumulation operation    
 //   input                     en_sel_init,                                                    // Enable selecting PE (HIGH) |OR| enable initializing certain PE (LOW). 
    output                    empty_fifos,                           // Empty Signals from all FIFOs
    output [M-1:0]            full_ifmap,                            // IFMAP FIFOs full flags 
    output [N-1:0]            full_filters                           // Filters FIFOS full flags
    );
    
    wire [((WW*N)+(DW*M))-1:0]  filter_ifmap;                        // Filter  Weights & INFmap (Concatenated)
    wire [DW*M-1:0]             ifmap_data;                          // Input Feature Map data (Concatenated)
    wire [WW*N-1:0]             filter_weights;                      // Filter Weights (Concatenated)
    wire [(M+N)-1:0]            wr_en_sign;                          // Enable writing signals   
    wire [(N+M)-1:0]            read_enable;
    wire [(M+N)-1:0]            empty;                               // Empty signals from FIFOs
    wire [(M+N)-1:0]            full;                                // FIFOs full flags 
//    wire [DW*M-1:0]         ifmap_fifo_systolic;                                               // Input Feature Map data From FIFO to Systolic Array Matrix Multiplier
    wire [DW*M-1:0]             ifmap_fifo_approx_units;             // Input Feature Map data From FIFO to Shared Approximate modules units
//    wire [WW*N-1:0]         weights_fifo_systolic;                                             // Filter Weights From FIFO to Systolic Array Matrix Multiplier
    wire [WW*N-1:0]             weights_fifo_approx_units;           // Filter Weights From FIFO to to Shared Approximate modules units
    wire [(M+N)-1:0]            wr_en_ctrl;                          // Enable writing control signals coming from the decoder    
    wire [OUTWIDTH*N*M-1:0]     acc_result;                          // Results
    //wire [RESULT_CONT-1:0]  result_select;                                                     // Select Result to be read from Systolic Array and written to the memory 
    
    
    wire [N*M-1:0]              clear_bus;                           // Bus of Clear signals to clear the accumulators' data
    
`ifdef DRUM_APTPU
    wire [M-1:0]                d_sign;
    wire [N-1:0]                w_sign;
    wire [$clog2(DW)*M-1:0]     d_shamt;
    wire [$clog2(WW)*N-1:0]     w_shamt;
    wire [MULT_DW*M-1:0]        syst_data;
    wire [MULT_DW*N-1:0]        syst_kernel;
`elsif ALM
    wire [($clog2(DW)+DW-1)*M-1:0]	log_concat_format_A_bus;
    wire [M-1:0]                    zero_flag_A_bus;
    wire [($clog2(WW)+WW-1)*N-1:0]	log_concat_format_B_bus;
    wire [N-1:0]                    zero_flag_B_bus;
    
`elsif MITCHELL
    wire [($clog2(DW))*M-1:0]   A_k_1;
    wire [($clog2(WW))*N-1:0]   B_k_1;
    wire [DW*M-1:0]             A_x_1;
    wire [WW*N-1:0]             B_x_1;
    wire [M-1:0]                zero_flag_A_bus;
    wire [N-1:0]                zero_flag_B_bus;
    
`elsif ROBA
    wire    [$clog2(DW)*M-1:0]	     K_wireA;
    wire    [(DW+1)*M-1:0]	         Ar_wire;
    wire    [$clog2(WW)*N-1:0]	     K_wireB;

`elsif DRALM
    wire	[(bw_lg+truncation_width+1)*M-1:0]	LC_OP_A_wire;
    wire	[(bw_lg+truncation_width+1)*N-1:0]	LC_OP_B_wire;

`elsif ASM
    `ifdef HIGH_REG
        wire [(LOG2_NIBBLE_WIDTH*NIBBLES)*M-1:0]  SL_out;
        wire [(LOG2_NIBBLE_WIDTH*NIBBLES)*M-1:0]  SEL_out;
        wire [(WW+3)*M-1:0]                       I1_wire; 
        wire [(WW+3)*M-1:0]                       I3_wire; 
        wire [(WW+3)*M-1:0]                       I5_wire; 
        wire [(WW+3)*M-1:0]                       I7_wire;
    `else
        wire [(LOG2_NIBBLE_WIDTH*NIBBLES)*M-1:0] SL_out;
        wire [(LOG2_NIBBLE_WIDTH*NIBBLES)*M-1:0] SEL_out;
        wire [WW*N-1:0]                        Kernel_copied;
        
    `endif 
`else
    wire [M-1:0]                d_sign;
    wire [N-1:0]                w_sign;
    wire [$clog2(DW)*M-1:0]     d_shamt;
    wire [$clog2(WW)*N-1:0]     w_shamt;
    wire [MULT_DW*M-1:0]        syst_data;
    wire [MULT_DW*N-1:0]        syst_kernel;
    
`endif 






/// End of the definition of the registers between the pre-approximate units and the systolic arrays ///


     
    assign filter_ifmap = {filter_weights,ifmap_data};
    assign wr_en_sign = (wr_en)? wr_en_ctrl : 'd0;                   // If wr_en, enable write to the FIFOs, else, disable
    assign read_enable = {(N+M){rd_en}};
    assign empty_fifos = & empty; 
    assign full_filters = full[(M+N)-1:M];
    assign full_ifmap = full[M-1:0];
    //assign result_select = (en_sel_init)? pe_sel_init : 'd0 ;
    //assign result_select = (en_sel_init)? pe_sel : 'd0 ;


    assign clear_bus = {(N*M){clear}};
    

    
    /// Definition of the registers between the pre-approximate units and the systolic array /// 
    `ifdef SHARED_PRE_APPROX
        `ifdef DRUM_APTPU
            reg [M-1:0]                d_sign_delayed;
            reg [N-1:0]                w_sign_delayed;
            reg [$clog2(DW)*M-1:0]     d_shamt_delayed;
            reg [$clog2(WW)*N-1:0]     w_shamt_delayed;
            reg [MULT_DW*M-1:0]        syst_data_delayed;
            reg [MULT_DW*N-1:0]        syst_kernel_delayed;
        
        `elsif ALM
            reg [($clog2(DW)+DW-1)*M-1:0]    log_concat_format_A_bus_delayed;
            reg [M-1:0]                     zero_flag_A_bus_delayed;
            reg [($clog2(WW)+WW-1)*N-1:0]   log_concat_format_B_bus_delayed;
            reg [N-1:0]                     zero_flag_B_bus_delayed;
        
        `elsif MITCHELL
            reg [($clog2(DW))*M-1:0]   A_k_1_delayed;
            reg [($clog2(WW))*N-1:0]   B_k_1_delayed;
            reg [DW*M-1:0]             A_x_1_delayed;
            reg [WW*N-1:0]             B_x_1_delayed;
            reg [M-1:0]                zero_flag_A_bus_delayed;
            reg [N-1:0]                zero_flag_B_bus_delayed;
        
        `elsif ROBA
            reg    [$clog2(DW)*M-1:0]         K_wireA_delayed;
            reg    [(DW+1)*M-1:0]            Ar_wire_delayed;
            reg    [$clog2(WW)*N-1:0]        K_wireB_delayed;
        
        `elsif DRALM
            reg    [(bw_lg+truncation_width+1)*M-1:0]    LC_OP_A_wire_delayed;
            reg [(bw_lg+truncation_width+1)*N-1:0]  LC_OP_B_wire_delayed;
        
        `elsif ASM
            `ifdef HIGH_REG
                reg [(LOG2_NIBBLE_WIDTH*NIBBLES)*M-1:0]  SL_out_delayed;
                reg [(LOG2_NIBBLE_WIDTH*NIBBLES)*M-1:0]  SEL_out_delayed;
                reg [(WW+3)*M-1:0]                       I1_wire_delayed; 
                reg [(WW+3)*M-1:0]                       I3_wire_delayed; 
                reg [(WW+3)*M-1:0]                       I5_wire_delayed; 
                reg [(WW+3)*M-1:0]                       I7_wire_delayed;
            
            `else
                reg [(LOG2_NIBBLE_WIDTH*NIBBLES)*M-1:0] SL_out_delayed;
                reg [(LOG2_NIBBLE_WIDTH*NIBBLES)*M-1:0] SEL_out_delayed;
                reg [WW*N-1:0]                          Kernel_copied_delayed;
            
            `endif
        `else
            reg [M-1:0]                d_sign_delayed;
            reg [N-1:0]                w_sign_delayed;
            reg [$clog2(DW)*M-1:0]     d_shamt_delayed;
            reg [$clog2(WW)*N-1:0]     w_shamt_delayed;
            reg [MULT_DW*M-1:0]        syst_data_delayed;
            reg [MULT_DW*N-1:0]        syst_kernel_delayed;
        `endif
    
    `endif 
        
        /// Adding the registers between the pre-approximate circuits and the matrix multiplication (systolic array) part of the actual compuation ///
    `ifdef SHARED_PRE_APPROX    
        always @(posedge clk or negedge rst_n) begin
            if (~rst_n) begin
                `ifdef DRUM_TPU
                    d_sign_delayed <= 'd0;
                    w_sign_delayed  <= 'd0;
                    d_shamt_delayed  <= 'd0;
                    w_shamt_delayed <= 'd0;
                    syst_data_delayed <= 'd0;
                    syst_kernel_delayed <= 'd0;
                
                `elsif ALM
                    log_concat_format_A_bus_delayed <= 'd0;
                    zero_flag_A_bus_delayed <= 'd0;
                    log_concat_format_B_bus_delayed <= 'd0;
                    zero_flag_B_bus_delayed <= 'd0;
                
                `elsif MITCHELL
                    A_k_1_delayed <= 'd0;
                    B_k_1_delayed <= 'd0;
                    A_x_1_delayed <= 'd0;
                    B_x_1_delayed <= 'd0;
                    zero_flag_A_bus_delayed <= 'd0;
                    zero_flag_B_bus_delayed <= 'd0;
                
                `elsif ROBA
                    K_wireA_delayed <= 'd0;
                    Ar_wire_delayed <= 'd0;
                    K_wireB_delayed <= 'd0;
                
                `elsif DRALM
                    LC_OP_A_wire_delayed <= 'd0;
                    LC_OP_B_wire_delayed <= 'd0;
                
                `elsif ASM
                    `ifdef HIGH_REG
                        SL_out_delayed <= 'd0;
                        SEL_out_delayed <= 'd0;
                        I1_wire_delayed <= 'd0;
                        I3_wire_delayed <= 'd0;
                        I5_wire_delayed <= 'd0;
                        I7_wire_delayed <= 'd0;
                    `else
                        SL_out_delayed <= 'd0;
                        SEL_out_delayed <= 'd0;
                        Kernel_copied_delayed <= 'd0;
                    
                    `endif 
                `else
                    d_sign_delayed <= 'd0;
                    w_sign_delayed  <= 'd0;
                    d_shamt_delayed  <= 'd0;
                    w_shamt_delayed <= 'd0;
                    syst_data_delayed <= 'd0;
                    syst_kernel_delayed <= 'd0;
                    
                `endif 
            
            end
            else begin
                `ifdef DRUM_TPU
                    d_sign_delayed <= d_sign;
                    w_sign_delayed  <= w_sign;
                    d_shamt_delayed  <= d_shamt;
                    w_shamt_delayed <= w_shamt;
                    syst_data_delayed <= syst_data;
                    syst_kernel_delayed <= syst_kernel;
                        
                `elsif ALM
                    log_concat_format_A_bus_delayed <= log_concat_format_A_bus;
                    zero_flag_A_bus_delayed <= zero_flag_A_bus;
                    log_concat_format_B_bus_delayed <= log_concat_format_B_bus;
                    zero_flag_B_bus_delayed <= zero_flag_B_bus;
                        
                `elsif MITCHELL
                    A_k_1_delayed <= A_k_1;
                    B_k_1_delayed <= B_k_1;
                    A_x_1_delayed <= A_x_1;
                    B_x_1_delayed <= B_x_1;
                    zero_flag_A_bus_delayed <= zero_flag_A_bus;
                    zero_flag_B_bus_delayed <= zero_flag_B_bus;
                        
                `elsif ROBA
                    K_wireA_delayed <= K_wireA;
                    Ar_wire_delayed <= Ar_wire;
                    K_wireB_delayed <= K_wireB;
                        
                `elsif DRALM
                    LC_OP_A_wire_delayed <= LC_OP_A_wire;
                    LC_OP_B_wire_delayed <= LC_OP_B_wire;
                        
                `elsif ASM
                    `ifdef HIGH_REG
                        SL_out_delayed <= SL_out;
                        SEL_out_delayed <= SEL_out;
                        I1_wire_delayed <= I1_wire;
                        I3_wire_delayed <= I3_wire;
                        I5_wire_delayed <= I5_wire;
                        I7_wire_delayed <= I7_wire;
                    `else
                         SL_out_delayed <= SL_out;
                         SEL_out_delayed <= SEL_out;
                         Kernel_copied_delayed <= Kernel_copied;
                    `endif 
                `else
                    d_sign_delayed <= d_sign;
                    w_sign_delayed  <= w_sign;
                    d_shamt_delayed  <= d_shamt;
                    w_shamt_delayed <= w_shamt;
                    syst_data_delayed <= syst_data;
                    syst_kernel_delayed <= syst_kernel;
                    
                `endif
            
            
            end
        
        end
        
    `endif 
    
        
    matrix#(.DW(DW),.WW(WW),.ACCURATE_DW(MULT_DW),.N(N),.M(M),.VBL(VBL),.NIBBLE_WIDTH(NIBBLE_WIDTH),.ADDER_PARAM(ADDER_PARAM),.ROUN_WIDTH(ROUN_WIDTH),
            .NIBBLES(NIBBLES),.OUTWIDTH(OUTWIDTH)) matrix_multiplier (
        .clk(clk),
        .rst_n(rst_n),
        .clear (clear_bus),
        .acc_result(acc_result),
   `ifdef DRUM_APTPU
        .pic_data_in(syst_data_delayed),
        .filter_weight(syst_kernel_delayed),
        .d_shamt_in(d_shamt_delayed),
        .w_shamt_in(w_shamt_delayed),
        .i_sign(d_sign_delayed),
        .w_sign(w_sign_delayed),
        .pypass_pic(),
        .pypass_filter(),
        .pypass_d_shamt(),
        .pypass_w_shamt(),
        .pypass_i_sign(),
        .pypass_w_sign()
   `elsif BAM
        .pic_data_in(ifmap_fifo_approx_units),
        .filter_weight(weights_fifo_approx_units),
        .pypas_pic(),
        .pypas_filter()
        
   `elsif UDM
        .pic_data_in(ifmap_fifo_approx_units),
        .filter_weight(weights_fifo_approx_units),
        .pypas_pic(),
        .pypas_filter()
        
   `elsif EIM
        .pic_data_in(ifmap_fifo_approx_units),
        .filter_weight(weights_fifo_approx_units),
        .pypas_pic(),
        .pypas_filter()
        
   `elsif NORMAL_TPU
        .pic_data_in(ifmap_fifo_approx_units),
        .filter_weight(weights_fifo_approx_units),
        .pypas_pic(),
        .pypas_filter()
        
   `elsif ALM
        .pixel_log_format(log_concat_format_A_bus_delayed),
        .pixel_zero_flag(zero_flag_A_bus_delayed),
        .weight_log_format(log_concat_format_B_bus_delayed),
        .weight_zero_flag(zero_flag_B_bus_delayed),
        .pypass_pixel_log_format(),
        .pypass_pixel_zero_flag(),
        .pypass_weight_log_format(),
        .pypass_weight_zero_flag()
           
   `elsif MITCHELL
        .pixel_k(A_k_1_delayed),
        .weight_k(B_k_1_delayed),
        .pixel_x(A_x_1_delayed),
        .weight_x(B_x_1_delayed),
        .pixel_zero_flag(zero_flag_A_bus_delayed),
        .weight_zero_flag(zero_flag_B_bus_delayed),
        .pypass_pixel_k(),       
        .pypass_weight_k(),      
        .pypass_pixel_x(),     
        .pypass_weight_x(),      
        .pypass_pixel_zero_flag(),
        .pypass_weight_zero_flag()
        
   `elsif ROBA
        .pixel(ifmap_fifo_approx_units),        
        .pixek_K(K_wireA_delayed),      
        .weight_K(K_wireB_delayed),    
        .pixel_rounded(Ar_wire_delayed),
        .weight(weights_fifo_approx_units),
        .pypass_pixel(),        
        .pypass_pixek_K(),      
        .pypass_weight_K(),    
        .pypass_pixel_rounded(),
        .pypass_weight()           
        
   `elsif DRALM
        .pixel_LC_OP(LC_OP_A_wire_delayed),        
        .weight_LC_OP(LC_OP_B_wire_delayed),      
                       
        .pypass_pixel_LC_OP(),
        .pypass_weight_LC_OP()
        
   `elsif ASM
    `ifdef HIGH_REG
            .weight(weights_fifo_approx_units),                                                                
            .weight_I1(I1_wire_delayed), 
            .weight_I3(I3_wire_delayed),
            .weight_I5(I5_wire_delayed),
            .weight_I7(I7_wire_delayed),                           
            .pixel_SL_in(SL_out_delayed),                                                            
            .pixel_SEL_in(SEL_out_delayed),                                                          
                                                                            
            .pypass_weight(),                                                         
            .pypass_weight_I1(), 
            .pypass_weight_I3(),
            .pypass_weight_I5(),
            .pypass_weight_I7(),
            .pypass_pixel_SL_in(),                                                     
            .pypass_pixel_SEL_in()                                                   
        
    `else 
            .weight(weights_fifo_approx_units),     
            .pixel(ifmap_fifo_approx_units),          
            .pixel_SL_in(SL_out_delayed),       
            .pixel_SEL_in(SEL_out_delayed),     
                       
            .pypass_weight(),    
            .pypass_pixel(),   
            .pypass_pixel_SL_in(),
            .pypass_pixel_SEL_in()
    `endif 
   `else
        .pic_data_in(syst_data_delayed),
        .filter_weight(syst_kernel_delayed),
        .d_shamt_in(d_shamt_delayed),
        .w_shamt_in(w_shamt_delayed),
        .i_sign(d_sign_delayed),
        .w_sign(w_sign_delayed),
        .pypass_pic(),
        .pypass_filter(),
        .pypass_d_shamt(),
        .pypass_w_shamt(),
        .pypass_i_sign(),
        .pypass_w_sign()
    
   `endif 
        );

`ifdef SHARED_PRE_APPROX
    approx_units_array #(.MULT_DW(MULT_DW),.A_BW(DW),.B_BW(WW),.N(N),.M(M),.ADDER_PARAM(ADDER_PARAM),.ROUN_WIDTH(ROUN_WIDTH),
                         .NIBBLE_WIDTH(NIBBLE_WIDTH)) shared_approximate_units  (
        .kernel(weights_fifo_approx_units),
        .data(ifmap_fifo_approx_units),              
    `ifdef DRUM_APTPU
        //.data(ifmap_fifo_approx_units),
        //.kernel(weights_fifo_approx_units),
        .syst_data(syst_data),
        .syst_kernel(syst_kernel),
        .d_sign(d_sign),
        .w_sign(w_sign),
        .d_shamt(d_shamt),
        .w_shamt(w_shamt)
    
    `elsif ALM
        .log_concat_format_A_bus(log_concat_format_A_bus),
        .zero_flag_A_bus(zero_flag_A_bus), 
        .log_concat_format_B_bus(log_concat_format_B_bus),   
        .zero_flag_B_bus(zero_flag_B_bus)
    
    `elsif MITCHELL
        .A_k_1(A_k_1),         
        .B_k_1(B_k_1),        
        .A_x_1(A_x_1),        
        .B_x_1(B_x_1),        
        .zero_flag_A_bus(zero_flag_A_bus),
        .zero_flag_B_bus(zero_flag_B_bus)
    
    `elsif ROBA
        .K_wireA(K_wireA),
        .Ar_wire(Ar_wire),
        .K_wireB(K_wireB)
    
    `elsif DRALM
        .LC_OP_A_wire(LC_OP_A_wire),
        .LC_OP_B_wire(LC_OP_B_wire)
    
    `elsif ASM
        `ifdef HIGH_REG
            .SL_out(SL_out),
            .SEL_out(SEL_out),
            .I1_wire(I1_wire),
            .I3_wire(I3_wire),
            .I5_wire(I5_wire),
            .I7_wire(I7_wire)
        `else
            .SL_out(SL_out),      
            .SEL_out(SEL_out),    
            .Kernel_copied(weights_fifo_approx_units)
        `endif 
    `else 
        .syst_data(syst_data),
        .syst_kernel(syst_kernel),
        .d_sign(d_sign),
        .w_sign(w_sign),
        .d_shamt(d_shamt),
        .w_shamt(w_shamt)
    `endif 
        );
`endif    
    
   // top_demux#(.DW(DW),.N(N+M)) in_data_demux (.in_a(data_in),.select(fifo_sel),.out_a(filter_ifmap));
    
    fifo_array#(.DW(DW),.DEPTH(DEPTH),.WW(WW),.M(M),.N(N)) FIFOs  (
    .in_data(filter_ifmap),
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(wr_en_sign),
    .rd_en(read_enable),
    .empty(empty),
    .full(full),
    .out_ifmap(ifmap_fifo_approx_units),
    .out_filters(weights_fifo_approx_units));
    
    top_demux#(.DW(max_bw),.N(N+M)) in_data_demux (.in_a(data_in),.select(fifo_sel),.out_a(filter_ifmap));

    decoder#(.OUT_DW(M+N))  wr_en_dec     (.in_data(fifo_sel),.dec_out(wr_en_ctrl));                                // Write  Enable Signals
    top_mux #(.BW(OUTWIDTH),.N(N*M))  result_mux   (.in_a(acc_result),.select(pe_sel),.out_a(result));
    

    
endmodule

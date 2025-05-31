`timescale 1ns / 1ps

module count4UDL(
    input clk_i,
    input up_i,
    input dw_i,
    input ld_i,
    input cin_i,        
    input bin_i,        
    input [3:0] din_i,
    output [3:0] q_o,
    output cout_o,      
    output bout_o       
);

    wire [3:0] count_ff;
    wire [3:0] next_count;
    wire load_condition, up_condition, down_condition, no_change;
    
    assign load_condition = ld_i;
    assign up_condition = up_i & ~dw_i;
    assign down_condition = ~up_i & dw_i;
    assign no_change = ~load_condition & ~up_condition & ~down_condition;
    
    wire [3:0] count_plus_1;
    wire [3:0] inc_carry;
    
    assign inc_carry[0] = cin_i;
    assign count_plus_1[0] = count_ff[0] ^ inc_carry[0];
    assign inc_carry[1] = count_ff[0] & inc_carry[0];
    assign count_plus_1[1] = count_ff[1] ^ inc_carry[1];
    assign inc_carry[2] = count_ff[1] & inc_carry[1];
    assign count_plus_1[2] = count_ff[2] ^ inc_carry[2];
    assign inc_carry[3] = count_ff[2] & inc_carry[2];
    assign count_plus_1[3] = count_ff[3] ^ inc_carry[3];
    assign cout_o = count_ff[3] & inc_carry[3];
    
    wire [3:0] count_minus_1;
    wire [3:0] dec_borrow;
    
    assign dec_borrow[0] = bin_i;
    assign count_minus_1[0] = count_ff[0] ^ dec_borrow[0];
    assign dec_borrow[1] = ~count_ff[0] & dec_borrow[0];
    assign count_minus_1[1] = count_ff[1] ^ dec_borrow[1];
    assign dec_borrow[2] = ~count_ff[1] & dec_borrow[1];
    assign count_minus_1[2] = count_ff[2] ^ dec_borrow[2];
    assign dec_borrow[3] = ~count_ff[2] & dec_borrow[2];
    assign count_minus_1[3] = count_ff[3] ^ dec_borrow[3];
    assign bout_o = ~count_ff[3] & dec_borrow[3];
    
    assign next_count = 
        ({4{load_condition}} & din_i) |
        ({4{up_condition}} & count_plus_1) |
        ({4{down_condition}} & count_minus_1) |
        ({4{no_change}} & count_ff);
    
    FDRE #(.INIT(1'b0)) bit_ff_0 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(next_count[0]), .Q(count_ff[0]));
    FDRE #(.INIT(1'b0)) bit_ff_1 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(next_count[1]), .Q(count_ff[1]));
    FDRE #(.INIT(1'b0)) bit_ff_2 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(next_count[2]), .Q(count_ff[2]));
    FDRE #(.INIT(1'b0)) bit_ff_3 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(next_count[3]), .Q(count_ff[3]));
    
    assign q_o = count_ff;

endmodule
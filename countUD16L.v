`timescale 1ns / 1ps

module countUD16L(
    input clk_i,
    input up_i,
    input dw_i,
    input ld_i,
    input [15:0] din_i,
    output [15:0] q_o,
    output utc_o,
    output dtc_o
);

    wire [3:0] carry_out;
    wire [3:0] borrow_out;
    
    count4UDL counter0 (
        .clk_i(clk_i),
        .up_i(up_i),
        .dw_i(dw_i),
        .ld_i(ld_i),
        .cin_i(up_i & ~dw_i),     
        .bin_i(dw_i & ~up_i),      
        .din_i(din_i[3:0]),
        .q_o(q_o[3:0]),
        .cout_o(carry_out[0]),
        .bout_o(borrow_out[0])
    );
    
    count4UDL counter1 (
        .clk_i(clk_i),
        .up_i(up_i),
        .dw_i(dw_i),
        .ld_i(ld_i),
        .cin_i(carry_out[0]),
        .bin_i(borrow_out[0]),
        .din_i(din_i[7:4]),
        .q_o(q_o[7:4]),
        .cout_o(carry_out[1]),
        .bout_o(borrow_out[1])
    );
    
    count4UDL counter2 (
        .clk_i(clk_i),
        .up_i(up_i),
        .dw_i(dw_i),
        .ld_i(ld_i),
        .cin_i(carry_out[1]),
        .bin_i(borrow_out[1]),
        .din_i(din_i[11:8]),
        .q_o(q_o[11:8]),
        .cout_o(carry_out[2]),
        .bout_o(borrow_out[2])
    );
    
    count4UDL counter3 (
        .clk_i(clk_i),
        .up_i(up_i),
        .dw_i(dw_i),
        .ld_i(ld_i),
        .cin_i(carry_out[2]),
        .bin_i(borrow_out[2]),
        .din_i(din_i[15:12]),
        .q_o(q_o[15:12]),
        .cout_o(carry_out[3]),
        .bout_o(borrow_out[3])
    );
    
    assign utc_o = &q_o;      
    assign dtc_o = ~|q_o;     

endmodule
`timescale 1ns / 1ps

module top_lab3(
    input clkin,
    input btnU,
    input btnD,
    input btnR,
    input btnC,
    input btnL,
    input [15:0] sw,
    output [15:0] led,
    output [3:0] an,
    output [6:0] seg,
    output dp
);

    wire clk, digsel;
    wire [15:0] count;
    wire [3:0] ring_out, selected_digit;
    wire up_pulse, down_pulse, load_pulse;
    wire up_signal, down_signal, load_signal;
    wire utc, dtc;
    
    wire up_held = btnU & ~btnR;
    wire down_held = btnD & ~btnR;
    wire load_held = btnL & ~btnR;
    
    wire up_allowed = ~down_held & ~load_held;
    wire down_allowed = ~up_held & ~load_held;
    wire load_allowed = ~up_held & ~down_held;
    
    labCnt_clks clk_div (
        .clkin(clkin),      
        .greset(btnR),      
        .clk(clk),        
        .digsel(digsel)   
    );
    
    edge_detector edge_up (
        .clk_i(clk),
        .signal_i(btnU),
        .pulse_o(up_pulse)
    );
    
    edge_detector edge_down (
        .clk_i(clk),
        .signal_i(btnD),
        .pulse_o(down_pulse)
    );
    
    assign up_signal = (up_pulse | (btnC & ~(&count[15:2]))) & up_allowed;
    assign down_signal = down_pulse & down_allowed;
    assign load_signal = load_pulse & load_allowed;
    
    countUD16L counter (
        .clk_i(clk),
        .up_i(up_signal),
        .dw_i(down_signal),
        .ld_i(btnL),
        .din_i(sw),
        .q_o(count),
        .utc_o(utc),
        .dtc_o(dtc)
    );
    
    ring_counter ring (
        .clk_i(clk),
        .advance_i(digsel),
        .q_o(ring_out)
    );
    
    selector sel (
        .N(count),
        .sel(ring_out),
        .H(selected_digit)
    );
    
    hex7seg seg_decoder (
        .n(selected_digit),
        .seg(seg)
    );
    
    assign an = ~ring_out;
    assign dp = 1'b1;
    assign led = {utc, 14'b0, dtc};

endmodule
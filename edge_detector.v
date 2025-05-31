`timescale 1ns / 1ps

module edge_detector(
    input clk_i,
    input signal_i,
    output pulse_o
);

    wire signal_ff1, signal_ff2;
    
    FDRE #(.INIT(1'b0)) ff1 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(signal_i), .Q(signal_ff1));
    FDRE #(.INIT(1'b0)) ff2 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(signal_ff1), .Q(signal_ff2));
    
    assign pulse_o = signal_ff1 & ~signal_ff2;

endmodule
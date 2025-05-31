`timescale 1ns / 1ps

module ring_counter(
    input clk_i,
    input advance_i,
    output [3:0] q_o
);

    wire [3:0] next_state, state_ff;
    
    assign next_state[0] = (advance_i & state_ff[1]) | (~advance_i & state_ff[0]);
    assign next_state[1] = (advance_i & state_ff[2]) | (~advance_i & state_ff[1]);
    assign next_state[2] = (advance_i & state_ff[3]) | (~advance_i & state_ff[2]);
    assign next_state[3] = (advance_i & state_ff[0]) | (~advance_i & state_ff[3]);
    
    FDRE #(.INIT(1'b1)) ff0 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(next_state[0]), .Q(state_ff[0]));
    FDRE #(.INIT(1'b0)) ff1 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(next_state[1]), .Q(state_ff[1]));
    FDRE #(.INIT(1'b0)) ff2 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(next_state[2]), .Q(state_ff[2]));
    FDRE #(.INIT(1'b0)) ff3 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(next_state[3]), .Q(state_ff[3]));
    
    assign q_o = state_ff;

endmodule
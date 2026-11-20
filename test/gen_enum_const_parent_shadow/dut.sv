// A generate-block enum constant shares its name with an enum constant of the
// instantiating module (black-parrot bp_me_stream_pump_control's e_ready inside
// bp_lce_req).  pump's e_ready is 0; the parent's is 1.
module pump #(parameter int W = 2) (
  input  clk_i, reset_i, ack_i, last_i,
  output logic nx_o
);
  if (W == 1) begin : z
    assign nx_o = 1'b0;
  end else begin : nz
    enum logic {e_ready, e_stream} state_n, state_r;
    always_comb
      case (state_r)
        e_stream: state_n = (ack_i &  last_i) ? e_ready : e_stream;
        default : state_n = (ack_i & ~last_i) ? e_stream : e_ready;
      endcase
    always_ff @(posedge clk_i)
      if (reset_i) state_r <= e_ready;
      else         state_r <= state_n;
    assign nx_o = state_n;
  end
endmodule

module top (
  input  clk_i, reset_i, ack_i, last_i,
  output logic nx_o,
  output logic [2:0] ps_o
);
  enum logic [2:0] {e_reset, e_ready, e_request} state_r;
  always_ff @(posedge clk_i)
    if (reset_i) state_r <= e_reset;
    else         state_r <= e_ready;
  assign ps_o = state_r;
  pump #(.W(2)) p (.clk_i, .reset_i, .ack_i, .last_i, .nx_o);
endmodule

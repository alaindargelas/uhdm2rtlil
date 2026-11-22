// A plain assignment whose RHS is SIGNED sign-extends into a wider target
// (LRM 11.8.2).  When the RHS is a blocking variable read in the same block,
// the reader substitutes its in-flight value (here a constant), which is no
// longer the declared signed wire -- so the extension silently became a
// zero-extension: os read 10'h1ff instead of 10'h3ff.
module signed_inflight_extend(input logic signed [3:0] a,
                              output logic signed [9:0] os,
                              output logic signed [9:0] oa,
                              output logic [9:0] ou);
  always_comb begin
    logic signed [8:0] z;
    logic signed [5:0] t;
    logic [8:0] u;
    z = -9'sd1;
    t = a;          // sign-extends 4 -> 6
    u = 9'h1ff;     // unsigned: zero-extends
    os = z;
    oa = t;
    ou = u;
  end
endmodule

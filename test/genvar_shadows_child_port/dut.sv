// A child's input port named like the instantiating loop's genvar.
// `1'b1 << i` in dec reads dec's PORT i; it must not fold to the parent's
// genvar value (basejump bsg_decode inside black-parrot bp_be_dcache's
// `for (genvar i ...) begin : wbuf_in`).
module dec #(parameter int N = 4) (
  input  [$clog2(N)-1:0] i,
  output logic [N-1:0]   o
);
  if (N == 1) begin : one
    assign o = 1'b1;
  end else begin : many
    assign o = (N)'(1'b1 << i);
  end
endmodule

module top (
  input  [7:0] a,
  output [3:0] y1,
  output [1:0] y2
);
  for (genvar i = 1; i < 3; i++) begin : g
    logic [(8 >> i)-1:0] d;
    dec #(.N(8 >> i)) u (.i(a[i +: (3 - i)]), .o(d));
  end
  assign y1 = g[1].d;
  assign y2 = g[2].d;
endmodule

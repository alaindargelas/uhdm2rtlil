// Dynamic arrays sized by `new[N]` in an initial block (LRM 7.5.1).  The
// reader models a dynamic array as a fixed one with one element per index up
// to the largest constant `new[N]`.  Before: the `[0:unsized]` bound was folded
// as ASCII text (br_gh460's `reg a[]` -> 1.8 million element wires, the read
// never ended), `int ia[]` became one 1-bit wire, and `a = new[3]` clobbered
// the element writes after it with X.
module dyn_array_new(output logic o0, o1, o2, ok,
                     output logic [7:0] b0, b3, i2,
                     output logic q0, q1);
  reg a[];
  reg p;
  reg [7:0] mema[];
  reg [7:0] memb[];
  int ia[];
  reg c[];
  // Straight-line block: the init (sync) path.
  initial begin
    a = new[3];          // elements default to X (4-state)
    a[0] = 1'b0;
    a[1] = 1'b1;
    mema = new[4] ('{8'd1, 8'd2, 8'd3, 8'd4});
    memb = new[4] (mema);  // copy
    memb = new[5] (memb);  // resize: memb[4] is the default
    ia = new[3];           // 2-state: elements default to 0
  end
  // A block with control flow: the comb path.
  initial begin
    p = 1'b1;
    c = new[2];
    c[1] = 1'b1;
    c[0] = 1'b0;
    if (c[1] !== 1'b1) p = 1'b0;
  end
  assign o0 = a[0]; assign o1 = a[1]; assign o2 = a[2];
  assign b0 = memb[0]; assign b3 = memb[3]; assign i2 = ia[2][7:0];
  assign q0 = c[0]; assign q1 = c[1]; assign ok = p;
endmodule

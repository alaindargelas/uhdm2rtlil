// A genvar reused by a nested generate loop (LRM 27.4), a parameter left
// without a value, overrides of parameters the LRM makes local (LRM
// 6.20.1), a non-integral packed member (LRM 7.2.1) and a type defined in
// terms of itself (LRM 6.18).  Legal forms must stay silent; each ILLEGAL
// line is one error.
module err_gpm_child #(parameter A, parameter B = 1,
                       localparam C = 3, int D = 4) (
  output logic [A-1:0] o
);
  assign o = '0;
endmodule

module err_gpm_gen;
  for (genvar g = 0; g < 2; g++) begin : loop
    parameter P = g;
    logic [P:0] r;
  end
endmodule

module err_genvar_param_member (
  output logic [3:0] y0,
  output logic [3:0] y1,
  output logic [3:0] y2,
  output logic [1:0] w,
  output logic [1:0] v
);
  // Legal: declared and inline genvars, a shadowing genvar in a nested scope.
  genvar i, j;
  for (i = 0; i < 2; i++) begin : outer
    for (j = 0; j < 1; j++) begin : inner
      genvar i;
      for (i = 0; i < 1; i++) begin : shadow
        logic t;
      end
    end
    assign w[i] = 1'b1;
  end
  // Tolerated: an integer index is not a genvar by the LRM, but it is
  // common in real RTL and other tools accept it.
  integer k;
  for (k = 0; k < 2; k++) begin : notgv
    assign v[k] = 1'b0;
  end
  // ILLEGAL: the inner loop reuses the outer loop's genvar.
  for (j = 0; j < 1; j++) begin : reuse
    for (j = 0; j < 1; j++) begin : again
      logic u;
    end
  end

  // Legal: A supplied positionally, by name and by defparam.
  err_gpm_child #(4) c0 (.o(y0));
  err_gpm_child #(.A(4), .B(2)) c1 (.o(y1));
  err_gpm_child c2 (.o(y2));
  defparam c2.A = 4;
  // ILLEGAL: A has no default and no value.
  err_gpm_child c3 ();
  // ILLEGAL: D follows `localparam C`, so it is local too.
  err_gpm_child #(.A(4), .D(5)) c4 ();
  // ILLEGAL: a parameter in a generate block is local.
  err_gpm_gen g0 ();
  defparam g0.loop[0].P = 3;

  // Legal: a forward typedef completed without recursion.
  typedef T;
  typedef struct packed { logic [1:0] a; } T;
  typedef struct packed { T x; logic b; } U;
  U uu;
  // ILLEGAL: a real member in a packed struct.
  typedef struct packed { logic a; real r; } bad_member_t;
  bad_member_t bm;
  // ILLEGAL: R contains itself.
  typedef R;
  typedef struct packed { R x; } R;
  R rr;
endmodule

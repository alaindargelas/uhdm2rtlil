// A specparam in a general constant expression (LRM 6.20.5): a parameter
// value or a generate condition.  Legal uses (a delay, a specify path, a
// generate BODY) must stay silent; each ILLEGAL line is one error.
module err_specparam_const (input logic a, output logic b, output logic c);
  specparam tpd = 3;
  localparam int W = 4;

  // Legal.
  assign #tpd b = a;
  if (W == 4) begin : g_ok
    assign #tpd c = a;
  end
  specify
    (a => b) = tpd;
  endspecify

  // Illegal.
  localparam int LP = tpd + 1;          // ILLEGAL: localparam value
  if (tpd > 1) begin : g_bad             // ILLEGAL: generate condition
  end
endmodule

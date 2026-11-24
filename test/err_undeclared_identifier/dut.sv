// Names that are declared nowhere (IEEE 1800-2023 6.10 infers an implicit
// net only on a continuous-assignment LHS or a port/terminal connection):
//   * `missing` is read on an assign RHS               -> UH0737
//   * `value`   is read inside an always block          -> UH0737
//   * `func1`   is called but never defined             -> UH0738
// Surelog bound each of them to a net it fabricated (or left the call
// unbound) and the design elaborated silently.  An implicit net on an
// assign LHS (`imp`) stays legal and is NOT reported.
module err_undeclared_identifier(input logic [3:0] a, output logic [3:0] y,
                                 output logic [3:0] z, output logic [3:0] w);
  function automatic logic [3:0] func2(input logic [3:0] v);
    return v;
  endfunction
  assign imp = a[0];
  assign y = missing;
  always_comb z = value;
  always_comb w = func2(func1(a));
endmodule

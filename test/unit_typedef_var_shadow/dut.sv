// A compilation-unit ($unit) variable declared with a $unit typedef keeps
// that type inside a module that declares its own type of the same name
// (sv-tests regress-sv_sv_typedef_scope2_iv).  Surelog used to leave
// `T x;` at file scope uncompiled -- it parses as a net declaration of a
// user type -- so `x` was undeclared in the module (UH0737), and once
// imported it took the module's `T` (2 x 8 bits) instead of the $unit one.
typedef logic [3:0] T;
T x;

module unit_typedef_var_shadow (
    input  logic [3:0] i,
    output logic [3:0] o,
    output logic [7:0] wx,
    output logic [7:0] wy
);
  typedef logic [7:0] T[1:0];
  T y;
  assign x = i;
  assign y[0] = {i, i};
  assign y[1] = ~{i, i};
  assign o = x ^ y[1][3:0];
  assign wx = $bits(x);  // 4: the $unit T
  assign wy = $bits(y);  // 16: the module's T
endmodule

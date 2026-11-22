// An array variable declared through an UNPACKED-ARRAY TYPEDEF has no element
// variables in UHDM (only its array_typespec), and UHDM's ExprEval::size
// dereferenced Variables()->at(0) unconditionally: reducing $bits / $size
// over such a variable segfaulted the read (ivtest sv_typedef_scope2,
// sv_typedef_nested_array, module_port_typedef_array1).  Fixed in
// chipsalliance/UHDM#1186, brought in by the Surelog bump.
typedef logic [3:0] T;
T x;

module unpacked_typedef_array_var_bits (
  input  logic [7:0] a,
  output logic [7:0] y0,
  output logic [7:0] y1,
  output logic [31:0] bits_t,
  output logic [31:0] size_y
);
  typedef logic [7:0] T[1:0];
  T y;

  assign y[0] = a;
  assign y[1] = ~a;
  assign y0 = y[0];
  assign y1 = y[1];
  assign bits_t = $bits(T);
  assign size_y = $size(y);
endmodule

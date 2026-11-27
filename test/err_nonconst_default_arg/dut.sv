// A function called in a parameter value uses the defaults of the
// arguments it omits; those defaults must be constant expressions too.
module top(input logic [7:0] i, output logic [7:0] o);
  parameter int P = 2;
  integer a, b;

  function automatic integer k_bad(integer x, integer y = a + b);
    return x + y;
  endfunction
  function automatic integer k_ok(integer x, integer y = P + 1);
    return x + y;
  endfunction

  localparam integer R_BAD  = k_bad(3);     // illegal: default reads `a`
  localparam integer R_OK1  = k_bad(3, 4);  // legal: default not used
  localparam integer R_OK2  = k_ok(3);      // legal: default over P

  assign o = i + R_OK1[7:0] + R_OK2[7:0];
endmodule

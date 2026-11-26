// Package import / export rules (LRM 26.3, 26.6), package-scoped names,
// a task called as a function (LRM 13.3), an imported name reached through
// a hierarchical path and a missing struct member.  Legal forms must stay
// silent; each ILLEGAL line is one error.
package epie_a;
  localparam int X = 1;
  localparam int Y = 2;
  localparam int BOTH = 3;
  localparam int ONLY_A = 4;
  logic [3:0] pv;
  function automatic int inc(int v);
    return v + 1;
  endfunction
  task automatic tick();
  endtask
endpackage

package epie_b;
  localparam int BOTH = 5;
  localparam int ONLY_B = 6;
  localparam int UNUSED_B = 7;
endpackage

// Legal: an explicit import exported by name, and a wildcard import exported
// by `*::*` for the names the package references.
package epie_fwd;
  import epie_a::X;
  export epie_a::X;
  import epie_b::*;
  localparam int Z = ONLY_B;
  export *::*;
endpackage

package epie_bad;
  import epie_a::X;
  export epie_a::Y;                    // ILLEGAL: Y is not imported
  import epie_b::*;
  localparam int BOTH = 8;
  export epie_b::BOTH;                 // ILLEGAL: conflicts with BOTH above
endpackage

package epie_bad2;
  import epie_b::*;
  export epie_b::MISSING;              // ILLEGAL: epie_b has no MISSING
endpackage

module epie_sub (output int o);
  import epie_a::*;
  assign o = X + pv;
endmodule

// Legal: a wildcard import below the first use does not compete for it,
// and that use imports the name for the rest of the module.
module epie_late (output int o, o2);
  import epie_a::*;
  assign o = BOTH;
  import epie_b::*;
  assign o2 = BOTH;
endmodule

typedef struct packed {
  logic a;
  logic b;
} epie_s_t;

module err_package_import_export (
  output int y0, y1, y2, y3, y4, y5, y6, y7, y8,
  output epie_s_t s
);
  import epie_fwd::X;                  // legal: exported by name
  import epie_fwd::ONLY_B;             // legal: referenced, exported by *::*
  import epie_fwd::UNUSED_B;           // ILLEGAL: never referenced in epie_fwd
  import epie_a::*;
  import epie_b::*;
  localparam int ONLY_A = 9;           // legal: declared before any use
  assign y0 = X + ONLY_B + ONLY_A + epie_a::inc(1);
  assign y1 = BOTH;                    // ILLEGAL: both wildcard imports
  assign y2 = Y;
  localparam int Y = 10;               // ILLEGAL: declared after its use
  assign y3 = epie_a::NOPE;            // ILLEGAL: no such member
  assign y4 = epie_a::X(1);            // ILLEGAL: X is not a function
  always_comb y5 = epie_a::tick();     // ILLEGAL: a task has no value
  epie_sub u_sub (.o(y6));
  epie_late u_late (.o(), .o2());
  assign y7 = u_sub.o;                 // legal: a member of the instance
  assign y8 = u_sub.pv;                // ILLEGAL: pv is only imported there
  assign s.a = 1'b1;
  assign s.c = 1'b0;                   // ILLEGAL: no member c
endmodule

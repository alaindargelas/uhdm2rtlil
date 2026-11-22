// Variables declared at FILE scope live in the compilation-unit scope ($unit,
// LRM 3.12.1) and are visible to every module of the unit.  Surelog used to
// drop them, so a reference became a fabricated implicit net -- and a
// procedural write to it was rejected as "Illegal lhs of type wire" (UH0718).
// The ivtest regressions declare their `failed` flag this way (~24 sv-tests).
bit flag = 1'b0;
logic [7:0] acc;
logic [3:0] shadow;        // shadowed by the module's own declaration
logic [3:0] unused_unit;   // never referenced: must not appear in the module

module unit_scope_var_procedural(input logic a, input logic [7:0] d,
                                 output logic o, output logic [7:0] q,
                                 output logic [3:0] s);
  logic [3:0] shadow;
  always_comb begin
    flag = a;
    acc = d + 8'd1;
  end
  assign shadow = d[7:4];
  assign o = flag;
  assign q = acc;
  assign s = shadow;
endmodule

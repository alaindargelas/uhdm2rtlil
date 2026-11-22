// Mutual recursion between two void functions whose termination depends on
// a RUNTIME value (ivtest br_gh418).  read_uhdm inlined it without limit
// (import_tf_call_comb -> inline_task_body_comb -> import_if_stmt_comb ->
// import_statement_comb -> import_tf_call_comb ...) and died of a stack
// overflow.  Synthesis cannot unroll this; the read must survive, with the
// over-deep call dropped and a warning.  The output does not depend on the
// recursion, so the netlist is still comparable.
module tf_mutual_recursion_runtime_bound (
  input  logic a,
  output logic y
);
  reg [31:0] count = 0;

  function void func1();
    count++;
    if (count < 10) func2();
  endfunction

  function void func2();
    count++;
    if (count < 10) func1();
  endfunction

  initial func1();
  // read_verilog cannot take this design either: it recurses until its AST
  // simplifier dies, without an ERROR line.  `final` (which it rejects with a
  // syntax error) makes it fail deterministically, so the suite scores this
  // as a UHDM-only test instead of a missing-output failure.
  final $display("count=%0d", count);

  assign y = ~a;
endmodule

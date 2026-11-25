// A generate block named like another declaration of its scope (LRM 3.13,
// 27.6).  Legal forms must stay silent; each ILLEGAL line is one error.
module err_scope_name_clash #(parameter int N = 2) (
  input  logic [3:0] a,
  output logic [3:0] y
);
  logic named;
  logic [3:0] acc;

  // Legal: one label on both branches of a conditional generate, a loop of
  // several iterations, labels distinct from every declaration.
  if (N == 2) begin : g_sel
    assign y = a;
  end else begin : g_sel
    assign y = ~a;
  end
  for (genvar i = 0; i < 4; i++) begin : g_bits
    assign acc[i] = a[i];
  end
  assign named = acc[0];

  // Illegal.
  for (genvar i = 0; i < 1; i++) begin : named     // ILLEGAL: a reg's name
  end
  for (genvar i = 0; i < 1; i++) begin : g_twice
  end
  for (genvar i = 0; i < 1; i++) begin : g_twice   // ILLEGAL: second g_twice
  end
  if (N > 0) begin : blk
  end
  initial begin : blk                              // ILLEGAL: clashes above
  end
endmodule

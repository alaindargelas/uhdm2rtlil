// A property whose expression is a bare declared signal is a boolean
// property over that signal (LRM 16.12), not an unresolved property name.
// Surelog's lint reported it as UH0729 "Unresolved property" (sv-tests
// property_disable_iff_test, sva_nested_clk_else).
module prop_bare_signal (
    input  logic clk,
    input  logic rst,
    input  logic a,
    input  logic b,
    output logic out
);
  always_ff @(posedge clk or posedge rst)
    if (rst) out <= 1'b0;
    else out <= a;

  assert property (@(posedge clk) disable iff (rst) out);

  always @(posedge clk) begin
    if (a);
    else assume property (@(posedge clk) b);
  end
endmodule

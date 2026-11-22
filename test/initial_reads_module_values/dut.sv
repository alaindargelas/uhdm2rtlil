// An initial block evaluated at compile time reads MODULE signals too: a
// variable's declaration initializer (it runs before the block) and a net
// with a constant driver.  The interpreter read both as 0:
//   * br_gh567 compared each `val[j]` (driven by `assign val[i] = i` in a
//     generate loop) against j, set `failed`, and then clashed with
//     `reg failed = 0` -- "Conflicting initialization values for \failed";
//   * a flag initialised to 1 at its declaration read back as 0.
// What the block writes supersedes the declaration initializer.
// read_verilog computes y = 9 here (it does not run the initializer of `flag`
// before the block, LRM 6.8), so the `final` block keeps it out: it rejects
// `final` and the test is UHDM-only.
module initial_reads_module_values(output logic f, output logic [7:0] y,
                                   output logic [3:0] z);
  wire [7:0] val[3:0];
  genvar i;
  for (i = 3; i >= 0; i = i - 1) begin : g
    assign val[i] = i;
  end
  integer j;
  reg failed = 0;
  reg flag = 1'b1;
  reg [7:0] r = 8'd9;
  reg [3:0] q = 4'b0000;
  initial begin
    for (j = 3; j >= 0; j = j - 1)
      if (val[j] != j) failed = 1;     // never true
    if (flag) r = val[3] + 8'd10;      // flag reads its initializer: 13
    q[2] = 1'b1;                       // a bit write merges into q's init
  end
  final $display("done");
  assign f = failed;
  assign y = r;
  assign z = q;
endmodule

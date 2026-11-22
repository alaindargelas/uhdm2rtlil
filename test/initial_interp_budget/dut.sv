// A compile-time loop in an initial block that does not finish within the
// interpreter's limits must not produce a value.  Two ways it did:
//   * each loop was capped at 100k iterations and simply STOPPED there, so
//     this block set acc = 100001 instead of 9000000, with no warning;
//   * there was no TOTAL budget: Icarus ivtest pow_reg_signed interpreted
//     65535 x 127 iterations for 50+ s and logged 1.4 GB of warnings.
// Either limit now abandons the block, which is ignored with a warning (a
// partial result is a wrong value).  `do ... while` keeps read_verilog out of
// it: read_verilog rejects the construct instead of unrolling 9M iterations.
module initial_interp_budget(output logic [31:0] o, output logic [7:0] k);
  logic [31:0] acc;
  logic [7:0] kept;
  integer i;
  initial begin
    acc = 0;
    i = 0;
    do begin
      acc = acc + 1;
      i = i + 1;
    end while (i < 9000000);
  end
  initial kept = 8'd42;     // an ordinary initial block is unaffected
  assign o = acc;
  assign k = kept;
endmodule

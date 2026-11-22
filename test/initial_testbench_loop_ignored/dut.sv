// An initial block that repeats a timing control in a loop (drive, wait,
// check, repeat) is a simulation TESTBENCH, not an initialization: no logic
// reproduces it.  The reader used to unroll it -- Icarus ivtest slongint_test
// became 446k cells in 15 s and `proc` never finished.  It is now ignored
// with a warning; the design logic around it is unaffected.  (An initial
// block whose delay is NOT in a loop, `e = #10 c;`, is still read -- see
// test/initial_seq_values.)
module initial_testbench_loop_ignored(input logic clk, input logic [7:0] d,
                                      output logic [7:0] q);
  logic [7:0] stim;
  integer i;
  always_ff @(posedge clk) q <= d + 8'd1;
  initial begin
    for (i = 0; i < 1000; i = i + 1) begin
      #1;
      stim = $random;
      #1;
      if (q !== stim + 8'd1) $display("FAILED");
    end
  end
endmodule

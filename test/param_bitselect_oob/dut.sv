// A CONSTANT bit-select past the end of a parameter reads X for a 4-state
// parameter and 0 for a 2-state one (IEEE 1800-2017 11.5.1).  read_uhdm only
// returned for an in-range index and fell through to the wire lookup, which
// aborted the read: "Could not find wire 'pvar0' for bit select" (ivtest
// sel_rval_bit_ob / sel_rval_part_ob probe pvar0[32] of a 32-bit parameter
// on purpose, from an initial block where the index folds to a constant).
// The initial-block case reads a 2-STATE parameter: an X-valued result would
// make the Verilator co-sim (2-state) disagree for reasons unrelated to the read.
module param_bitselect_oob (
  output logic o_in,
  output logic o_2state,
  output logic o_init
);
  parameter [7:0] P8 = 8'hA5;
  parameter int   PI = 5;
  integer idx;
  assign o_in     = P8[2];      // in range: 1
  assign o_2state = PI[40];     // out of range, 2-state: 0
  initial begin
    idx = 40;
    o_init = 1'b1;
    if (PI[idx] === 1'b1) o_init = 1'b0;   // PI[40] is 0 (x to read_verilog): stays 1
  end
endmodule

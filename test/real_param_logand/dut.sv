// A REAL operand of `&&` is true when NONZERO (LRM 11.4.7): with Q = 0.25,
// `Q && i` is i.  read_uhdm gives i (Verilator agrees); read_verilog rounds Q
// to 0 first and gives 0, so the formal comparison against it fails -- this
// test is in failing_tests.txt for that READ_VERILOG defect, and
// test_structural.ys is the gate on read_uhdm's value.
module dut(input logic i, output logic t_and, t_and_rev);
  localparam real Q = 0.25;
  assign t_and     = Q && i;
  assign t_and_rev = i && Q;
endmodule

// A REAL used as a CONDITION is true when it is NONZERO (LRM 12.4, 11.4.7):
// 0.25 must not be rounded to an integer (0) first.  Every boolean context
// read_uhdm imports a condition through: ?:, !, ||, a comb `if`, an `if`
// nested in a `case` arm, and a clocked `if`.  N = -0.0 is FALSE.  `&&` is in
// test/real_param_logand: read_verilog, this test's formal reference, gets it
// wrong.
module dut(input logic clk, input logic [1:0] sel, input logic i,
           output logic t_tern, t_not, t_or, t_neg0,
           output logic c_if, c_case, output logic q_ff);
  localparam real Q = 0.25, N = -0.0;
  assign t_tern = Q ? 1'b1 : 1'b0;          // 1
  assign t_not  = !Q;                       // 0
  assign t_or   = N || i;                   // i
  assign t_neg0 = N ? 1'b1 : 1'b0;          // 0
  always_comb begin
    if (Q) c_if = i; else c_if = ~i;        // i
  end
  always_comb begin
    c_case = 1'b0;
    case (sel)
      2'd1: if (Q) c_case = i; else c_case = ~i;   // i when sel == 1
      default: c_case = 1'b0;
    endcase
  end
  always_ff @(posedge clk)
    if (Q) q_ff <= i; else q_ff <= ~i;      // registers i
endmodule

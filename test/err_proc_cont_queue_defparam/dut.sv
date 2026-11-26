// Procedural continuous assignment targets (LRM 10.6), bounded queue bounds
// (LRM 7.10) and defparam targets (LRM 23.10.1).  Every line marked ILLEGAL
// must be reported; each legal look-alike next to it must stay silent.
module child #(parameter int W = 4) (input logic [W-1:0] i, output logic [W-1:0] o);
  assign o = i;
endmodule

module dut(input logic [3:0] a, output logic [3:0] o);
  localparam int N = 2;
  int q_ok[$:3];
  int q_n[$:N];
  int q_neg[$:-1];                             // ILLEGAL: negative bound
  int q_x[$:'x];                               // ILLEGAL: unknown bound

  reg  [3:0] r;
  reg        mem[1:0];
  wire [3:0] w;
  integer idx;

  child #(.W(4)) u_c (.i(a), .o(o));
  defparam u_c.W = 4;
  defparam u_c.Z = 4;                          // ILLEGAL: no parameter Z

  assign w = a;

  initial begin
    idx = 1;
    assign r = 4'h1;
    deassign r;
    assign r[idx] = 1'b1;                      // ILLEGAL: variable select
    deassign r[idx];                           // ILLEGAL: variable select
    assign mem[idx] = 1'b1;                    // ILLEGAL: variable select
    force w[1] = 1'b1;
    release w[1];
    force w[idx] = 1'b1;                       // ILLEGAL: variable select
    release w[idx+:1];                         // ILLEGAL: variable select
  end
endmodule

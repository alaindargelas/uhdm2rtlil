// Enum declaration rules (LRM 6.19) and structural / lvalue rules the
// parser accepts.  Every line marked ILLEGAL draws exactly one error; the
// legal look-alikes beside them must stay silent.
module eir_sub (io, io2);
  inout [3:0] io;
  inout [3:0] io2;
  // ILLEGAL: a reg on an inout port (UH0751).
  reg [3:0] io;
  wire [3:0] io2;
endmodule

module eir_conn #(parameter W = 4) (inout wire [W-1:0] w);
endmodule

module eir_test (input wire foo);
endmodule

program eir_prog;
  reg foo = 1;
  // ILLEGAL: a module instantiated in a program (CP0361).
  eir_test dut(foo);
endprogram

module eir_inout_def (
  inout [3:0] p,
  // ILLEGAL: an inout port with a default value (CP0363).
  q = 1,
  input [3:0] r = 2
);
endmodule

module err_enum_inout_rules #(parameter P = 3) (
  input wire [3:0] a,
  output wire [7:0] y,
  output wire [7:0] z
);
  typedef int T;
  typedef logic [3:0] V;
  // ILLEGAL: $time is not a constant (CP0359).
  enum {E0, E1 = $time} e1;
  // ILLEGAL: x in an int enum (CP0355).
  enum {F0, F1 = 'bx} e2;
  // ILLEGAL: x in a 2-state bit enum (CP0355).
  enum bit [1:0] {G0 = 0, G1 = 2'bxx, G2 = 1} e3;
  // ILLEGAL: G4 follows an x value and has none of its own (CP0356).
  enum integer {G3 = 0, G5 = {32{1'bx}}, G4} e4;
  // ILLEGAL: 100 does not fit bit [4:0] (CP0357).
  enum bit [4:0] {H[4] = 100} e5;
  // ILLEGAL: -1 does not fit an unsigned base (CP0357).
  enum bit [1:0] {I0 = -1, I1} e6;
  // ILLEGAL: J1 = 4 overflows bit [1:0] (CP0357).
  enum bit [1:0] {J0 = 3, J1} e7;
  // ILLEGAL: int takes no packed dimension (CP0358).
  enum T [1:0] {K0} e8;
  // ILLEGAL: an enum cannot be its own base type (CP0358).
  typedef U;
  typedef enum U {L0, L1} U;

  // Legal look-alikes.
  enum logic [1:0] {M0 = 0, M1 = 2'bxx, M2 = 2} l1;  // 4-state x
  enum {N0 = 'hFFFF_FFFF} l2;                         // bit pattern fits int
  enum bit [1:0] {O0 = 2, O1} l3;                     // last value 3 fits
  enum V {Q0, Q1} l4;                                 // vector typedef base
  enum bit [P:0] {R0 = 100} l5;                       // parameter width: not judged

  wire [3:0] bus = a;
  wire       w1, w2, ctl;
  reg        r1;
  wire [4:0] icim [1:0];
  reg [7:0]  res;
  assign w1 = a[0];
  assign ctl = a[1];
  // Legal: nets on a tran switch.
  tranif1 (w1, w2, ctl);
  // ILLEGAL: a reg on a tran terminal (UH0751).
  tran (r1, w2);

  eir_sub u_sub (.io(), .io2(bus));
  // ILLEGAL: a replication cannot drive an inout back (UH0752).
  eir_conn #(.W(8)) u_conn (({2{bus}}));
  // Legal: a concatenation of nets on an inout.
  eir_conn #(.W(8)) u_conn2 ({bus, bus});

  // ILLEGAL: a parameter is not assignable (UH0752).
  assign P = 1;
  // ILLEGAL: a procedural write to an element of a wire array (UH0718).
  always @(a) icim[0] <= a;

  // ILLEGAL: a zero replication outside a concatenation (CP0362).
  always @* res = {0{a[0]}};
  // Legal: a zero replication beside real bits.
  assign y = {{0{a[0]}}, 8'h5a};
  assign z = res;

  generate
    for (genvar i = 0; i < 1; i++) begin : g1
    end
    // Legal here: a generate region nested in another is accepted (yosys
    // synthesizes it; gen_test9 in its own suite).
    generate
      for (genvar j = 0; j < 1; j++) begin : g2
      end
    endgenerate
  endgenerate
endmodule

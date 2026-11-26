// Unpacked-array and class-handle assignment compatibility (LRM 7.6, 8.7,
// 8.15, 8.21, 10.9.1).  Every line marked ILLEGAL must be reported; each
// legal look-alike next to it must stay silent.
class B;
  int x;
endclass
class D extends B;
endclass
class C;
endclass
virtual class V;
endclass
class VD extends V;
endclass

module dut(input logic [1:0] a, output logic [1:0] o);
  typedef logic [31:0] w32_t;
  typedef struct { int a; int b; } ms_t;

  logic [31:0] q4[$];
  bit   [31:0] q2[$];
  logic signed [31:0] qs[$];
  w32_t qt[$];
  int   di[];
  shortint ds[];
  real  dr[];
  int   di2[];

  wire  [1:0] x2[1:0][1:0];
  reg   [1:0] y4[3:0];
  wire  [1:0] x22[1:0][1:0];
  wire        sa[1:0];
  wire        sx[1:0];
  wire  integer wi[1:0];
  enum integer { EA } ye[1:0];
  reg   [3:0] in8[7:0];
  wire  [3:0] out8[7:0];
  logic [7:0] bf[];

  ms_t ms_bad[1:0] = '{0, 0, 1, 1};            // ILLEGAL: 4 items, 2 elements
  ms_t ms_ok[1:0]  = '{'{0, 0}, '{1, 1}};

  assign x2   = y4;                            // ILLEGAL: shape [2][2] vs [4]
  assign x22  = x2;
  assign sa   = sx[0];                         // ILLEGAL: element to array
  assign sa   = sx;
  assign wi   = ye;                            // ILLEGAL: enum elements
  assign out8[3:0] = in8[0];                   // ILLEGAL: element to a slice
  assign out8[7:4] = in8[3:0];

  task automatic t1(output logic [7:0] buffer);
    buffer = 0;
  endtask

  B b; D d; C c; V v; VD vd; int i;

  initial begin
    q4 = q2;                                   // ILLEGAL: 2-state elements
    q4 = qs;                                   // ILLEGAL: signed elements
    q4 = qt;
    di = ds;                                   // ILLEGAL: 16-bit elements
    di = dr;                                   // ILLEGAL: real elements
    di = di2;
    di = new[4];
    t1(bf);                                    // ILLEGAL: array to a vector
    t1(bf[0]);

    b = new; d = new; c = new; vd = new;
    b = c;                                     // ILLEGAL: unrelated class
    b = d;
    d = b;                                     // ILLEGAL: base to derived
    b = C::new;                                // ILLEGAL: unrelated class
    b = D::new;
    v = new;                                   // ILLEGAL: virtual class
    v = vd;
    i = new;                                   // ILLEGAL: not a class
    di = new;                                  // ILLEGAL: not a class
  end

  assign o = a;
endmodule

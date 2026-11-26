// Operand-type and declaration rules.  Every line marked ILLEGAL draws
// exactly one error; the legal look-alikes beside them must stay silent.
module err_operand_decl_rules #(parameter int W = 4) (
  input  wire [3:0] a,
  output wire [3:0] y
);
  parameter real RP = 1.5;
  parameter string SP = "A";
  // ILLEGAL: a real operand of a wildcard equality (UH0753).
  parameter WEQ = 2'b01 ==? 0.0;
  // ILLEGAL: a real in a concatenation (UH0753).
  parameter real RC = {RP, RP};
  // Legal: real arithmetic and comparison.
  parameter real RS = RP * 2.0;
  parameter      RE = RP > 1.0;

  real r1, r2;
  string st;
  reg [1:0] lv;
  // ILLEGAL: a reduction of a real (UH0753).
  wire w1 = &r1;
  // ILLEGAL: a shift of a real (UH0753).
  wire w2 = r1 << 2;
  // ILLEGAL: a string operand of a wildcard equality (UH0753).
  wire w3 = lv ==? st;
  // Legal: string equality, real less-than.
  wire w4 = st == SP;
  wire w5 = r1 < r2;
  // ILLEGAL: $signed of a real (UH0753).
  reg [7:0] ival = $signed(1.0);
  // Legal: $signed of an integral value.
  wire [3:0] sv = $signed(a);

  event evt;
  function automatic logic f1(input logic arg);
    return arg;
  endfunction
  function void fv();
  endfunction
  task automatic t_ev(event e);
  endtask
  // ILLEGAL: an event passed as a value (UH0755).
  wire w6 = f1(evt);
  initial begin
    int x;
    // ILLEGAL: a void function used as a value (UH0754).
    x = fv() + 1;
    // Legal: a void function called as a statement, an event formal.
    fv();
    t_ev(evt);
  end

  class C;
    // ILLEGAL: a class method with static lifetime (CP0364).
    task static ts(int x);
    endtask
    // Legal: the default (automatic) lifetime.
    task tn(int x);
    endtask
  endclass
  // ILLEGAL: a queue net (CP0365).
  wire wq[$];
  // ILLEGAL: a string net (CP0365).
  wire string ws;
  // ILLEGAL: a class-typed net (CP0365).
  wire C wc;
  // Legal: an unpacked array of a 4-state vector.
  wire [3:0] wa [2];

  reg g;
  task automatic auto_task;
    reg l;
    static reg sl;
    C c1, c2;
    begin : blk
      // ILLEGAL: an automatic variable in a procedural continuous assign (CP0366).
      assign g = 1'(l);
      // ILLEGAL: a nonblocking assignment to an automatic variable (CP0366).
      c1 <= c2;
      // Legal: a static local in a procedural continuous assign.
      assign g = sl;
    end
  endtask

  integer N;
  // ILLEGAL: an attribute value naming a variable (CP0367).
  (* attr = N *)
  initial g = 0;
  // Legal: an attribute value naming a parameter, or a string.
  (* attr2 = W, keep = "true" *)
  reg kept;

  assign y = a;
endmodule

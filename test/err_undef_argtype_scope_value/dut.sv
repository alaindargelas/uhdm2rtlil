// Each illegal line below must be rejected; each legal one must not.
typedef struct packed {
  logic [UNDECL_W-1:0] a;            // illegal: UNDECL_W declared nowhere
  logic p;
} unit_t;

module sub; endmodule

module top(input logic [3:0] i, output logic [3:0] o);
  typedef logic [3:0] nib_t;
  localparam int W = $bits(top);     // illegal: a module name is no value
  event ev;
  sub u();

  task automatic t_bad(input no_such_t x);   // illegal: undefined type
  endtask
  task automatic t_ok(input nib_t x);        // legal
  endtask
  task t_nonansi;                            // legal: non-ANSI over a typedef
    input x;
    nib_t x;
  endtask

  integer val;
  initial begin
    val = $display;                  // illegal: system task as a value
    $dumpvars(0, top);               // legal: scope argument
    $dumpvars(1, u);
    @top.ev;                         // legal: hierarchical name
  end
  assign o = i;
endmodule

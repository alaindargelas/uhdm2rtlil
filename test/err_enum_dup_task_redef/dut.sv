// Duplicate enum values (LRM 6.19) and a task port redeclared after a
// variable of the same name.  Legal forms must stay silent; each ILLEGAL
// line is one error.
module err_enum_dup_task_redef (
  input  logic [1:0] a,
  output logic [3:0] y
);
  // Legal: distinct values, explicit and implicit.
  typedef enum logic [1:0] {S0, S1, S2 = 2'd3} ok_e;
  // ILLEGAL: `green` takes 2 implicitly, then `blue = 2`.
  typedef enum {red = 1, green, blue = 2} color_e;

  ok_e    st;
  color_e c;
  assign st = ok_e'(a);
  assign c  = red;

  // Legal: a variable completed by an untyped port, in either order.
  task automatic t_ok;
    output logic [3:0] o;
    integer k;
    input k;
    o = 4'(k);
  endtask
  // ILLEGAL: the port carries its own type after the variable.
  task automatic t_bad;
    output logic [3:0] o;
    integer x;
    input integer x;
    o = 4'(x);
  endtask

  always_comb begin
    t_ok(y, {30'd0, a});
    if (st == S2 && c == red) t_bad(y, 32'd1);
  end
endmodule

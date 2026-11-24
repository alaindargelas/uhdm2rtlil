// Four legal declarations Surelog used to leave unbound, each of which then
// read as an undeclared identifier (and, before the UH0737 lint, as an
// undriven 1-bit net):
//   * a $unit task (declared outside any module)          -- LRM 3.12.1
//   * a `let` imported from a package with `import p::*`   -- LRM 11.12
//   * a `var` function formal                              -- LRM 13.3
//   * a `specparam`, used like a parameter                 -- LRM 6.20.5
package unit_task_lets;
  let and_of(a, b) = a & b;
endpackage

task automatic invert_into(output logic [3:0] v, input logic [3:0] x);
  v = ~x;
endtask

module unit_task_specparam_var_let(input  logic [3:0] x, y,
                                   output logic [3:0] o_let, o_task, o_var,
                                   output logic [7:0] o_spec);
  import unit_task_lets::*;
  specparam SP = 5;
  function automatic logic [3:0] inc(var logic [3:0] v);
    return v + 4'd1;
  endfunction
  assign o_let = and_of(.b(y), .a(x));
  always_comb invert_into(o_task, x);
  assign o_var = inc(x);
  assign o_spec = SP;
endmodule

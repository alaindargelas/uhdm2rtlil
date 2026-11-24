// A non-ANSI task whose body declares a variable BEFORE the untyped port
// that it completes (`reg [7:0] a; input a;`), legal in either order
// (LRM 13.3).  Surelog used to compile such a leading variable as a plain
// statement, separate from the port scan.
module task_var_before_port (
  input  logic [7:0] x,
  input  logic [7:0] y,
  output logic [7:0] s,
  output logic [7:0] d
);
  task automatic addsub;
    reg [7:0] a;
    reg [7:0] b;
    input a;
    input b;
    output [7:0] sum;
    output [7:0] diff;
    begin
      sum  = a + b;
      diff = a - b;
    end
  endtask

  always_comb addsub(x, y, s, d);
endmodule

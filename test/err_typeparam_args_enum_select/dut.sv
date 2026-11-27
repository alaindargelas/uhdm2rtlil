// Each statement below is illegal and must be rejected.

module child #(type T = int, type U = int) (output int o);
  T x;
  U y;
  assign o = 0;
endmodule

module dut (input logic clk, output int o1, output int o2, output int r);
  typedef enum logic [1:0] {A, B} e_t;
  class C;
    e_t e;
  endclass

  // LRM 6.20.3: a type parameter takes a data type, not a value.
  child #(.T(10)) u_named (.o(o1));       // EL0556
  child #(3) u_pos (.o(o2));              // EL0556
  // Legal: data-type actuals, named and positional.
  child #(.T(logic [3:0])) u_ok1 (.o());
  child #(byte, e_t) u_ok2 (.o());

  function int f(int a = 1, int b = 2);
    return a + 10 * b;
  endfunction

  C c;
  int s;
  initial begin
    // LRM 13.5.3: three empty arguments for two formals.
    r = f( , , );                         // UH0741
    r = f( , 5);                          // legal: a defaulted first slot
    c = new;
    // LRM 6.19.3: no implicit conversion from int to an enum.
    c.e = 2;                              // UH0739
    c.e = B;                              // legal
  end

  // An undeclared name under a part-select.
  logic [15:0] declared_sig;
  assign declared_sig = 16'h1234;
  always @(posedge clk) s <= undeclared_sig[7:0];   // UH0737
  always @(posedge clk) r <= declared_sig[7:0];     // legal
endmodule

// Four declaration rules the front end enforces:
//  * a `parameter` in the body of a module that has a parameter port list is a
//    localparam (LRM 6.20.1): neither `#(.B(..))` nor `defparam` may set it;
//  * only a parameter of a `#(...)` port list may omit its default;
//  * a generate loop iterates a genvar (LRM 27.4);
//  * a stream used as a value must fit its target (LRM 11.4.14).
module a #(parameter A = 1, parameter Q = 2);
  parameter B = 1;               // local: the module has a port list
endmodule

module nodef;
  parameter N;                   // error: no default outside a port list
endmodule

module top(input logic [7:0] x, output logic [31:0] y);
  a #(.A(10), .Q(3)) u_ok();     // legal: A and Q are port parameters
  a #(.B(20)) u_bad();           // error: B is local
  a u_def();
  defparam u_def.B = 30;         // error: B is local
  nodef #(.N(4)) u_nd();

  integer i;
  genvar g;
  for (i = 0; i < 2; i = i + 1) begin : bad_loop   // error: i is no genvar
  end
  for (g = 0; g < 2; g = g + 1) begin : ok_loop
  end
  for (genvar k = 0; k < 2; k++) begin : inline_loop
  end

  int p = 1, q = 2, r = 3;
  logic [95:0] w;
  initial begin
    int d;
    w = {<<{p, q, r}};           // legal: exact fit
    d = {<<{p, q, r}};           // error: 96 bits into 32
  end
  assign y = {<<8{x}};           // legal: narrower source is padded
endmodule

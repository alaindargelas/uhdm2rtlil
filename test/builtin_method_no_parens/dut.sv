// Built-in methods called without parentheses (LRM 13.4.1): `c.num`,
// `b.sum`, `b.product` are method calls, not unresolved hierarchical
// references (Surelog/UHDM reported UH0725).  A struct member named like a
// method, read through an array element, stays a member.
//
// UHDM-only: yosys's read_verilog declares `c1.num` / `b.sum` as implicit
// 1-bit wires, so its netlist is no reference; the function `return` makes it
// reject the file.  Gated by test_structural.ys (values) and the co-sim; read_slang
// has no `sum` / `product` ("unsupported system task"), so no miter.
module builtin_method_no_parens(input logic [3:0] a, output int o_num, output int o_sum,
                                output int o_prod, output logic [3:0] o_size);
  typedef enum logic [1:0] {A, B, C} e_t;
  typedef struct packed { logic [3:0] size; } s_t;
  e_t c1;
  int b [3];
  s_t arr [2];
  function automatic int dbl(int x);
    return 2 * x;
  endfunction
  always_comb begin
    b[0] = 1; b[1] = 2; b[2] = int'(a);
    arr[0].size = 4'd1;
    arr[1].size = a;
    o_num  = c1.num;
    o_sum  = dbl(b.sum) / 2;
    o_prod = b.product;
    o_size = arr[1].size;
  end
endmodule

// An UNPACKED ARRAY local of an automatic function is automatic too (LRM
// 13.4.2): it must not become a static register.  Surelog flags such an
// array's automatic-ness only on its element variable, and reading the
// array_var alone backed rggen's get_hw_next_value.set_clear with a static
// register whose 0 init then conflicted in the formal miter
// ("Conflicting init values").  `calls` is a genuine static local and keeps
// its register.
module dut(input logic clk, input logic [1:0] s, c, output logic [1:0] q,
           output logic [1:0] n);
  function automatic logic [1:0] nxt(logic [1:0] cur, logic [1:0] set, logic [1:0] clr);
    logic [1:0] sc[2];
    logic [1:0] v;
    sc[0] = set;
    sc[1] = clr;
    v = cur;
    for (int i = 0; i < 2; ++i) begin
      if (sc[0][i]) v[i] = 1'b1;
      else if (sc[1][i]) v[i] = 1'b0;
    end
    return v;
  endfunction
  function automatic logic [1:0] count();
    static logic [1:0] calls;
    calls = calls + 2'd1;
    return calls;
  endfunction
  always_ff @(posedge clk) begin
    q <= nxt(q, s, c);
    n <= count();
  end
endmodule

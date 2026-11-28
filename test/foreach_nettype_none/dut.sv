`default_nettype none
// foreach loop variables are declared by the foreach, not implicit nets
// (Surelog reported EL0535 "Illegal implicit net" under default_nettype none).
module foreach_nettype_none(input wire logic [3:0] a, output logic [3:0] y);
  logic [3:0] t [2][2];
  always_comb begin
    foreach (t[i, j]) t[i][j] = a + 4'(i * 2 + j);
    y = t[1][1];
  end
endmodule
`default_nettype wire

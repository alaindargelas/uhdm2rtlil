// Variable drivers (LRM 6.5), index and loop-variable counts (LRM 7.4.5,
// 11.5.1, 12.7.3) and assignment patterns for scalars (LRM 10.9).  Every
// line marked ILLEGAL must be reported; each legal look-alike next to it
// must stay silent.
module dut(input logic clk, input logic [3:0] a, output logic [3:0] o);
  int v1, v2, v3, v4;
  assign v1 = 12;
  assign v1 = 13;                              // ILLEGAL: second assign
  assign v2 = 1;
  always @(posedge clk) v2 <= ~v2;             // (reported on the assign)
  assign v3 = 2;
  always @(posedge clk) v4 <= v3;
  wire w;
  assign w = a[0];
  assign w = a[1];

  reg [15:0] mem [3:0];
  reg [15:0] vec;
  logic [3:0] val;
  logic arr1 [10];
  logic [3:0] arr2 [2];

  bit  s_bad = '{1'b1};                        // ILLEGAL: pattern for a bit
  bit  [1:0] s_ok = '{1'b1, 1'b0};
  logic u_ok [1:0] = '{0, 1};

  initial begin
    val = mem[0][0];
    val = mem[0][0][3:0];                      // ILLEGAL: 3 indices, 2 dims
    val = vec[0][0];                           // ILLEGAL: 2 indices, 1 dim
    val = vec[3:0];
    foreach (arr1[i, j]) val = 0;              // ILLEGAL: 2 loop variables
    foreach (arr1[i]) val = 1;
    foreach (arr2[i, j]) val = 2;
  end

  assign o = a;
endmodule

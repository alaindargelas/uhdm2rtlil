// A select whose index or width is not constant where the LRM requires one.
// The legal forms below must stay silent; each ILLEGAL line is one error.
module err_nonconst_select #(parameter int W = 8) (
  input  logic       clk,
  input  logic [2:0] n,
  input  logic [7:0] d,
  output logic [7:0] q,
  output logic [7:0] r
);
  logic [7:0] arr [8];
  logic [7:0] row;
  logic [15:0] acc;

  // Legal: genvar-indexed targets, parameter bounds, constant-width slides.
  for (genvar g = 0; g < 8; g++) begin : g_arr
    assign arr[g] = d ^ 8'(g);
  end
  assign row[W-1:4] = d[3:0];
  assign row[3:0]   = d[7:4];

  always_ff @(posedge clk)
    for (int i = 0; i < 8; i++) acc[i+1 -: 2] <= {d[i], row[i]};

  // Illegal: a variable index in a continuous-assignment target
  // (LRM 10.3.1) and a part-select whose WIDTH varies (LRM 11.5.1).
  logic [7:0] tgt [8];
  assign tgt[n] = d;                    // ILLEGAL: variable element index
  assign q = arr[n];
  always_comb begin
    r = '0;
    r[n:0] = d[n:0];                    // ILLEGAL x2: variable width
  end
endmodule

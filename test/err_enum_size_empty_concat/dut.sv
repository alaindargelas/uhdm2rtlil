// A sized enum literal of the wrong width (LRM 6.19) and a concatenation
// made only of zero-width replications (LRM 11.4.12.1).  Legal forms must
// stay silent; each ILLEGAL line is one error.
module err_enum_size_empty_concat (
  input  logic       s,
  output logic [7:0] y,
  output logic [7:0] z
);
  // Legal: matching sized literals, unsized and fill literals.
  typedef enum logic [2:0] {A = 3'd1, B = 3'd2, C = 'b100, D} ok_e;
  // ILLEGAL: a 4-bit literal in a 3-bit enum.
  typedef enum logic [2:0] {E = 4'h2, F = 3'd3} bad_e;

  ok_e  o;
  bad_e b;
  assign o = A;
  assign b = F;

  // Legal: a zero replication beside real bits.
  assign y = {{0{s}}, 8'h5a};
  // ILLEGAL: nothing but a zero replication.
  always_comb z = {{0{s}}};
endmodule

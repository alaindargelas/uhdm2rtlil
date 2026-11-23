// A replication count must not be negative (LRM 11.4.12.1), and an indexed
// part-select width and a size cast must be positive (11.5.1, 6.24.1).
// Each was accepted and imported as something; UHDM / Surelog now report
// UH0731 (non-positive value).  Icarus ivtest pr1925363a, pr3549328,
// size_cast_fail1/2.
module err_nonpositive_size(input logic [7:0] a, input int x,
                            output logic [31:0] r, output logic p,
                            output int y);
  localparam int W = 9;
  localparam int Z = 0;
  localparam int N = -1;
  assign r = {(W-16){8'b0}};     // count -7
  assign p = |a[1 +: Z];         // width 0
  assign y = N'(x);              // size -1
endmodule

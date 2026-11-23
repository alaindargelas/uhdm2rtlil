// A whole unpacked array must be assigned an unpacked array of the same
// shape (LRM 7.6); a vector was accepted.  UHDM #1189 / Surelog #4290
// report UH0736.  Icarus ivtest sv_array_cassign_fail1/2/6/7/8.
module err_unpacked_assign(input logic [1:0] y, output logic [1:0] o);
  wire [1:0] x[1:0];
  assign x = y;
  assign o = x[0];
endmodule

// Two declarations of one name in a module scope are illegal (LRM 3.13);
// Surelog accepted them and the second silently shadowed the first.  It now
// reports CP0346 (Surelog #4285).  Icarus ivtest redef_reg_error and others.
module err_dup_signal(input logic [7:0] a, output logic [7:0] y);
  reg [7:0] value, value;
  assign value = a;
  assign y = value;
endmodule

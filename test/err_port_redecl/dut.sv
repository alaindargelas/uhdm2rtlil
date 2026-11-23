// A non-ANSI port with a range, completed by a declaration with a different
// shape (LRM 23.2.2.1): the shortint replaced the port's [15:0] silently.
// Surelog #4287 reports CP0347.  Icarus ivtest module_nonansi_*_fail.
module err_port_redecl(x);
  output [15:0] x;
  shortint x;
  assign x = 16'h1234;
endmodule

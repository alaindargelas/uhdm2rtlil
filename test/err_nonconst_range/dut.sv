// A constant expression may not read a net (LRM 11.2.1): here a declaration
// range bound is an input port.  Accepted silently before; UHDM #1187 /
// Surelog #4286 report UH0734.  Icarus ivtest check_constant_5..20.
module err_nonconst_range(input wire [2:0] N, input wire [7:N] in,
                          output wire [7:0] out);
  assign out = in;
endmodule

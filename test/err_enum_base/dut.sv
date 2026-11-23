// An enum's base type must be integral with at most one packed dimension
// (LRM 6.19).  A `real` (or an unpacked array, queue, struct, string, ...)
// base was accepted; UHDM #1188 / Surelog #4289 report UH0735.  Icarus
// ivtest enum_base_fail_*.
module err_enum_base(output logic o);
  typedef real T;
  enum T { A } e;
  assign o = 1'b0;
endmodule

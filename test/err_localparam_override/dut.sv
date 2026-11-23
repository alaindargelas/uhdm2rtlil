// A localparam cannot be overridden (LRM 6.20.4).  The override was APPLIED,
// so the child used 10 instead of its declared 1.  Surelog #4288 reports
// EL0553 for both a named override and a defparam.  Icarus ivtest
// parameter_override_invalid3/4/8.
module child(output logic [7:0] o);
  localparam A = 1;
  assign o = A;
endmodule
module err_localparam_override(output logic [7:0] o1, o2);
  child #(.A(10)) u1(.o(o1));
  child u2(.o(o2));
  defparam u2.A = 20;
endmodule

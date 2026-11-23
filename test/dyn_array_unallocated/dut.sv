// A dynamic array or queue that is never allocated with a constant `new[N]`
// has no known element count.  Since dynamic arrays became per-element wires
// sized by their `new[N]`, such an array got ZERO element wires and every
// read `d[i]` aborted the read with "Could not find wire 'd' for bit select"
// (Icarus ivtest sv_darray_oob_real/string, sv_queue1, sv_queue_oob_*).  It
// keeps the whole-array fallback; an allocated one is unaffected.
module dyn_array_unallocated(output logic o, output logic [7:0] a1);
  real d[];
  int q[$];
  reg [7:0] a[];
  real x;
  initial begin
    x = d[1];                 // never allocated
    q.push_back(5);           // a queue grows without new[]
    a = new[2];
    a[1] = 8'h5a;
  end
  assign o = (q[0] == 5);
  assign a1 = a[1];
endmodule

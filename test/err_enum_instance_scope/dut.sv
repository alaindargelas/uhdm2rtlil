// Two enum scope rules the lint enforces (LRM 6.19, 6.22.1):
//  * an enum declared inside a module is a distinct type in every instance of
//    that module, so `m1.e = m2.e` needs a cast even though the members match;
//  * an enum constant lives in the scope of its enum, so in a class it may not
//    share a name with a typedef there.
package p;
  typedef enum {X, Y} pe_t;
endpackage

module M;
  enum integer { A } e, f;
  p::pe_t q;
  initial e = f;                 // same instance, same type: legal
endmodule

module N #(parameter type T = p::pe_t);
  T v;
endmodule

module top(input logic i, output logic o);
  M m1();
  M m2();
  N n1();
  N n2();

  class C;
    enum { K = 10 } k;
    typedef int K;               // error: K is already an enum constant
  endclass

  class D;                       // legal: no name shared with a constant
    typedef enum {R, S} rs_t;
    rs_t r;
    int s2;
  endclass

  initial begin
    m1.e = m2.e;                 // error: two different anonymous enum types
    m1.q = m2.q;                 // legal: one package type
    n1.v = n2.v;                 // legal: one type parameter default
  end

  assign o = i;
endmodule

// LRM 6.19.3: a value assigned to an enum must be of that enum type.  The
// legal forms below must stay silent; each ILLEGAL line is one error.
package err_enum_assign_pkg;
  typedef enum logic [1:0] {IDLE, RUN, DONE} state_e;
endpackage

module err_enum_assign
  import err_enum_assign_pkg::*;
(
  input  logic       clk,
  input  logic       go,
  input  logic [1:0] raw,
  output state_e     q,
  output state_e     r
);
  typedef struct packed { state_e st; logic v; } tag_t;
  localparam state_e START = IDLE;

  function automatic state_e advance(state_e s);
    return (s == DONE) ? IDLE : s.next();
  endfunction

  function automatic state_e from_raw(logic [1:0] x);
    return state_e'(x);
  endfunction

  state_e hist [2];
  tag_t   tag;
  state_e nxt;

  // Legal: enum constants, parameters, casts, conditionals, same-type
  // variables, functions returning the enum, array elements, members.
  always_comb begin
    nxt = START;
    if (go) nxt = advance(q);
    else if (raw == 2'd3) nxt = from_raw(raw);
    tag.st = go ? RUN : IDLE;
    tag.v = 1'b1;
  end

  always_ff @(posedge clk) begin
    q <= nxt;
    hist[0] <= q;
    hist[1] <= hist[0];
  end

  // Illegal: an integer, arithmetic on an enum, an int array element.
  int counts [2];
  assign counts[0] = 1;
  assign counts[1] = 2;
  always_comb begin
    r = hist[1];
    if (raw == 2'd0) r = 1;            // ILLEGAL: int into enum
    if (raw == 2'd1) r = q + 1;        // ILLEGAL: arithmetic result
    if (raw == 2'd2) r = counts[0];    // ILLEGAL: int array element
  end
endmodule

// A size or bound with unknown (x/z) bits, and calls with the wrong number
// of arguments.  The legal forms must stay silent; each ILLEGAL line is one
// error.
module err_xz_size_argcount (
  input  logic [7:0] a,
  output logic [7:0] y,
  output logic [7:0] z,
  output logic [31:0] w
);
  localparam int N = 4;
  localparam logic [3:0] PX = 4'bx;          // x as DATA: legal
  localparam integer LPX = 32'b01x;

  function automatic logic [7:0] add(logic [7:0] p, logic [7:0] q = 8'd1);
    return p + q;
  endfunction
  function automatic logic [7:0] ones();
    return '1;
  endfunction

  // Legal: a defaulted formal left out, a zero-argument call, x data.
  assign y = add(a) ^ add(a, 8'd2) ^ ones();
  assign w = {N{a}};
  logic [3:0] data_x;
  assign data_x = PX;

  // Illegal.
  logic [LPX:0] bad_range;                   // ILLEGAL: x range bound
  assign bad_range = '0;
  assign z = add(a, a, a);                   // ILLEGAL: 3 arguments for 2
  logic [7:0] z2;
  assign z2 = add();                         // ILLEGAL: `p` has no default
endmodule

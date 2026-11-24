// A positional assignment pattern with the wrong number of elements
// (LRM 10.9.1).  The legal forms must stay silent; each ILLEGAL line is one
// error.
module err_pattern_count (
  input  logic [7:0] a,
  output logic [7:0] y
);
  typedef struct packed { logic [3:0] hi; logic [3:0] lo; } pair_t;
  typedef struct packed { logic [9:0] v; } one_t;

  // Legal: matching counts, named / default members, replication, arrays.
  pair_t       p_ok  = '{4'h1, 4'h2};
  pair_t       p_def = '{default: 4'h0};
  pair_t       p_nam = '{lo: 4'h3, hi: 4'h4};
  logic [3:0]  v_ok  = '{1'b1, 1'b0, 1'b1, 1'b0};
  logic [1:0][3:0] w_rep = '{2{4'h5}};
  logic [7:0]  arr [4] = '{8'd1, 8'd2, 8'd3, 8'd4};
  one_t [1:0]  ps    = '{10'd15, 10'd0};
  pair_t       parr [2] = '{8'h12, 8'h34};

  // Illegal.
  pair_t       p_few  = '{4'h1};                    // ILLEGAL: 1 for 2
  logic [2:0][3:0] w_many = '{4'h1, 4'h2, 4'h3, 4'h4};  // ILLEGAL: 4 for 3
  pair_t       p_asg;
  always_comb p_asg = '{4'h1, 4'h2, 4'h3};          // ILLEGAL: 3 for 2

  assign y = p_ok ^ p_def ^ p_nam ^ {v_ok, v_ok} ^ w_rep ^ arr[a[1:0]] ^
             ps[0][7:0] ^ parr[a[0]] ^ p_few ^ w_many[0] ^ p_asg;
endmodule

// A NET's declaration initializer is a continuous assignment (IEEE 1800-2017
// 10.3.1), not an initial value.  read_uhdm stamped an \init on the wire, and
// with the source's own `assign` of the same x-carrying constant beside it,
// yosys's `check` aborted: "Conflicting init values for signal 1'0
// (\b [1] = 1'0 != 1'x)".  Every sv-tests equality_operator_sim_N template
// test has exactly this shape.  A reg initializer (`r_init`) keeps its \init.
module net_decl_init_continuous (
  input  logic       clk,
  input  logic [3:0] d,
  output logic       eq,
  output logic [3:0] n_o,
  output logic [3:0] q
);
  wire [7:0] a = 8'b1101x001;
  wire [7:0] b = 8'b1101x000;
  assign a = 8'b1101x001;
  assign b = 8'b1101x000;
  assign eq = (a[7:4] == b[7:4]);

  wire [3:0] n = 4'd6;
  assign n_o = n;

  reg [3:0] r_init = 4'd5;
  always @(posedge clk) r_init <= d;
  assign q = r_init;
endmodule

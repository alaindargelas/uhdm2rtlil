// An enum value may read a module parameter (Surelog reported EL0514
// "Undefined variable").
module enum_value_module_param(output logic [3:0] o1, output logic [3:0] o2, output logic [3:0] o3);
  localparam S = 2;
  parameter P = 5;
  enum logic [3:0] { A = S + 1, B } e1;
  typedef enum logic [3:0] { C = S, D = P } e_t;
  assign o1 = A;
  assign o2 = B;
  assign o3 = D;
endmodule

// `var` declarations inside a procedural block (LRM 6.8): the `var` keyword
// with an implicit type is a logic variable whose signing and packed
// dimensions follow the keyword.  Surelog rejected every such declaration as
// an "Unsupported statement" (UH0701), and each later write to the variable
// as "Illegal lhs of type wire" (UH0718).  ivtest sv_var_block.
module var_decl_in_block(input logic [7:0] d,
                         output logic o1, output logic [7:0] o8,
                         output logic signed [8:0] os, output logic [9:0] ow);
  always_comb begin
    var x;
    var [7:0] y;
    var signed [8:0] z;
    var logic [9:0] w;
    x = d[0];
    y = d;
    z = -9'sd1;
    w = {2'b11, d};
    o1 = x;
    o8 = y;
    os = z;
    ow = w;
  end
endmodule

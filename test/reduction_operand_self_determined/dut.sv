// A reduction's operand is self-determined (IEEE 1800 Table 11-21): `|(~a)`
// inverts `a` at its OWN 8 bits whatever the reduction sits in.  Under the
// 32-bit context of a comparison against an unsized literal, the operand was
// extended before the NOT, so the upper 24 inverted zeros made every
// reduction of `~a` constant (OpenPiton bram_1r1w_wrapper's BIST
// `init_done_next = ((|(~bist_index)) == 0) | init_done` never fired).
module dut(input [7:0] a, input [3:0] b,
           output y_or, output y_and, output y_xor,
           output y_nor, output y_nand, output y_xnor, output y_ne);
  assign y_or   = ((|(~a)) == 0);
  assign y_and  = ((&(~a)) == 1);
  assign y_xor  = ((^(~a)) == 0);
  assign y_nor  = ((~|(~a)) == 1);
  assign y_nand = ((~&(~a)) == 0);
  assign y_xnor = ((~^(~b)) == 1);
  assign y_ne   = ((|(a + 8'd1)) != 32'd0);
endmodule

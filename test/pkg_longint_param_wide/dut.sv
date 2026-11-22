// A package parameter whose value does not fit in 32 bits.  Surelog folds
// `2**33` to the decimal `INT:8589934592`, and read_uhdm parsed `INT:` with
// std::stoi: the uncaught std::out_of_range aborted the whole read
// ("terminate called ... stoi").  basejump_stl's bsg_dramsim3_pkg has exactly
// this (`parameter longint size_in_bits_p=2**33;`), and since that package is
// in every sv-tests basejump test's file list, all 357 of them crashed.
// A decimal LITERAL past 63 bits had the same problem in the vpiDecConst
// path (std::stoll: "Failed to parse decimal constant", ivtest pow_unsigned).
// The values also check the width and sign of the parsed constant.
package wide_pkg;
  parameter longint SIZE_BITS = 2**33;
  parameter longint NEG_BIG   = -(2**40) + 5;
  parameter int     NEG_MIN   = -2147483648;
endpackage

module dut (
  output logic [63:0] size_bits,
  output logic [63:0] neg_big,
  output logic [31:0] neg_min,
  output logic [99:0] big_dec
);
  assign size_bits = wide_pkg::SIZE_BITS;
  assign neg_big   = wide_pkg::NEG_BIG;
  assign neg_min   = wide_pkg::NEG_MIN;
  assign big_dec   = 100'd277555756156289135105907917022705078125;
endmodule

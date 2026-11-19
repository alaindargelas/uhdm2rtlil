# Since Yosys 0.71, synth maps this design's async-reset + clock-enable
# registers to $_DFFE_PP0P_ on BOTH sides (28 cells each).  Re-read from the
# synth netlists they are public-typed, so plain async2sync skips them and
# equiv_induct aborts with "No SAT model available".  formal mode adds the
# async-DFFE chtype maps and lowers them with async2sync after equiv_make.
# formal: 1

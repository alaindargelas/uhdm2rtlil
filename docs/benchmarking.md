# Benchmarking against the reference frontends

`read_uhdm` is measured against `read_slang` (Yosys's built-in sv-elab
frontend) on every design the nightly sweeps touch, and against `sv2v` and
the native `read_verilog` on the test corpus -- the same designs, the same
checks, the same random stimulus.  The headline numbers are in the
[README](../README.md#supported-core-ip); this page is the full account: the
per-core co-simulation table, the reference frontend's own record, and the
4-frontend matrix.  Every figure is produced by a script over the run
artifacts named here, not kept by hand.

## Nightly sweeps: co-simulation per core, `read_slang` vs `read_uhdm`

Every sweep row co-simulates **both** netlists against the same RTL under the
same random stimulus, so the reference frontend is measured by the same yardstick
as this one.  The columns are disjoint counts and the arithmetic holds on every
line and in the total:

- *co-simulated* = rows whose netlist got a Verilator run at all;
  **Rows − co-simulated** = rows with no co-sim for that netlist (no ports — 514
  of the 526 sv-tests snippets — no buildable testbench, no default
  elaboration, or a formal-only instantiation row).
- `read_slang`: **co-simulated = pass + diverge + artefact / no oracle**, counted
  the same way as ours: *artefact* is a row where BOTH netlists diverge from the
  RTL identically (or the miter adjudicates the divergence), *no oracle* a row
  whose RTL is inert under Verilator -- neither is a verdict on slang -- and
  **diverge** is a row where our netlist tracks the RTL and slang's does not:
  the "bug" class of [slang_unsupported.md](slang_unsupported.md), row for row.
- `read_uhdm`: **co-simulated = pass + diverge + artefact**, where *artefact* is
  a divergence a SAT miter proved to be a simulation artefact (X-semantics,
  unique/priority-case violation stimulus), not a reader defect, and
  **diverge** is a real one.
- The rows are the rows of the README's [Supported Core IP](../README.md#supported-core-ip)
  table, in its order (the sweep links are there); the XiangShan library has its own row, so the
  External IP row is the other 40 repos and every column sums to its total.
  The script asserts both identities before printing.

| Core | Rows | Formal proven | `read_slang` co-simulated | pass | **diverge** | artefact / no oracle | `read_uhdm` co-simulated | pass | **diverge** | artefact | Undriven |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| **Ibex** | 28 | 22 | 24 | 21 | 0 | 3 | 25 | 21 | 0 | 4 | 0 |
| **rp32 (R5P)** | 13 | 5 | 5 | 2 | 0 | 3 | 6 | 2 | 0 | 4 | 0 |
| **fx68k** | 22 | 19 | 13 | 7 | 0 | 6 | 12 | 8 | 0 | 4 | 0 |
| **Syntacore SCR1** | 37 | 29 | 36 | 36 | 0 | 0 | 36 | 36 | 0 | 0 | 0 |
| **RgGen** | 25 | 23 | 23 | 23 | 0 | 0 | 23 | 23 | 0 | 0 | 0 |
| **VeeR EH1** | 67 | 54 | 62 | 62 | 0 | 0 | 62 | 62 | 0 | 0 | 0 |
| **TNoC** | 43 | 18 | 9 | 9 | 0 | 0 | 9 | 9 | 0 | 0 | 0 |
| **VeeR EL2** | 91 | 78 | 82 | 82 | 0 | 0 | 83 | 83 | 0 | 0 | 0 |
| **VeeR EH2** | 100 | 81 | 94 | 92 | **2** | 0 | 94 | 93 | 0 | 1 | 0 |
| **RSD** | 165 | 118 | 137 | 133 | **3** | 1 | 140 | 139 | 0 | 1 | 0 |
| **BlackParrot** | 121 | 54 | 62 | 58 | **2** | 2 | 69 | 61 | **6** | 2 | 0 |
| **OpenTitan** (upstream) | 32 | 28 | 29 | 28 | 0 | 1 | 29 | 28 | 0 | 1 | 0 |
| **OpenTitan IP library** (upstream, the other 44 blocks) | 605 | 508 | 506 | 498 | **2** | 6 | 506 | 500 | **1** | 5 | 0 |
| **Pavona** (300 modules + 100 chip instances) | 400 | 382 | 389 | 380 | 0 | 9 | 389 | 380 | 0 | 9 | 0 |
| **Ariane CVA6** (142 modules + 138 core instantiations, the latter formal-only) | 280 | 228 | 133 | 126 | **1** | 6 | 133 | 127 | 0 | 6 | 0 |
| **Ariane CVA6 flavours** (the three other sv-tests configurations: HPDcache, H-extension, RV32) | 429 | 304 | 396 | 368 | **8** | 20 | 396 | 376 | 0 | 20 | 0 |
| **Caliptra** | 22 | 19 | 21 | 21 | 0 | 0 | 21 | 21 | 0 | 0 | 0 |
| **XiangShan** (香山) | 21 | 18 | 21 | 21 | 0 | 0 | 21 | 21 | 0 | 0 | 0 |
| **XiangShan core** (香山) | 2002 | 1608 | 1876 | 1873 | **3** | 0 | 1877 | 1877 | 0 | 0 | 0 |
| **External IP** (the other 40 repos; the XiangShan library is the row above) | 6812 | 5551 | 5721 | 5635 | **37** | 49 | 5848 | 5756 | **9** | 83 | 0 |
| **chipsalliance/sv-tests** | 708 | 17 | 10 | 10 | 0 | 0 | 10 | 10 | 0 | 0 | 0 |
| **sv-synth-tests** (the converted sv-tests of `test/sv_tests`) | 434 | 419 | 401 | 391 | **1** | 9 | 411 | 401 | 0 | 10 | 0 |
| **sv-yosys-issues** (the YosysHQ/yosys SystemVerilog-issue corpus of `test/yosys_issues`) | 212 | 151 | 150 | 141 | 0 | 9 | 177 | 162 | **1** | 14 | 0 |
| **sv-elab-issues** (the povik/sv-elab issue corpus of `test/sv_elab_issues`) | 138 | 60 | 49 | 46 | **1** | 2 | 62 | 58 | 0 | 4 | 0 |
| **slang-issues** (the MikePopoloski/slang synthesizable issue corpus of `test/slang_issues`) | 178 | 65 | 55 | 49 | **2** | 4 | 65 | 53 | **3** | 9 | 0 |
| **All sweeps** (23 workflows) | **12985** | **9859** | **10304** | **10112** | **62** | **130** | **10504** | **10307** | **20** | **177** | **0** |

**20 `read_uhdm` divergences** across 10504 co-simulated rows: 10307 pass
outright and 177 are divergences a SAT miter proved to be simulation
artefacts.  The 20:

| family | rows | status |
|---|---|---|
| BlackParrot | 6 | `bp_be_dcache` (106 cycles), `bp_be_pipe_mem` (10) and `bp_core_lite` (212), `read_slang` clean -- OPEN; all three contain the data cache, `bp_be_dcache` being the smallest.  `bp_core_complex` (46), `bp_l2e_tile_node` (29) and `bp_multicore` (279): no `read_slang` netlist to adjudicate against.  None of the six had been co-simulated before: `read_slang` could not read the first three until #1628, and the whole cores did not elaborate until Surelog 1.89 |
| Cheshire, CORE-V MCU, PULPissimo | 7 | rows `read_slang` cannot read, so there is no reference to adjudicate against: simulation models (`SimDTM`, `tcdm_model`, `obi_sim_mem`, `cam_vip`) and interface shims (`apbt1_interface`, `tcdm_interface`, `axi_rt_unit_top_xilinx`) |
| OpenPiton | 2 | `l2_state` / `l2_state_wrap`, 1 and 4 cycles, `read_slang` clean -- FIXED by #1626 (a reduction operand sized by its comparison's context); both rows re-measured equivalent with co-sim PASS, and drop out of this count at the next openpiton sweep |
| OpenTitan IP library | 1 | `rstmgr_crash_info`, 202 cycles; `read_slang` cannot elaborate it -- OPEN |
| sv-yosys-issues | 1 | issue #4574 (shareable memory ports), 161 cycles; `read_slang` cannot run it -- OPEN |
| slang-issues | 3 | #1124 and #331 (`read_slang` cannot read them) and #1154 -- OPEN |

`read_slang`, measured on the same rows under the same stimulus, diverges on
62 of its own (130 more rows are divergences both netlists share, the miter
adjudicated, or have no oracle).  The `read_slang` divergences are listed with
their reasons in [slang_unsupported.md](slang_unsupported.md).

### Provenance

The numbers are the **latest passing run of each of the 23 sweep workflows**,
2026-11-13 to 2026-11-20, 83 family reports in `build/sweeps/_night1120`,
counted by [`test/sweep_table.py`](../test/sweep_table.py): **12985 rows, 9859
formally proven, `read_uhdm` 10307 co-sim passes, `read_slang` 10112**, 0
undriven.  Two reports come from an earlier run because their latest one is
not a measurement: `cva6-chip` (CVA6's 138 core instantiations) from run
43412896065 (2026-11-13) -- the 2026-11-19 run checked 0 instances, because
Yosys 0.71's `write_rtlil` emits opaque names the chip flow's parser does not
match -- and Pavona's `dragonfly` chip from run 43418474506 (2026-11-17) --
the 2026-11-18 run's `read_uhdm` aborted on it.  BlackParrot is run
44762800276 (2026-11-20, the first on Surelog 1.89) for 93 rows; two of its
eight shards lost their runner (`bp_processor`, `bp_unicore` and `bp_core_tile`
exhaust a 16 GB runner after elaboration), so their other 28 rows come from
run 44569024237 (2026-11-19).

Run ids: ibex 44504032091, rp32 44288489743, fx68k 44350613084, scr1
44285880138, rggen 44240724529, veer-eh1 43587204429, tnoc 44240875698,
veer-el2 44545955378, veer-eh2 44308586589, rsd 43591293624, black-parrot
44762800276 (+ 44569024237), opentitan 43446954850, ext (External IP + OpenTitan IP library +
XiangShan library) 43587707813, pavona 44302889060, cva6 44517128170,
cva6-flavours 44313299440, caliptra 44319308050, xiangshan-core 44314007261,
sv-tests 44521091542, sv-synth-tests 44309068602, sv-yosys-issues
44537507899, sv-elab-issues 44318203781, slang-issues 44546639557.

### Formal-only `differs` rows that are adjudicated non-defects

- **CVA6's 5 `differs` rows are adjudicated non-defects**, each re-checked on
  2026-10-19 against its own counterexample: `hpdcache_cmo` is a
  **unique-case violation** (the solver sets `is_flush_by_nline`,
  `is_flush_all` and `is_fence` at once, so two arms of
  `unique case (1'b1)` match and either lowering is licensed);
  `hpdcache_uncached` is **unprovable by construction** -- the differing bit
  is in `mem_req_atomic`, which that `always_comb` never assigns on the path
  taken, and BOTH netlists then hold it through the same combinational
  self-hold, which SAT reads as two independent free values;
  `csr_regfile` is an **init-state** difference, because we fold `dcsr`'s
  reset-only `xdebugver` field to a constant while `read_slang` keeps a flop
  and the miter's `-set-init-zero` pins both initial states to 0;
  `macro_decoder` and `zcmt_decoder` are **latch-vs-self-feedback** -- we
  infer a latch for a comb variable the source leaves unassigned on the
  illegal-instruction path (22 and 5 of them) where `read_slang` builds a
  combinational loop SAT treats as free.  Every undriven row is a net the
  source never assigns, which the sweeps tell apart from a dropped driver.
- **Still open on our side:** the sweep rows where `read_slang` tracks the RTL and
  we do not are listed, in the same format as slang's own failures, in the "other
  direction" section of [docs/slang_unsupported.md](docs/slang_unsupported.md).
- CVA6 is the one family excluded from the local `--no-cva6` developer run, so
  read the nightly rather than a local run for its figures.

## The reference frontend's own record

**How the reference frontend itself does.** The left-most column of every sweep
table co-simulates the `read_slang` netlist against the same RTL, so the sweeps
also measure the frontend they compare against.  Every row where it does not
track the RTL -- and every design it cannot read at all, in the sweeps, in the
local test suite and in the upstream Yosys tests -- is collected in ONE report,
[slang_unsupported.md](slang_unsupported.md): one format (reason, link
to the test, recipe to reproduce), the recipes described up front.  Rows the
harness could not give slang a fair run on (a module no file of the test defines,
a test invalid on purpose, a design no frontend elaborates, a co-sim both netlists
fail identically) are in [incomplete_testcases.md](incomplete_testcases.md)
with a statement of which frontends fail on them.  The same report lists the
**other direction** -- rows where `read_slang` is clean and OURS is wrong --
because a document that can only record another tool's mistakes is not a
measurement.

**What the reference frontend cannot read.** 146 sweep rows carry
`no reference (read_slang fails)` -- `read_slang` cannot elaborate the module,
so there is nothing for the miter or the co-sim to judge us against -- and of
the 125 rows where it does build a netlist that diverges from the RTL (the
*diverge* and *artefact / no oracle* columns of the table above), **34 are
rows ours passes outright**.
The other 91 are rows where both netlists diverge
and a miter has adjudicated ours as the same simulation artefact, which is the
shared-divergence class rather than a verdict on either frontend.  Every one of
these is in [slang_unsupported.md](slang_unsupported.md) with the
reason, a link to the module's source and the recipe that reproduces it, next
to the local and upstream tests slang cannot read.  Rows that carry no verdict
for either side -- a design neither frontend elaborates, a co-sim both netlists
fail identically, a testbench Verilator could not build -- sit in
[incomplete_testcases.md](incomplete_testcases.md) with a statement of
which frontends fail on them.  Most of what used to be counted as unreadable was the harness, not slang
(a configuration the design forbids at its defaults, a withheld package or
macro, an unwrapped interface port, an unroll limit, a header never vendored),
and is excluded rather than scored.

## The 4-frontend matrix: `uhdm`, `sv2v`, `slang`, `verilog`

The 4-frontend regression matrix (`make test-matrix`, run nightly) synthesizes
every test's SystemVerilog through **four** frontends and ranks them by how much
SV each handles **correctly**. Every netlist is verified either by **formal
equivalence** — Yosys `equiv_induct` plus a sound SAT-from-reset miter, against
the Yosys Verilog-frontend golden — **and/or** by **high-activity randomized
Verilator co-simulation** against the original RTL. A result counts as *Correct*
only when one of those checks proves it equivalent; *SV-only* means the frontend
synthesized SystemVerilog that the native Verilog frontend cannot even read (no
golden to compare against, so it is verified against the RTL by co-simulation).

The nightly run
([Frontend Matrix](https://github.com/chipsalliance/uhdm2rtlil/actions/workflows/frontend-matrix.yml),
2046 tests, run 44548705897 on 2026-11-19) reports two things separately: what each frontend could **read**,
and — where a `read_verilog` golden exists to compare against — whether it was
**right**.

| Frontend | Read | Failed to read | Correct | Incorrect | No golden | Unknown |
|---|---:|---:|---:|---:|---:|---:|
| **`uhdm`** (this project) | **2013** | 41 | 1131 | 24 | 768 | 82 |
| `sv2v` | 1798 | 249 | 1083 | 0 | 631 | 83 |
| `slang` (Yosys sv-elab) | 1737 | 309 | 932 | 0 | 664 | 141 |
| `verilog` (Yosys native, the golden) | 1194 | 852 | 1194 | 0 | — | 0 |

*Failed to read* = failed + crashed + timed out + out-of-memory.  *No golden* = this
frontend synthesized but `read_verilog` could not, so there is nothing to
compare against — a capability win, verified against the RTL by co-simulation
rather than formally.  *Unknown* = formal non-equivalence the co-sim could not
adjudicate.  No test is a *disagreement* (one frontend incorrect where
another is correct).  `uhdm`'s 41 failures to read are 33 failures and 8
timeouts over the matrix's 6-minute limit (`macc` and three Yosys `arch`
multiplier tests, `genscope_memory_dyn_index`, and the rp32 SoC / CSR tops).

On this corpus the UHDM frontend reads the most SystemVerilog — **2013 of 2046**,
including **768 designs the native Verilog frontend cannot read at all**.

**How to read this table honestly:**

- **It is a self-run benchmark on a largely self-authored corpus.** The matrix is
  mostly this project's own test suite (plus imported Yosys and
  chipsalliance/UHDM-integration tests), and many tests were added specifically to
  exercise constructs this frontend targets. The ranking is real but it is *not* a
  neutral third-party comparison — a tool graded on the set its authors curated is
  playing at home. Read "#1 by ~10 points" in that light.
- **The benchmark rewards breadth over conservatism.** `sv2v` and `slang` report
  **0 incorrect** results here; `uhdm`'s **24** are a real (tracked) triage backlog
  in `test/failing_tests.txt`. Ranking by how much is read favors breadth, but
  "accepts less yet is never wrong on what it accepts" is a legitimate — sometimes
  preferable — posture, and it's the one `sv2v`/`slang` show on this corpus. Their
  higher "Failed to read" counts (249 / 309 vs 41) reflect that trade-off, not a
  defect.
- **Coverage ≠ ecosystem fit.** `slang`/sv-elab is the frontend that has been
  **upstreamed into Yosys itself**, ships in the OSS CAD Suite, and is used by
  OpenROAD — adoption, integration, and maintenance advantages a nightly coverage
  count does not capture. If your criterion is *maximum SV coverage through the
  Surelog/UHDM path today*, this table favors `uhdm`; if it is *what is maintained
  and integrated for production*, sv-elab has the stronger case. Both can be true.

`verilog` is the golden reference, so it has no *SV-only* column and its ceiling is
the SV subset it can parse. Numbers are from one nightly run and drift between runs
(seq-equiv induction is inductively incomplete on some designs) — treat any single
figure as approximate.

The 24 `uhdm` *Incorrect* tests are what remains of the 349 DUTs imported from
[chipsalliance/UHDM-integration-tests](https://github.com/chipsalliance/UHDM-integration-tests)
(`test/<Name>/dut.sv`); they are tracked in `test/failing_tests.txt`.

## Related reports

- Everything `read_slang` cannot read or gets wrong -- across the sweeps, the
  internal tests and the generated upstream Yosys tests, with reproduce recipes
  -- and the rows where it is right and `read_uhdm` is wrong →
  [slang_unsupported.md](slang_unsupported.md)
- Tests no frontend can be judged on → [incomplete_testcases.md](incomplete_testcases.md)
- chipsalliance/sv-tests, the LRM-chapter corpus, per test → [sv_tests_coverage.md](sv_tests_coverage.md)
- Pavona per-IP table → [pavona_sweep.md](pavona_sweep.md); external-IP families → [ext_ip.md](ext_ip.md)
- The frontend matrix harness → [`test/FRONTEND_MATRIX_README.md`](../test/FRONTEND_MATRIX_README.md)

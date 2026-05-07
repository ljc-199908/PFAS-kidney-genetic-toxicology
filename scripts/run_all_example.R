#!/usr/bin/env Rscript

# =========================================================
# run_all_example.R
#
# One-click example run.
# This script uses the supplied PFAS instrument file:
#   data/exposure_PFAS_instruments.tsv
# =========================================================

rscript <- file.path(R.home("bin"), "Rscript")

cmd1 <- c(
  "scripts/01_generate_harmonised_from_opengwas.R",
  "--exposure", "data/exposure_PFAS_instruments.tsv",
  "--outcomes", "config/outcome_ids_opengwas.tsv",
  "--outdir", "results"
)

cmd2 <- c(
  "scripts/02_run_mr_example.R",
  "--harmonised", "results/harmonised_dat.tsv",
  "--outdir", "results"
)

message("Step 1: Generate harmonised data")
status1 <- system2(rscript, cmd1)
if (status1 != 0) stop("Step 1 failed.")

message("Step 2: Run MR example")
status2 <- system2(rscript, cmd2)
if (status2 != 0) stop("Step 2 failed.")

message("All steps completed.")

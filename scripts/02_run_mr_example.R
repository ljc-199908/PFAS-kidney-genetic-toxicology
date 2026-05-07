#!/usr/bin/env Rscript

# =========================================================
# 02_run_mr_example.R
#
# Purpose:
#   Run a minimal MR analysis using a harmonised dataset.
#
# Input:
#   results/harmonised_dat.tsv
#
# Output:
#   results/mr_results.tsv
#   results/mr_results_or.tsv
#   results/heterogeneity.tsv
#   results/pleiotropy.tsv
#   results/session_info_mr.txt
# =========================================================

suppressPackageStartupMessages({
  library(TwoSampleMR)
  library(data.table)
  library(dplyr)
})

parse_args <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  out <- list(
    harmonised = "results/harmonised_dat.tsv",
    outdir = "results"
  )
  if (length(args) == 0) return(out)
  for (i in seq(1, length(args), by = 2)) {
    key <- gsub("^--", "", args[i])
    val <- args[i + 1]
    if (key %in% names(out)) out[[key]] <- val
  }
  out
}

args <- parse_args()
dir.create(args$outdir, showWarnings = FALSE, recursive = TRUE)

if (!file.exists(args$harmonised)) {
  stop("Harmonised file not found: ", args$harmonised)
}

dat <- fread(args$harmonised) %>% as.data.frame()

if (!"mr_keep" %in% names(dat)) {
  stop("Input file does not appear to be a TwoSampleMR harmonised dataset.")
}

dat_use <- dat %>% filter(mr_keep == TRUE)

if (nrow(dat_use) == 0) {
  stop("No variants with mr_keep == TRUE.")
}

message("Running MR on ", nrow(dat_use), " harmonised SNP rows.")

mr_res <- mr(dat_use)
mr_or <- generate_odds_ratios(mr_res)

fwrite(mr_res, file.path(args$outdir, "mr_results.tsv"), sep = "\t")
fwrite(mr_or, file.path(args$outdir, "mr_results_or.tsv"), sep = "\t")

heterogeneity_res <- tryCatch(
  mr_heterogeneity(dat_use),
  error = function(e) {
    message("Heterogeneity analysis failed: ", e$message)
    data.frame()
  }
)

pleiotropy_res <- tryCatch(
  mr_pleiotropy_test(dat_use),
  error = function(e) {
    message("Pleiotropy analysis failed: ", e$message)
    data.frame()
  }
)

fwrite(heterogeneity_res, file.path(args$outdir, "heterogeneity.tsv"), sep = "\t")
fwrite(pleiotropy_res, file.path(args$outdir, "pleiotropy.tsv"), sep = "\t")

sink(file.path(args$outdir, "session_info_mr.txt"))
cat("MR workflow session information\n")
cat("Generated on: ", as.character(Sys.time()), "\n\n")
print(sessionInfo())
sink()

message("Done.")
message("Generated files:")
message(" - ", file.path(args$outdir, "mr_results.tsv"))
message(" - ", file.path(args$outdir, "mr_results_or.tsv"))
message(" - ", file.path(args$outdir, "heterogeneity.tsv"))
message(" - ", file.path(args$outdir, "pleiotropy.tsv"))
message(" - ", file.path(args$outdir, "session_info_mr.txt"))

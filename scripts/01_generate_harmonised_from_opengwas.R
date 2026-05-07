#!/usr/bin/env Rscript

# =========================================================
# 01_generate_harmonised_from_opengwas.R
#
# Purpose:
#   Regenerate outcome-level SNP associations from OpenGWAS
#   and harmonise them with locally supplied PFAS exposure
#   instruments.
#
# Input:
#   data/exposure_PFAS_instruments.tsv
#   config/outcome_ids_opengwas.tsv
#
# Output:
#   results/outcome_dat_from_opengwas.tsv
#   results/harmonised_dat.tsv
#   results/harmonised_dat.RData
#   results/session_info_harmonisation.txt
# =========================================================

suppressPackageStartupMessages({
  library(TwoSampleMR)
  library(data.table)
  library(dplyr)
  library(readr)
})

parse_args <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  out <- list(
    exposure = "data/exposure_PFAS_instruments.tsv",
    outcomes = "config/outcome_ids_opengwas.tsv",
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

message("Exposure file: ", args$exposure)
message("Outcome config: ", args$outcomes)
message("Output directory: ", args$outdir)

if (!file.exists(args$exposure)) {
  stop(
    "Exposure file not found: ", args$exposure, "\n",
    "Please ensure data/exposure_PFAS_instruments.tsv is present, ",
    "or provide another exposure file using --exposure. ",
    "The required format is shown in data/exposure_instruments_template.tsv."
  )
}

if (!file.exists(args$outcomes)) {
  stop("Outcome configuration file not found: ", args$outcomes)
}

# -----------------------------
# 1. Load exposure instruments
# -----------------------------
exposure_raw <- fread(args$exposure)

required_exposure_cols <- c(
  "exposure",
  "SNP",
  "beta.exposure",
  "se.exposure",
  "effect_allele.exposure",
  "other_allele.exposure",
  "eaf.exposure",
  "pval.exposure",
  "samplesize.exposure"
)

missing_cols <- setdiff(required_exposure_cols, names(exposure_raw))
if (length(missing_cols) > 0) {
  stop(
    "The exposure file is missing required columns: ",
    paste(missing_cols, collapse = ", ")
  )
}

exposure_dat <- as.data.frame(exposure_raw)

# Add default IDs if absent
if (!"id.exposure" %in% names(exposure_dat)) {
  exposure_dat$id.exposure <- exposure_dat$exposure
}

# Basic QC
exposure_dat <- exposure_dat %>%
  filter(
    !is.na(SNP),
    !is.na(beta.exposure),
    !is.na(se.exposure),
    !is.na(effect_allele.exposure),
    !is.na(other_allele.exposure),
    !is.na(pval.exposure)
  ) %>%
  distinct(exposure, SNP, .keep_all = TRUE)

if (nrow(exposure_dat) == 0) {
  stop("No valid exposure instruments remained after basic QC.")
}

message("Loaded exposure instruments: ", nrow(exposure_dat))
message("Unique SNPs: ", length(unique(exposure_dat$SNP)))
message("Exposures: ", paste(unique(exposure_dat$exposure), collapse = ", "))

# -----------------------------
# 2. Load OpenGWAS outcome IDs
# -----------------------------
outcome_cfg <- fread(args$outcomes)

if (!"id.outcome" %in% names(outcome_cfg)) {
  stop("Outcome configuration file must contain column: id.outcome")
}

outcome_ids <- unique(outcome_cfg$id.outcome)
message("Outcomes to extract: ", paste(outcome_ids, collapse = ", "))

# -----------------------------
# 3. Extract outcome data
# -----------------------------
extract_one_outcome <- function(outcome_id, snps) {
  message("Extracting outcome from OpenGWAS: ", outcome_id)
  dat <- tryCatch(
    {
      extract_outcome_data(
        snps = snps,
        outcomes = outcome_id,
        proxies = TRUE,
        rsq = 0.8,
        align_alleles = 1,
        palindromes = 1,
        maf_threshold = 0.3
      )
    },
    error = function(e) {
      message("  Failed: ", outcome_id, " | ", e$message)
      return(NULL)
    }
  )

  if (is.null(dat) || nrow(dat) == 0) {
    message("  No data returned for: ", outcome_id)
    return(NULL)
  }

  dat
}

outcome_list <- lapply(outcome_ids, extract_one_outcome, snps = unique(exposure_dat$SNP))
outcome_list <- Filter(Negate(is.null), outcome_list)

if (length(outcome_list) == 0) {
  stop("No outcome data were extracted from OpenGWAS.")
}

outcome_dat <- bind_rows(outcome_list)

message("Extracted outcome rows: ", nrow(outcome_dat))
message("Extracted outcome datasets: ", paste(unique(outcome_dat$id.outcome), collapse = ", "))

fwrite(
  outcome_dat,
  file = file.path(args$outdir, "outcome_dat_from_opengwas.tsv"),
  sep = "\t"
)

# -----------------------------
# 4. Harmonise exposure and outcome
# -----------------------------
message("Harmonising exposure and outcome datasets...")

harmonised_dat <- harmonise_data(
  exposure_dat = exposure_dat,
  outcome_dat = outcome_dat,
  action = 2
)

fwrite(
  harmonised_dat,
  file = file.path(args$outdir, "harmonised_dat.tsv"),
  sep = "\t"
)

save(
  exposure_dat,
  outcome_dat,
  harmonised_dat,
  file = file.path(args$outdir, "harmonised_dat.RData")
)

# -----------------------------
# 5. Save session info
# -----------------------------
sink(file.path(args$outdir, "session_info_harmonisation.txt"))
cat("Harmonisation workflow session information\n")
cat("Generated on: ", as.character(Sys.time()), "\n\n")
print(sessionInfo())
sink()

message("Done.")
message("Generated files:")
message(" - ", file.path(args$outdir, "outcome_dat_from_opengwas.tsv"))
message(" - ", file.path(args$outdir, "harmonised_dat.tsv"))
message(" - ", file.path(args$outdir, "harmonised_dat.RData"))
message(" - ", file.path(args$outdir, "session_info_harmonisation.txt"))

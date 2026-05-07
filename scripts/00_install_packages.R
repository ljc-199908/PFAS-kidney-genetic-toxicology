# =========================================================
# 00_install_packages.R
# Install packages required for the reproducibility workflow
# =========================================================

options(repos = c(CRAN = "https://cloud.r-project.org"))

cran_pkgs <- c(
  "data.table",
  "dplyr",
  "readr",
  "remotes"
)

for (pkg in cran_pkgs) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

if (!requireNamespace("TwoSampleMR", quietly = TRUE)) {
  remotes::install_github("MRCIEU/TwoSampleMR")
}

if (!requireNamespace("ieugwasr", quietly = TRUE)) {
  remotes::install_github("MRCIEU/ieugwasr")
}

message("Package check complete.")

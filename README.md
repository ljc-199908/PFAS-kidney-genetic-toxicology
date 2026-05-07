# PFAS–Kidney Disease Reproducibility Package

This folder contains a lightweight reproducibility package for the manuscript:

**Per- and Polyfluoroalkyl Substances Exposure and Kidney Disease: Unveiling Genetic Associations and Molecular Mechanisms through Genetic Epidemiology and Computational Toxicology**

The scripts show how to regenerate analysis-ready harmonised datasets using:

1. locally supplied PFAS exposure instruments, and  
2. OpenGWAS outcome IDs used in the manuscript.

Because several GWAS resources restrict redistribution of full summary statistics or derived SNP-level harmonised tables, this repository does **not** host the full pre-harmonised or harmonised exposure/outcome datasets. Instead, it provides a reproducible workflow that retrieves the required outcome data from OpenGWAS and regenerates the harmonised datasets.

## Repository contents

```text
PFAS_kidney_reproducibility/
├── README.md
├── DATA_AVAILABILITY.md
├── REVIEWER_RESPONSE_TEXT.md
├── .gitignore
├── CITATION.cff
├── config/
│   ├── outcome_ids_opengwas.tsv
│   └── exposure_ids.tsv
├── data/
│   ├── README.md
│   └── exposure_instruments_template.tsv
├── example_data/
│   └── example_harmonised_dataset_structure.tsv
├── scripts/
│   ├── 00_install_packages.R
│   ├── 01_generate_harmonised_from_opengwas.R
│   ├── 02_run_mr_example.R
│   └── run_all_example.R
└── results/
    └── .gitkeep
```

## Required input

Before running the scripts, prepare the PFAS exposure instruments as:

```text
data/exposure_instruments.tsv
```

This file should be derived from the SNP-level instrumental variable table reported in the manuscript/Supplementary Table S1.

Required columns:

```text
exposure
SNP
beta.exposure
se.exposure
effect_allele.exposure
other_allele.exposure
eaf.exposure
pval.exposure
samplesize.exposure
```

Optional columns are allowed and will be retained where possible.

A template is provided at:

```text
data/exposure_instruments_template.tsv
```

## OpenGWAS outcome IDs

The outcome IDs are stored in:

```text
config/outcome_ids_opengwas.tsv
```

The default outcomes are:

| OpenGWAS ID | Trait |
|---|---|
| ieu-a-1081 | IgA nephropathy |
| ebi-a-GCST010005 | Membranous nephropathy |
| ukb-b-19955 | Hypertensive nephropathy |
| ukb-a-574 | Calculus of kidney |
| ebi-a-GCST90013940 | Urinary tract infection, SPA |
| ebi-a-GCST90013890 | Urinary tract infection, Firth |

## Quick start

### 1. Install required R packages

```bash
Rscript scripts/00_install_packages.R
```

### 2. Add the exposure instruments

Copy your exposure instrument file into:

```text
data/exposure_instruments.tsv
```

### 3. Regenerate outcome and harmonised datasets

```bash
Rscript scripts/01_generate_harmonised_from_opengwas.R \
  --exposure data/exposure_instruments.tsv \
  --outcomes config/outcome_ids_opengwas.tsv \
  --outdir results
```

This creates:

```text
results/outcome_dat_from_opengwas.tsv
results/harmonised_dat.tsv
results/harmonised_dat.RData
results/session_info_harmonisation.txt
```

### 4. Run the MR example

```bash
Rscript scripts/02_run_mr_example.R \
  --harmonised results/harmonised_dat.tsv \
  --outdir results
```

This creates:

```text
results/mr_results.tsv
results/mr_results_or.tsv
results/heterogeneity.tsv
results/pleiotropy.tsv
results/session_info_mr.txt
```

### 5. One-click run

After placing `data/exposure_instruments.tsv`, the entire example can be run using:

```bash
Rscript scripts/run_all_example.R
```

## Notes on OpenGWAS access

Some OpenGWAS endpoints may require authentication. If required, set your OpenGWAS token before running the scripts:

```r
ieugwasr::set_user_token("YOUR_OPENGWAS_JWT")
```

or set the environment variable before launching R:

```bash
export OPENGWAS_JWT="YOUR_OPENGWAS_JWT"
```

## Data redistribution statement

The full pre-harmonised and harmonised datasets are not deposited here because they contain SNP-level data derived from third-party GWAS resources. Users can regenerate them from the original public resources using the provided scripts and OpenGWAS IDs.

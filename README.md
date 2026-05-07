# PFAS–Kidney Disease Genetic Epidemiology and Computational Toxicology

This repository provides the reproducibility package for the manuscript:

**Per- and Polyfluoroalkyl Substances Exposure and Kidney Disease: Unveiling Genetic Associations and Molecular Mechanisms through Genetic Epidemiology and Computational Toxicology**

The repository is designed to make the Mendelian randomization harmonisation workflow transparent and reproducible without redistributing full third-party GWAS summary statistics. It includes the final PFAS exposure instrument table used in the analysis, OpenGWAS outcome IDs, example data structures, and R scripts to regenerate harmonised exposure–outcome datasets from the original public resources.

## Overview

The workflow starts from the final PFAS genetic instruments for circulating PFOA and PFOS levels and retrieves the corresponding kidney disease outcome associations from OpenGWAS. The retrieved outcome associations are then harmonised with the PFAS exposure instruments using `TwoSampleMR`.

```text
PFAS exposure instruments
        +
OpenGWAS kidney disease outcome IDs
        ↓
Outcome SNP associations retrieved from OpenGWAS
        ↓
Harmonised exposure–outcome dataset
        ↓
MR analysis example
```

## Repository contents

```text
.
├── README.md
├── DATA_AVAILABILITY.md
├── REVIEWER_RESPONSE_TEXT.md
├── CITATION.cff
├── LICENSE
├── .gitignore
├── config/
│   ├── exposure_ids.tsv
│   └── outcome_ids_opengwas.tsv
├── data/
│   ├── README.md
│   ├── exposure_PFAS_instruments.tsv
│   ├── exposure_instrument_summary.tsv
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

## Exposure instrument file

The final PFAS exposure instruments are provided in:

```text
data/exposure_PFAS_instruments.tsv
```

This table contains the SNP-level instruments used for genetically predicted circulating PFAS levels. It is not a full GWAS summary statistics file. The included columns are:

| Column | Description |
|---|---|
| `exposure` | PFAS exposure name, either `PFOA` or `PFOS` |
| `SNP` | rsID of the genetic instrument |
| `effect_allele.exposure` | Effect allele for the exposure association |
| `other_allele.exposure` | Other allele for the exposure association |
| `eaf.exposure` | Effect allele frequency |
| `beta.exposure` | SNP effect estimate for the PFAS exposure |
| `se.exposure` | Standard error of the exposure effect estimate |
| `pval.exposure` | P value for the exposure association |
| `samplesize.exposure` | Exposure GWAS sample size |
| `R2` | Variance explained by the SNP |
| `F` | SNP-level F-statistic |
| `mr_keep.exposure` | Indicator retained from the formatted exposure dataset |
| `pval_origin.exposure` | Source of the P value field |
| `id.exposure` | Internal exposure identifier |
| `data_source.exposure` | Source label retained from formatting |

A compact summary is provided in:

```text
data/exposure_instrument_summary.tsv
```

### Included PFAS instrument summary

| Exposure | Number of instruments | Sample size in supplied file | Cumulative R2 | F-statistic range | Mean F |
|---|---:|---:|---:|---:|---:|
| PFOA | 57 | 8,199 | 0.1612 | 20.46–54.33 | 23.25 |
| PFOS | 66 | 8,812 | 0.1856 | 21.98–47.10 | 24.85 |


## OpenGWAS outcome IDs

Kidney disease outcome IDs are stored in:

```text
config/outcome_ids_opengwas.tsv
```

The default outcomes are:

| OpenGWAS ID | Trait |
|---|---|
| `ieu-a-1081` | IgA nephropathy |
| `ebi-a-GCST010005` | Membranous nephropathy |
| `ukb-b-19955` | Hypertensive nephropathy |
| `ukb-a-574` | Calculus of kidney |
| `ebi-a-GCST90013940` | Urinary tract infection, SPA |
| `ebi-a-GCST90013890` | Urinary tract infection, Firth |

## Quick start

### 1. Install required R packages

```bash
Rscript scripts/00_install_packages.R
```

### 2. Generate harmonised datasets from OpenGWAS

```bash
Rscript scripts/01_generate_harmonised_from_opengwas.R \
  --exposure data/exposure_PFAS_instruments.tsv \
  --outcomes config/outcome_ids_opengwas.tsv \
  --outdir results
```

This generates:

```text
results/outcome_dat_from_opengwas.tsv
results/harmonised_dat.tsv
results/harmonised_dat.RData
results/session_info_harmonisation.txt
```

### 3. Run the MR example

```bash
Rscript scripts/02_run_mr_example.R \
  --harmonised results/harmonised_dat.tsv \
  --outdir results
```

This generates:

```text
results/mr_results.tsv
results/mr_results_or.tsv
results/heterogeneity.tsv
results/pleiotropy.tsv
results/session_info_mr.txt
```

### 4. One-click run

The full example can be run using:

```bash
Rscript scripts/run_all_example.R
```

## OpenGWAS authentication

Some OpenGWAS endpoints may require authentication. If required, set your OpenGWAS token before running the scripts:

```r
ieugwasr::set_user_token("YOUR_OPENGWAS_JWT")
```

or set the environment variable before launching R:

```bash
export OPENGWAS_JWT="YOUR_OPENGWAS_JWT"
```

## Data redistribution statement

This repository does not redistribute full pre-harmonised outcome datasets, full harmonised SNP-level datasets, or full third-party GWAS summary statistics. These files may contain derived SNP-level data from third-party GWAS resources with resource-specific redistribution terms. Instead, this repository provides the final PFAS instrument table, OpenGWAS outcome IDs, and scripts that enable users to regenerate the harmonised datasets from the original public resources.

## Citation

If you use this repository, please cite the associated manuscript and the archived Zenodo release of this repository.

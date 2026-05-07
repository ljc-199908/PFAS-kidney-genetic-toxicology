# Data availability and redistribution note

The analysis code and reproducibility scripts are provided to support transparent regeneration of the harmonised datasets used in the manuscript.

## What is included

This repository includes:

- scripts to regenerate outcome-level SNP associations from OpenGWAS IDs;
- scripts to harmonise locally supplied PFAS exposure instruments with OpenGWAS outcomes;
- an example output-structure file showing the format of the harmonised dataset;
- configuration files listing the exposure and outcome GWAS IDs used in the study.

## What is not included

This repository does not include the full pre-harmonised or harmonised SNP-level datasets.

These files are derived from third-party GWAS resources, including GWAS Catalog/OpenGWAS and UK Biobank-derived resources. Because redistribution terms may differ across resources, we provide a reproducible pipeline instead of redistributing derived summary-statistic tables.

## How to reproduce the harmonised datasets

1. Obtain or prepare the PFAS exposure instruments from the manuscript/Supplementary Table S1.
2. Save the file as:

```text
data/exposure_instruments.tsv
```

3. Run:

```bash
Rscript scripts/run_all_example.R
```

The pipeline retrieves the outcome associations from OpenGWAS and generates analysis-ready harmonised datasets in:

```text
results/harmonised_dat.tsv
```

## Suggested Data Availability Statement

The analysis pipeline and reproducible code supporting this study are publicly available in the GitHub repository. A permanent archived version of the repository is available through Zenodo. All data underlying the findings are derived from publicly accessible GWAS resources, including GWAS Catalog/OpenGWAS and UK Biobank-derived summary statistics. Because the full pre-harmonised and harmonised datasets are derived from third-party GWAS resources with resource-specific redistribution terms, these datasets are not directly redistributed in the repository. Instead, we provide a reproducible script that retrieves the original outcome data using OpenGWAS study IDs and regenerates the harmonised analysis-ready datasets from the supplied PFAS instrumental variables.

# Data folder

This folder contains the final PFAS exposure instrument table and a template showing the required input structure.

## Included files

```text
exposure_PFAS_instruments.tsv
```

This is the SNP-level PFAS exposure instrument table used in the Mendelian randomization harmonisation workflow. It contains the final retained genetic instruments for circulating PFOA and PFOS levels, together with effect alleles, effect sizes, standard errors, P values, sample size, variance explained, and F-statistics.

```text
exposure_instrument_summary.tsv
```

This file summarizes the number of retained instruments, sample size, cumulative R2, and F-statistics by exposure.

```text
exposure_instruments_template.tsv
```

This file provides a minimal example of the expected format if users want to replace the supplied PFAS instruments with another exposure instrument table.

## Required columns

The harmonisation script expects the following columns:

```text
exposure
SNP
effect_allele.exposure
other_allele.exposure
eaf.exposure
beta.exposure
se.exposure
pval.exposure
samplesize.exposure
```

The following columns are optional but recommended:

```text
R2
F
mr_keep.exposure
pval_origin.exposure
id.exposure
data_source.exposure
```

## Redistribution note

This folder should not be used to store full third-party GWAS summary statistics, full OpenGWAS outcome downloads, or full harmonised SNP-level datasets unless redistribution is explicitly permitted by the original data source. Generated outcome and harmonised files are written to the `results/` folder and are ignored by Git by default.

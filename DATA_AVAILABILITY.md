# Data availability statement

The analysis pipeline and reproducible code supporting this study are publicly available in this repository. A permanent archived version of the repository should be made available through Zenodo after release.

All data underlying the findings are derived from publicly accessible resources, including GWAS Catalog/OpenGWAS, UK Biobank-derived GWAS summary statistics, PubChem, SwissTargetPrediction, SEA, CTD, GeneCards, Open Targets, STRING, and RCSB PDB, as described in the manuscript.

The repository includes the final PFAS exposure instrument table used for harmonisation (`data/exposure_PFAS_instruments.tsv`). This table contains the retained SNP-level instruments for genetically predicted circulating PFOA and PFOS levels and is provided to facilitate reproducibility of the MR harmonisation workflow.

The repository does not redistribute full pre-harmonised outcome datasets, full harmonised exposure–outcome datasets, or full third-party GWAS summary statistics because these files may contain derived SNP-level data from third-party GWAS resources with resource-specific redistribution terms. Instead, we provide OpenGWAS outcome IDs, the PFAS exposure instrument table, example harmonised output structures, and one-click R scripts that allow users to retrieve the original outcome associations and regenerate the harmonised analysis-ready datasets from the original public resources.

After publishing the GitHub release, replace the placeholder below with the Zenodo DOI:

```text
Zenodo DOI: [insert DOI]
```

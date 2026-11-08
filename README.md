# HCPex ROI Extractor

[日本語版 README](README_ja.md)

A Bash script that extracts left and right ROIs from the HCPex volumetric atlas **just by specifying region names**. Multiple regions can also be combined into a single ROI.

## Quick Start

```bash
git clone https://github.com/Kikubernetes/HCPex_ROI_Extractor.git
cd HCPex_ROI_Extractor
bash make_hcpex_rois.sh HCPex.nii.gz A4/A5 MT/MST TA2
```

A `ROIs/` directory is created in the directory where the script is run:

```text
ROIs/
├── A4_A5_L.nii.gz
├── A4_A5_R.nii.gz
├── MT_MST_L.nii.gz
├── MT_MST_R.nii.gz
├── TA2_L.nii.gz
└── TA2_R.nii.gz
```

## Usage

```bash
bash make_hcpex_rois.sh HCPex.nii.gz ROI [ROI ...]
```

- HCPex short region names such as `A4`, `A5`, `MT`, `MST`, and `TA2` can be specified directly (case-sensitive).
- Separate regions with `/`, as in `A4/A5`, to combine them into a single ROI.
- Left- and right-hemisphere ROIs are created separately and automatically.
- Output filenames are generated automatically.
  * `TA2` → `TA2_L.nii.gz`, `TA2_R.nii.gz`
  * `A4/A5` → `A4_A5_L.nii.gz`, `A4_A5_R.nii.gz`

## Requirements

- [FSL](https://fsl.fmrib.ox.ac.uk/fsl/docs/) (uses `fslmaths`)
- `HCPex.nii.gz` (included; derived from v1.1 in the [official HCPex repository](https://github.com/wayalan/HCPex))
- `HCPex_regions.tsv` (included; **must be in the same directory as the script**)

## Lookup Table (`HCPex_regions.tsv`)

A tab-separated file mapping region names to Label IDs. An excerpt is shown below.

| Region | L_ID | R_ID | Label_Name |
|--------|-----:|-----:|------------|
| V1     | 1    | 181  | Primary_Visual_Cortex |
| MST    | 22   | 202  | Medial_Superior_Temporal_Area |
| MT     | 23   | 203  | Middle_Temporal_Area |
| A4     | 60   | 240  | Auditory_4_Complex |
| A5     | 61   | 241  | Auditory_5_Complex |

## About the HCPex Atlas

This script is designed for the HCPex atlas, a volumetric atlas extending the Human Connectome Project multimodal parcellation atlas. HCPex contains 360 cortical labels and 66 subcortical labels, for a total of 426 labels. The HCPex atlas is defined in the space of `mni_icbm152_t1_tal_nlin_asym_09c_brain.nii.gz`. For details, see the official repository:

https://github.com/wayalan/HCPex

**Note:** This repository is an independently developed utility and is not maintained or provided by the authors of HCPex.

## Citation

If you use HCPex in your research, please cite the original publication:

> Huang CC, Rolls ET, Feng J, Lin CP. An extended Human Connectome Project multimodal parcellation atlas of the human cortex and subcortical areas. *Brain Struct Funct.* 2022;227(3):763-778. doi:10.1007/s00429-021-02421-6

See the [official HCPex repository](https://github.com/wayalan/HCPex) for any additional citations that may be required.

## License

Because this repository includes files derived from HCPex (`HCPex.nii.gz`, `HCPex_regions.tsv`), it is distributed under **GPL-3.0**, the same as the original. See `LICENSE` for details.

## Disclaimer

This tool is intended for research use. Users are responsible for verifying that the atlas version, Label IDs, spatial alignment, and ROI definitions are appropriate for their analyses.

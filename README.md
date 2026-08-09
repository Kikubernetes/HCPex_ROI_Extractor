# HCPex ROI Extractor

[日本語版 READMEはこちら](README_ja.md)

A small Bash utility for extracting and combining bilateral regions of interest (ROIs) from the volumetric **HCPex atlas** using region names rather than manually specifying label numbers.

For example,

```bash
bash make_hcpex_rois.sh HCPex.nii.gz A4/A5 MT/MST A5 STSda/STSdp TA2
```

creates:

```text
ROIs/
├── A4_A5_L.nii.gz
├── A4_A5_R.nii.gz
├── MT_MST_L.nii.gz
├── MT_MST_R.nii.gz
├── A5_L.nii.gz
├── A5_R.nii.gz
├── STSda_STSdp_L.nii.gz
├── STSda_STSdp_R.nii.gz
├── TA2_L.nii.gz
└── TA2_R.nii.gz
```

The `/` separator means that multiple HCPex regions are merged into a single binary ROI.

## Features

- Specify HCPex regions by their short region names, such as `A4`, `A5`, `MT`, `MST`, `STSda`, or `TA2`.
- Combine multiple atlas regions into one ROI with `/`, for example `A4/A5`.
- Automatically generates separate left- and right-hemisphere masks.
- Automatically names output files, for example:
  - `A4/A5` → `A4_A5_L.nii.gz`, `A4_A5_R.nii.gz`
  - `STSda/STSdp` → `STSda_STSdp_L.nii.gz`, `STSda_STSdp_R.nii.gz`
- Uses a human-readable lookup table containing HCPex short names, left/right label IDs, and descriptive label names.
- Avoids generating all 426 individual atlas masks when only selected ROIs are needed.

## Requirements

- Bash
- [FSL](https://fsl.fmrib.ox.ac.uk/fsl/docs/)
- HCPex volumetric atlas in NIfTI format

The HCPex atlas itself is **not included in this repository**. Please obtain it from the official HCPex repository:

https://github.com/wayalan/HCPex

## Files

```text
.
├── make_hcpex_rois.sh
├── HCPex_regions_with_labels.tsv
├── README.md
└── README_ja.md
```

### `HCPex_regions_with_labels.tsv`

The lookup table contains four tab-separated columns:

```text
Region    L_ID    R_ID    Label_Name
```

Example:

```text
V1       1     181    Primary_Visual_Cortex
MST      22    202    Medial_Superior_Temporal_Area
MT       23    203    Middle_Temporal_Area
A4       60    240    Auditory_4_Complex
A5       61    241    Auditory_5_Complex
STSda    63    243    Area_STSd_anterior
STSdp    64    244    Area_STSd_posterior
TA2      67    247    Area_TA2
```

`Region` is the short name used as a command-line argument. `L_ID` and `R_ID` are the corresponding HCPex atlas label numbers. `Label_Name` is a hemisphere-independent descriptive label derived from the HCPex lookup table.

## Usage

First, clone this repository and move into the repository directory.

```bash
git clone https://github.com/Kikubernetes/HCPex_ROI_Extractor.git
cd HCPex_ROI_Extractor
```

**Note**: make_hcpex_rois.sh and the lookup table HCPex_regions_with_labels.tsv must be placed in the same directory.

Run the script using the following syntax:

```bash
bash make_hcpex_rois.sh HCPex.nii.gz ROI [ROI ...]
```
The script automatically creates an ROIs directory in the directory from which it is executed and saves the extracted ROIs.

### Single region

```bash
bash make_hcpex_rois.sh HCPex.nii.gz A5
```

Output:

```text
ROIs/A5_L.nii.gz
ROIs/A5_R.nii.gz
```

### Combine multiple regions

```bash
bash make_hcpex_rois.sh HCPex.nii.gz A4/A5
```

Output:

```text
ROIs/A4_A5_L.nii.gz
ROIs/A4_A5_R.nii.gz
```

### Create several ROIs at once

```bash
bash make_hcpex_rois.sh HCPex.nii.gz A4/A5 MT/MST A5 STSda/STSdp TA2
```

Each space-separated argument is treated as an independent ROI definition.

## How it works

For each requested region, the script:

1. Looks up the corresponding left- and right-hemisphere HCPex label IDs in `HCPex_regions_with_labels.tsv`.
2. Extracts each requested label directly from the HCPex atlas with `fslmaths`.
3. Adds the component masks when `/` is used.
4. Binarizes the result.
5. Writes separate left and right masks to the `ROIs/` directory.

For example,

```text
A4/A5
```

corresponds to:

```text
Left:  60 + 61
Right: 240 + 241
```

and produces:

```text
A4_A5_L.nii.gz
A4_A5_R.nii.gz
```

## HCPex atlas

This utility is designed for the **HCPex atlas**, an extended volumetric version of the Human Connectome Project multimodal parcellation atlas. HCPex contains 360 cortical labels and 66 subcortical labels, for a total of 426 labels. The HCPex labels are defined in the space of mni_icbm152_t1_tal_nlin_asym_09c_brain.nii.gz, which is provided in the official repository.

Official repository:

https://github.com/wayalan/HCPex

Note: This repository is an independent utility and is not affiliated with or maintained by the HCPex authors.

## Citation

If you use this utility with HCPex in research, please cite the original HCPex publication:

> Huang CC, Rolls ET, Feng J, Lin CP. An extended Human Connectome Project multimodal parcellation atlas of the human cortex and subcortical areas. *Brain Struct Funct.* 2022;227(3):763-778. doi:10.1007/s00429-021-02421-6. PMID:34791508.

The HCPex authors also acknowledge the HCP-MMP v1.0 atlas on which its cortical parcellation is based. Please consult the original HCPex documentation for any additional citation requirements relevant to your work.

## License

The upstream HCPex GitHub repository is distributed under the **GNU General Public License v3.0 (GPL-3.0)**.

Because `HCPex_regions_with_labels.tsv` incorporates region-label information derived from the HCPex lookup table, this repository is intended to be distributed under the **GNU General Public License v3.0** as well.

When publishing this repository on GitHub, add the standard GPL-3.0 `LICENSE` file.

See the upstream HCPex repository for its original license and terms:

https://github.com/wayalan/HCPex

## Disclaimer

This software is provided for research use. Users are responsible for confirming that atlas versions, label numbers, spatial registration, and ROI definitions are appropriate for their analysis.

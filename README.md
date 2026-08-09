# HCPex ROI Extractor

[日本語版 README](README_ja.md)

A Bash script for extracting and combining bilateral ROIs from the HCPex volumetric atlas using region names, without manually specifying atlas label IDs.

For example, running:

```bash
bash make_hcpex_rois.sh HCPex.nii.gz A4/A5 MT/MST TA2
```

creates:

```text
ROIs/
├── A4_A5_L.nii.gz
├── A4_A5_R.nii.gz
├── MT_MST_L.nii.gz
├── MT_MST_R.nii.gz
├── TA2_L.nii.gz
└── TA2_R.nii.gz
```

Multiple HCPex regions separated by `/` are combined into a single binary ROI.

## Features

* HCPex short region names such as `A4`, `A5`, `MT`, `MST`, and `TA2` can be specified directly.
* Multiple regions can be combined into a single ROI by separating them with `/`, for example `A4/A5`.
* Left- and right-hemisphere ROIs are automatically generated separately.
* Output filenames are generated automatically.

  * `TA2` → `TA2_L.nii.gz`, `TA2_R.nii.gz`
  * `A4/A5` → `A4_A5_L.nii.gz`, `A4_A5_R.nii.gz`

* A lookup table containing HCPex short region names, left and right Label IDs, and descriptive Label Names is used.
* Only the required ROIs are extracted directly from the HCPex atlas.

## Requirements

* [FSL](https://fsl.fmrib.ox.ac.uk/fsl/docs/)
* HCPex volumetric atlas (`HCPex.nii.gz`, included in this repository)

For convenience, `HCPex.nii.gz` is included in this repository. This file is derived from HCPex v1.1 in the official HCPex repository.

Official HCPex repository:

https://github.com/wayalan/HCPex

## File Structure

```text
.
├── make_hcpex_rois.sh
├── HCPex_regions.tsv
├── HCPex.nii.gz
├── README.md
├── README_ja.md
└── LICENSE
```

### `HCPex_regions.tsv`

The lookup table is a four-column, tab-separated file.

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
```

`Region` is the short region name specified as a command-line argument. `L_ID` and `R_ID` are the left- and right-hemisphere Label IDs in the HCPex atlas, and `Label_Name` is the common descriptive name (long name) for the bilateral region based on the HCPex Lookup Table.

## Usage

Clone this repository and move into the repository directory.

```bash
git clone https://github.com/Kikubernetes/HCPex_ROI_Extractor.git
cd HCPex_ROI_Extractor
```

**Note:** `make_hcpex_rois.sh` and the lookup table `HCPex_regions.tsv` must be placed in the same directory.

Run the script using the following syntax:

```bash
bash make_hcpex_rois.sh HCPex.nii.gz ROI [ROI ...]
```

An `ROIs` directory is created in the directory from which the script is executed, and the resulting ROI files are saved there.

### Extract a Single Region

```bash
bash make_hcpex_rois.sh HCPex.nii.gz A5
```

Output:

```text
ROIs/A5_L.nii.gz
ROIs/A5_R.nii.gz
```

### Combine Multiple Regions into a Single ROI

```bash
bash make_hcpex_rois.sh HCPex.nii.gz A4/A5
```

Output:

```text
ROIs/A4_A5_L.nii.gz
ROIs/A4_A5_R.nii.gz
```

### Create Multiple ROIs at Once

```bash
bash make_hcpex_rois.sh HCPex.nii.gz A4/A5 MT/MST A5 STSda/STSdp TA2
```

Each space-separated argument is treated as an independent ROI definition.

## How It Works

For each ROI, the script performs the following steps:

1. Looks up the left and right HCPex Label IDs in `HCPex_regions.tsv`.
2. Extracts the corresponding labels from the HCPex atlas using `fslmaths`.
3. If multiple regions are specified using `/`, the extracted regions are added together.
4. The result is converted to a binary mask.
5. Separate left- and right-hemisphere NIfTI files are saved in `ROIs/`.

For example:

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

## About the HCPex Atlas

This script is designed for the HCPex atlas, a volumetric atlas extending the Human Connectome Project multimodal parcellation atlas. HCPex contains 360 cortical labels and 66 subcortical labels, for a total of 426 labels. The HCPex atlas is defined in the space of `mni_icbm152_t1_tal_nlin_asym_09c_brain.nii.gz`, which is included in the official repository.

Official repository:

https://github.com/wayalan/HCPex

**Note:** This repository is an independently developed utility and is not maintained or provided by the authors of HCPex.

## Citation

If you use HCPex in your research, please cite the original HCPex publication:

> Huang CC, Rolls ET, Feng J, Lin CP. An extended Human Connectome Project multimodal parcellation atlas of the human cortex and subcortical areas. *Brain Struct Funct.* 2022;227(3):763-778. doi:10.1007/s00429-021-02421-6. PMID:34791508.

The cortical regions in HCPex are based on HCP-MMP v1.0. Depending on your research, please also consult the official HCPex README and the original publication for any additional citations that may be appropriate.

## License

The official HCPex GitHub repository is distributed under the **GNU General Public License v3.0 (GPL-3.0)**.

This repository includes `HCPex.nii.gz`, derived from the official HCPex repository, as well as `HCPex_regions.tsv`, which contains region-label information based on the HCPex Lookup Table. Therefore, this repository is also distributed under the **GNU General Public License v3.0 (GPL-3.0)**.

For details, see the `LICENSE` file in this repository and the official HCPex repository:

https://github.com/wayalan/HCPex

## Disclaimer

This tool is intended for research use. Users are responsible for verifying that the atlas version, Label IDs, spatial alignment, and ROI definitions are appropriate for their specific analyses.

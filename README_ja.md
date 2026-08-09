# HCPex ROI Extractor

[English README](README.md)

HCPex volumetric atlasから、領域番号を手動で指定することなく、領域名を用いて左右のROIを抽出・結合するためのBashスクリプトです。

たとえば、

```bash
bash make_hcpex_rois.sh HCPex.nii.gz A4/A5 MT/MST A5 STSda/STSdp TA2
```

と実行すると、

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

が作成されます。

`/` で区切った複数のHCPex領域は、1つのbinary ROIとして結合されます。

## 特徴

- `A4`、`A5`、`MT`、`MST`、`STSda`、`TA2` など、HCPexの短縮領域名をそのまま指定できます。
- `A4/A5` のように `/` で区切ると複数領域を1つのROIに結合できます。
- 左右半球のROIを自動的に別々に作成します。
- 出力名も自動的に決定します。
  - `A4/A5` → `A4_A5_L.nii.gz`, `A4_A5_R.nii.gz`
  - `STSda/STSdp` → `STSda_STSdp_L.nii.gz`, `STSda_STSdp_R.nii.gz`
- HCPexの短縮名、左右のLabel ID、説明的なLabel Nameを含む対応表を利用します。
- 必要なROIだけをHCPex atlasから直接抽出するため、426個すべての個別ROIをあらかじめ作成する必要がありません。

## Requirements

- Bash
- [FSL](https://fsl.fmrib.ox.ac.uk/fsl/docs/)
- NIfTI形式のHCPex volumetric atlas

HCPex atlas本体は公式HCPex repositoryから取得してください。

https://github.com/wayalan/HCPex

## ファイル構成

```text
.
├── make_hcpex_rois.sh
├── HCPex_regions_with_labels.tsv
├── README.md
└── README_ja.md
```

### `HCPex_regions_with_labels.tsv`

対応表はタブ区切りの4列です。

```text
Region    L_ID    R_ID    Label_Name
```

例：

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

`Region` は引数として指定する短縮領域名です。`L_ID` と `R_ID` はHCPex atlas内の左右のLabel ID、`Label_Name` はHCPexのLookup Tableに基づく左右共通の名称（Long name）です。

## 使用方法

リポジトリをクローンします。
```bash
git clone https://github.com/Kikubernetes/HCPex_ROI_Extractor.git
cd HCPex_ROI_Extractor
```

**注意**：スクリプト`make_hcpex_rois.sh`と対応表`HCPex_regions_with_labels.tsv`を同じディレクトリにおいてください。

```bash
bash make_hcpex_rois.sh HCPex.nii.gz ROI [ROI ...]
```
実行したディレクトリ内にROIsディレクトリが作成され、結果が出力されます。

### １領域を抽出

```bash
bash make_hcpex_rois.sh HCPex.nii.gz A5
```

出力：

```text
ROIs/A5_L.nii.gz
ROIs/A5_R.nii.gz
```

### 複数領域を1つに結合して抽出

```bash
bash make_hcpex_rois.sh HCPex.nii.gz A4/A5
```

出力：

```text
ROIs/A4_A5_L.nii.gz
ROIs/A4_A5_R.nii.gz
```

### 複数のROIを一度に作成

```bash
bash make_hcpex_rois.sh HCPex.nii.gz A4/A5 MT/MST A5 STSda/STSdp TA2
```

スペースで区切った各引数が、それぞれ独立したROI定義として処理されます。

## 処理内容

各ROIについて、スクリプトは以下を行います。

1. `HCPex_regions_with_labels.tsv` から左右のHCPex Label IDを検索します。
2. `fslmaths` を用いてHCPex atlasから該当ラベルを抽出します。
3. `/` で複数領域が指定された場合は、それらを加算します。
4. 結果をbinary maskに変換します。
5. 左右別のNIfTIファイルとして `ROIs/` に保存します。

たとえば、

```text
A4/A5
```

は、

```text
Left:  60 + 61
Right: 240 + 241
```

に対応し、

```text
A4_A5_L.nii.gz
A4_A5_R.nii.gz
```

が作成されます。

## HCPex atlasについて

本スクリプトは、Human Connectome Project multimodal parcellation atlasを拡張してvolumetric atlasとした HCPex atlasを対象としています。HCPexには360の皮質ラベルと66の皮質下ラベルが含まれ、合計426ラベルで構成されています。HCPex atlasは、公式リポジトリに含まれる mni_icbm152_t1_tal_nlin_asym_09c_brain.nii.gz の空間上に定義されています。

公式repository：

https://github.com/wayalan/HCPex

注意：本リポジトリは独立して作成された補助ツールであり、HCPexの著者によって管理・提供されるものではありません。

## Citation

研究でHCPexを利用する場合は、HCPexの原著論文を引用してください。

> Huang CC, Rolls ET, Feng J, Lin CP. An extended Human Connectome Project multimodal parcellation atlas of the human cortex and subcortical areas. *Brain Struct Funct.* 2022;227(3):763-778. doi:10.1007/s00429-021-02421-6. PMID:34791508.

HCPexは皮質領域についてHCP-MMP v1.0に基づいています。研究内容に応じた追加の引用については、HCPex本家のREADMEおよび原著論文も確認してください。

## ライセンス

本家HCPexのGitHub repositoryは **GNU General Public License v3.0（GPL-3.0）** で公開されています。

`HCPex_regions_with_labels.tsv` はHCPexのLookup Tableに由来する領域ラベル情報を含むため、本リポジトリも **GNU General Public License v3.0** で公開することを想定しています。

GitHub公開時には、標準のGPL-3.0 `LICENSE` ファイルを追加してください。

HCPexのライセンスについては以下を参照してください。

https://github.com/wayalan/HCPex

## Disclaimer

本ツールは研究用途を想定しています。使用するatlas version、Label ID、空間的位置合わせ、およびROI定義が各解析に適切であることは、利用者自身で確認してください。

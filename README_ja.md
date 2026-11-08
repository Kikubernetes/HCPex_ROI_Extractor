# HCPex ROI Extractor

[English README](README.md)

HCPex volumetric atlasから、**領域名を指定するだけ**で左右別のROIを抽出するBashスクリプトです。複数のROIを結合することもできます。

## クイックスタート

```bash
git clone https://github.com/Kikubernetes/HCPex_ROI_Extractor.git
cd HCPex_ROI_Extractor
bash make_hcpex_rois.sh HCPex.nii.gz A4/A5 MT/MST TA2
```

実行したディレクトリに `ROIs/` が作成されます。

```text
ROIs/
├── A4_A5_L.nii.gz
├── A4_A5_R.nii.gz
├── MT_MST_L.nii.gz
├── MT_MST_R.nii.gz
├── TA2_L.nii.gz
└── TA2_R.nii.gz
```

## 使い方

```bash
bash make_hcpex_rois.sh HCPex.nii.gz ROI [ROI ...]
```

- `A4`、`A5`、`MT`、`MST`、`TA2` など、HCPexの短縮領域名をそのまま指定できます（大文字・小文字を区別）。
- `A4/A5` のように `/` で区切ると複数領域を1つのROIに結合できます。
- 左右半球のROIを自動的に別々に作成します。
- 出力名も自動的に決定します。
  * `TA2` → `TA2_L.nii.gz`, `TA2_R.nii.gz`
  * `A4/A5` → `A4_A5_L.nii.gz`, `A4_A5_R.nii.gz`

## 必要なもの

- [FSL](https://fsl.fmrib.ox.ac.uk/fsl/docs/)（`fslmaths` を使用）
- `HCPex.nii.gz`（同梱。[HCPex公式リポジトリ](https://github.com/wayalan/HCPex)のv1.1に由来）
- `HCPex_regions.tsv`（同梱。**スクリプトと同じディレクトリに置いてください**）

## 対応表（`HCPex_regions.tsv`）

領域名とLabel IDの対応を記載したタブ区切りファイルです。以下は表の一部です。

| Region | L_ID | R_ID | Label_Name |
|--------|-----:|-----:|------------|
| V1     | 1    | 181  | Primary_Visual_Cortex |
| MST    | 22   | 202  | Medial_Superior_Temporal_Area |
| MT     | 23   | 203  | Middle_Temporal_Area |
| A4     | 60   | 240  | Auditory_4_Complex |
| A5     | 61   | 241  | Auditory_5_Complex |

## HCPex atlasについて

本スクリプトは、Human Connectome Project multimodal parcellation atlasを拡張してvolumetric atlasとした HCPex atlasを対象としています。HCPexには360の皮質ラベルと66の皮質下ラベルが含まれ、合計426ラベルで構成されています。HCPex atlasは `mni_icbm152_t1_tal_nlin_asym_09c_brain.nii.gz` の空間上に定義されています。詳細は以下を参照してください。

公式repository：

https://github.com/wayalan/HCPex

注意：本リポジトリは独立して作成された補助ツールであり、HCPexの著者によって管理・提供されるものではありません。

## 引用

HCPexを研究に利用する場合は、以下の原著論文を引用してください。

> Huang CC, Rolls ET, Feng J, Lin CP. An extended Human Connectome Project multimodal parcellation atlas of the human cortex and subcortical areas. *Brain Struct Funct.* 2022;227(3):763-778. doi:10.1007/s00429-021-02421-6

追加で必要な引用については、[HCPex公式リポジトリ](https://github.com/wayalan/HCPex)を確認してください。

## ライセンス

HCPex由来のファイル（`HCPex.nii.gz`、`HCPex_regions.tsv`）を含むため、本家と同じ **GPL-3.0** で公開しています。詳細は `LICENSE` を参照してください。

## 免責事項

研究用途のツールです。atlasのバージョン、Label ID、位置合わせ、ROI定義が解析に適切かどうかは、利用者自身で確認してください。

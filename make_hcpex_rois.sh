#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   bash make_hcpex_rois.sh HCPex.nii.gz ROI [ROI ...]
#
# Examples:
#   bash make_hcpex_rois.sh HCPex.nii.gz A4/A5 MT/MST A5 STSda/STSdp TA2
#
# Output:
#   A4/A5       -> A4_A5_L.nii.gz, A4_A5_R.nii.gz
#   MT/MST      -> MT_MST_L.nii.gz, MT_MST_R.nii.gz
#   A5          -> A5_L.nii.gz, A5_R.nii.gz
#   STSda/STSdp -> STSda_STSdp_L.nii.gz, STSda_STSdp_R.nii.gz

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 HCPex.nii.gz ROI [ROI ...]" >&2
    exit 1
fi

atlas="$1"
shift

script_dir="$(cd "$(dirname "$0")" && pwd)"
lookup="$script_dir/HCPex_regions.tsv"

outdir="ROIs"
mkdir -p "$outdir"

if [[ ! -f "$atlas" ]]; then
    echo "Error: atlas not found: $atlas" >&2
    exit 1
fi

if [[ ! -f "$lookup" ]]; then
    echo "Error: lookup table not found: $lookup" >&2
    exit 1
fi


# ------------------------------------------------------------
# Look up HCPex ID
#
# $1 = region name
# $2 = hemisphere (L or R)
# ------------------------------------------------------------
get_id() {
    local region="$1"
    local hemi="$2"

    if [[ "$hemi" == "L" ]]; then
        awk -F'\t' -v r="$region" \
            '$1 == r {print $2; exit}' "$lookup"
    else
        awk -F'\t' -v r="$region" \
            '$1 == r {print $3; exit}' "$lookup"
    fi
}


# ------------------------------------------------------------
# Create one combined ROI
#
# Example:
#   make_roi "A4/A5" L
# ------------------------------------------------------------
make_roi() {
    local specification="$1"
    local hemi="$2"

    # A4/A5 -> ["A4", "A5"]
    IFS='/' read -ra regions <<< "$specification"

    # A4/A5 -> A4_A5
    local output_name="${specification//\//_}_${hemi}"

    local tmpdir
    tmpdir=$(mktemp -d)

    local masks=()
    local region id tmp

    for region in "${regions[@]}"; do

        id=$(get_id "$region" "$hemi")

        if [[ -z "$id" ]]; then
            echo "Error: unknown HCPex region: $region" >&2
            rm -rf "$tmpdir"
            exit 1
        fi

        tmp="$tmpdir/${region}_${hemi}.nii.gz"

        fslmaths "$atlas" \
            -thr "$id" \
            -uthr "$id" \
            -bin "$tmp"

        masks+=("$tmp")
    done

    # Start with the first mask
    local cmd=(fslmaths "${masks[0]}")

    # Add remaining masks
    local mask
    for mask in "${masks[@]:1}"; do
        cmd+=(-add "$mask")
    done

    cmd+=(-bin "$outdir/${output_name}.nii.gz")

    "${cmd[@]}"

    rm -rf "$tmpdir"

    echo "Created: $outdir/${output_name}.nii.gz"
}


# ============================================================
# Process all ROI specifications
# ============================================================

for specification in "$@"; do
    make_roi "$specification" L
    make_roi "$specification" R
done

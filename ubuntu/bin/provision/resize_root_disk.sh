#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y cloud-guest-utils lvm2

root_source="$(findmnt -n -o SOURCE /)"
root_type="$(findmnt -n -o FSTYPE /)"

grow_partition() {
  local partition="$1"
  local parent_disk
  local partition_number
  local growpart_output

  parent_disk="$(lsblk -no PKNAME "$partition" | awk 'NF {print $1; exit}')"
  partition_number="$(lsblk -no PARTN "$partition" | awk 'NF {print $1; exit}')"

  if [[ -z "$parent_disk" || -z "$partition_number" ]]; then
    echo "Cannot determine parent disk and partition number for $partition."
    return 2
  fi

  growpart_output="$(growpart "/dev/$parent_disk" "$partition_number" 2>&1)" || {
    if grep -qi "NOCHANGE" <<< "$growpart_output"; then
      echo "$growpart_output"
      return 0
    fi
    echo "$growpart_output" >&2
    return 1
  }

  echo "$growpart_output"
}

resize_filesystem() {
  local source="$1"
  local fstype="$2"

  case "$fstype" in
    ext2|ext3|ext4)
      resize2fs "$source"
      ;;
    xfs)
      apt-get install -y xfsprogs
      xfs_growfs /
      ;;
    *)
      echo "Unsupported root filesystem type '$fstype'; block device was grown but filesystem was not resized."
      ;;
  esac
}

if [[ "$(lsblk -no TYPE "$root_source" 2>/dev/null | head -n 1 || true)" == "lvm" ]]; then
  vg_name="$(lvs --noheadings -o vg_name "$root_source" | awk '{$1=$1; print}')"
  if [[ -z "$vg_name" ]]; then
    echo "Cannot determine volume group for LVM root $root_source."
    exit 1
  fi

  pvs --noheadings -o pv_name,vg_name --separator '|' |
    awk -F'|' -v vg="$vg_name" '
      {
        gsub(/^[ \t]+|[ \t]+$/, "", $1)
        gsub(/^[ \t]+|[ \t]+$/, "", $2)
        if ($2 == vg) print $1
      }
    ' |
    while read -r pv_name; do
      if [[ -n "$pv_name" ]]; then
        status=0
        grow_partition "$pv_name" || status="$?"
        if [[ "$status" -eq 1 ]]; then
          exit 1
        fi
        pvresize "$pv_name"
      fi
    done

  free_extents="$(vgs --noheadings -o vg_free_count "$vg_name" | awk '{print $1}')"
  if [[ "$free_extents" =~ ^[0-9]+$ && "$free_extents" -gt 0 ]]; then
    lvextend -r -l +100%FREE "$root_source"
  else
    echo "No free extents available in volume group $vg_name; root volume is already fully allocated."
  fi
else
  status=0
  grow_partition "$root_source" || status="$?"
  if [[ "$status" -eq 0 ]]; then
    resize_filesystem "$root_source" "$root_type"
  else
    if [[ "$status" -eq 1 ]]; then
      exit 1
    fi
    echo "Root filesystem is not a simple partition-backed filesystem; skipping resize for $root_source."
  fi
fi

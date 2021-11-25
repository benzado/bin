#!/bin/sh

get_metadata_value() {
  local key=$1
  local path="$2"

  mdls -raw -nullMarker NULL -name $key "$path"
}

DESKTOP="$HOME/Desktop"

for x in $DESKTOP/*; do
  if [ -f "$x" ]; then
    creation_date=$(get_metadata_value kMDItemContentCreationDate "$x")
    year_and_month=${creation_date:0:7}
    folder_path="${DESKTOP}/${year_and_month}"
    mkdir -p "$folder_path"
    mv -v "$x" "$folder_path"
  fi
done

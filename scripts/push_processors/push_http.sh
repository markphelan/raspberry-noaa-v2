#!/bin/bash
#
# Purpose: Push the image via http/https to a remote server.
#
# Instructions:
#  1. Configure HTTP_POST_XXX settings in the .noaa-v2.conf file
#
# Input parameters:
#   1. Image filename
#
# Example:
#   ./scripts/push_processors/push_http.sh "/srv/images/NOAA-18-20210212-091356-MCIR.jpg" "/path/to/another/image.jpg"

# import common lib and settings
. "$HOME/.noaa-v2.conf"
. "$NOAA_HOME/scripts/common.sh"

# input params
IMAGES=$@

# Only upload some image types
ALLOWEDFILES=("-122-rectified.jpg" "-MSA.jpg" "-MCIR.jpg")

for IMG in $IMAGES; do
  echo $i
  # Check if the image is one of the allowed types
  MATCH=0
  for ending in ${ALLOWEDFILES[@]}; do
    if [[ $IMG == *$ending ]]; then
      echo "Matched $ending on $IMG"
      MATCH=1
      break
    fi
  done

  if [[ $MATCH == 0 ]]; then
    echo "Skipping this file: $IMG"
    continue
  fi

  # if image exists then upload it
  if [ -f "${IMG}" ]; then
    log "Submitting $IMG to $HTTP_POST_URL..." INFO
    curl --location --request POST "$HTTP_POST_URL" \
    --header "Authorization: Bearer $HTTP_POST_TOKEN" \
    --form image=@$IMG
    exit # Only upload 1 image from each pass
  else
    log "Could not find or access image/attachment - not submitting" "ERROR"
  fi
done

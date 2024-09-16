#!/bin/bash

# Function to check if a file is already converted
is_converted() {
  local filename="$1"
  if [[ $filename =~ ^.+\.[0-9]+%_slowdown\..+$ ]]; then
    return 0  # File is converted
  else
    return 1  # File is not converted
  fi
}

# Loop through files in the current directory
for file in _input/*/* ; do
  echo $file
  original_bpm=$(echo $file | grep -E -o '[[:digit:]]{0,3}bpm'| grep -o [[:digit:]]\*)
  file_without_bpm=$(echo $file | sed "s/_$original_bpm.*$//")
  output_filename=$(echo $output_filename | sed "s/_input/_output/")

  echo $file_without_bpm
  bpm=$original_bpm
  echo $bpm
  output_filename="${file_without_bpm}_${original_bpm}bpm.mp3"
  output_filename=$(echo $output_filename | sed "s/_input/_output/")
  ffmpeg -y -i $file $output_filename
  while (( $bpm >= 70 ))
  do
    if (( $bpm % 10 > 0 ))
    then
      bpm=$((bpm - 1))

      # echo $bpm
    else
      ratio=$(bc -l <<< $bpm/$original_bpm)
      echo "bpm: $bpm || ratio: $ratio"
      output_filename="${file_without_bpm}_${bpm}bpm.mp3"
      output_filename=$(echo $output_filename | sed "s/_input/_output/")
      echo $output_filename
      ffmpeg -y -i $file -af atempo=$ratio $output_filename
      bpm=$((bpm - 1))
      # echo $ratio
      # echo $bpm

    fi
  done
done

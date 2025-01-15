#!/bin/bash

if [ ! -d "_input" ]; then
  echo "There is no \"_input\" folder."
  echo "Creating \"_input\" folder..."
  mkdir _input
  echo "Folder created. Create a folder within it, with the artists name and place any songs in the artists folder."
  echo "The Song should have the naming convention \"songName_123bpm\"."
  echo "The pbm number will be used to convert it to slower tempos."
  echo "It should look something like this: i.e. \"_input/Tool/Bottom_140bpm.m4a\""
  exit 0
fi

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

  bpm=$((bpm-(bpm%10)))
  # echo $bpm

  for i in {1..4}
  do
    # echo $bpm
    ratio=$(bc -l <<< $bpm/$original_bpm)
    # echo "bpm: $bpm || ratio: $ratio"
    output_filename="${file_without_bpm}_${bpm}bpm.mp3"
    output_filename=$(echo $output_filename | sed "s/_input/_output/")
    # echo $output_filename
    ffmpeg -y -i $file -af atempo=$ratio $output_filename
    bpm=$((bpm-10))
  done
done

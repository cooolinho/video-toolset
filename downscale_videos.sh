#!/bin/bash

# === Prüfen ob ein Input-Ordner angegeben wurde ===
if [ -z "$1" ]; then
    echo "Bitte Input-Ordner angeben!"
    echo "Usage: $0 /c/Pfad/zum/Ordner"
    exit 1
fi

INPUT_FOLDER="$1"
OUTPUT_FOLDER="$INPUT_FOLDER/output"

# === Konfiguration ===
OUTPUT_SUFFIX="_720p"             # Suffix für Ausgabedateien
CRF="20"                          # Qualität (niedriger = besser)
PRESET="slow"                     # Kompressionsgeschwindigkeit
AUDIO_BITRATE="128k"              # Audio-Bitrate
TARGET_HEIGHT="720"               # Zielhöhe
VIDEO_CODEC="libx264"             # Video-Codec
AUDIO_CODEC="aac"                 # Audio-Codec
EXTENSIONS=("mp4" "mkv" "mov" "avi")  # erlaubte Dateiendungen

# === Verarbeitung ===
# Baue find-Ausdruck aus der Extensions-Variable
find_expr=""
for ext in "${EXTENSIONS[@]}"; do
    if [ -n "$find_expr" ]; then
        find_expr="$find_expr -o "
    fi
    find_expr="$find_expr -iname '*.$ext'"
done

find "$INPUT_FOLDER" -type f \( $find_expr \) | while read -r input_file; do
    # Pfad relativ zum Input-Ordner
    relative_path="${input_file#$INPUT_FOLDER/}"
    relative_dir=$(dirname "$relative_path")
    
    # Zielordner im Output-Ordner erstellen
    mkdir -p "$OUTPUT_FOLDER/$relative_dir"
    
    filename=$(basename "$input_file")
    extension="${filename##*.}"
    name="${filename%.*}"
    output_file="$OUTPUT_FOLDER/$relative_dir/${name}${OUTPUT_SUFFIX}.${extension}"

    echo "Bearbeite: $input_file → $output_file"

    ffmpeg -i "$input_file" \
      -vf "scale=-1:$TARGET_HEIGHT" \
      -c:v $VIDEO_CODEC -crf $CRF -preset $PRESET \
      -c:a $AUDIO_CODEC -b:a $AUDIO_BITRATE \
      "$output_file"
done

echo "Fertig! Alle Dateien sind in $OUTPUT_FOLDER"

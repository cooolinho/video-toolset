#!/bin/bash

if [ $# -lt 1 ]; then
  echo "❌ Nutzung: $0 <ordner>"
  exit 1
fi

INPUT_DIR="$1"
OUTPUT_DIR="$INPUT_DIR/output"
mkdir -p "$OUTPUT_DIR"

# Funktion: HH:MM:SS → Sekunden
time_to_sec() {
  local T="$1"
  local h=${T%%:*}
  local rest=${T#*:}
  local m=${rest%%:*}
  local s=${rest#*:}
  echo $((10#$h*3600 + 10#$m*60 + 10#$s))
}

# Alle Videos im Ordner durchgehen
for VIDEO in "$INPUT_DIR"/*.{mkv,mp4}; do
  [ -e "$VIDEO" ] || continue  # falls keine Dateien gefunden

  BASENAME=$(basename "$VIDEO")
  NAME="${BASENAME%.*}"
  EXT="${VIDEO##*.}"

  LIST="$INPUT_DIR/${NAME}-episodes.txt"

  if [ ! -f "$LIST" ]; then
    echo "⚠️ Keine Episodenliste gefunden für $BASENAME (erwartet: ${NAME}-episodes.txt)"
    continue
  fi

  echo "📂 Bearbeite $BASENAME mit Episodenliste $LIST"

  while read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    EP_NAME=$(echo "$line" | awk '{print $1}')
    START=$(echo "$line" | awk '{print $2}')
    END=$(echo "$line" | awk '{print $3}')

    START_SEC=$(time_to_sec "$START")
    END_SEC=$(time_to_sec "$END")
    DURATION=$((END_SEC - START_SEC))

    if (( DURATION <= 0 )); then
      echo "⚠️ Ungültige Dauer für $EP_NAME in $LIST: $START → $END"
      continue
    fi

    echo "🎬 Schneide $EP_NAME von $START bis $END"
    ffmpeg -ss "$START" -i "$VIDEO" -t "$DURATION" -c copy "$OUTPUT_DIR/${EP_NAME}.${EXT}"
  done < "$LIST"

done

echo "✅ Alle Videos aus $INPUT_DIR verarbeitet. Ergebnisse liegen in $OUTPUT_DIR"

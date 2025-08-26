#!/bin/bash

if [ $# -lt 1 ]; then
  echo "❌ Nutzung: $0 <ordner>"
  exit 1
fi

INPUT_DIR="$1"

# Alle Videos im Ordner durchgehen
for VIDEO in "$INPUT_DIR"/*.{mkv,mp4}; do
  [ -e "$VIDEO" ] || continue  # falls keine Dateien gefunden

  BASENAME=$(basename "$VIDEO")
  NAME="${BASENAME%.*}"

  LIST="$INPUT_DIR/${NAME}-episodes.txt"

  if [ -f "$LIST" ]; then
    echo "✔️ Episodenliste existiert schon: $LIST"
  else
    echo "# Episodenliste für $BASENAME" > "$LIST"
    echo "# Schema: Folgenname HH:MM:SS HH:MM:SS" >> "$LIST"
    echo "# Beispiel: Folge01 00:00:00 00:45:00" >> "$LIST"
    echo "🆕 Episodenliste erstellt: $LIST"
  fi
done

echo "✅ Fertig – alle fehlenden Episodenlisten wurden erstellt."

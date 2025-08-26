# Video Toolset

Dieses Projekt enthält **zwei Shell-Toolsets** für Videobearbeitung:

1. **Video Splitter Toolset** → Lange Aufnahmen in einzelne Folgen aufteilen
2. **Video Downscale Toolset** → Videos auf 720p downscalen, um Dateigröße zu reduzieren

Alle Ausgaben werden automatisch in einem Unterordner `output/` gespeichert.

---

## 📌 Voraussetzungen

* **Windows** oder **Linux/macOS**
* **Git Bash** (für Windows): [https://git-scm.com/download/win](https://git-scm.com/download/win)
* **FFmpeg** (Version 7.1.1 oder neuer)

  * Prüfen:

    ```bash
    ffmpeg -version
    ```

---

## ⚙️ 1. Video Splitter Toolset

Dieses Toolset enthält zwei Skripte, mit denen du Serienmarathons oder lange Aufnahmen **in einzelne Folgen aufteilen** kannst.

### Skripte

#### a) `create_episode_files.sh`

Erstellt zu jeder Videodatei (`.mkv` oder `.mp4`) im Ordner eine passende `*-episodes.txt`, falls diese noch nicht existiert.

**Nutzung:**

```bash
chmod +x create_episode_files.sh
./create_episode_files.sh meine-serie
```

**Ergebnis:**

```
meine-serie/
├── aufnahme001.mkv
├── aufnahme001-episodes.txt
├── aufnahme002.mp4
├── aufnahme002-episodes.txt
```

**Inhalt der automatisch erstellten Datei:**

```txt
# Episodenliste für aufnahme001.mkv
# Schema: Folgenname HH:MM:SS HH:MM:SS
# Beispiel: Folge01 00:00:00 00:45:00
```

➡️ Danach trägst du deine Start- und Endzeiten ein.

#### b) `split_folder.sh`

Liest alle Videodateien und Episodenlisten ein und schneidet die Folgen mit FFmpeg heraus.

**Nutzung:**

```bash
chmod +x split_folder.sh
./split_folder.sh meine-serie
```

Alle geschnittenen Folgen landen automatisch im Unterordner `output/`:

```
meine-serie/output/
├── Folge01.mkv
├── Folge02.mkv
├── Folge03.mkv
...
```

---

### 📄 Episodenlisten (Schema)

Jede Episodenliste enthält eine Zeile pro Folge:

```
Folgenname HH:MM:SS HH:MM:SS
```

* **Folgenname**: Name der Ausgabedatei (z. B. `Folge01`)
* **Startzeit**: Beginn der Episode im Video
* **Endzeit**: Ende der Episode im Video

**Beispiel: `aufnahme001-episodes.txt`**

```txt
Folge01 00:00:00 00:44:55
Folge02 00:45:10 01:30:00
Folge03 01:30:15 02:15:00
```

> Kommentare (`#`) und leere Zeilen werden ignoriert.

---

### ✅ Hinweise

* Schneiden erfolgt mit `-c copy` → **kein Re-Encoding** → sehr schnell, keine Qualitätsverluste
* Fehlerhafte Zeitangaben oder negative Werte werden übersprungen
* Jede Serie hat ihren eigenen `output/`-Ordner

---

### 🔧 Workflow-Empfehlung

1. `create_episode_files.sh` ausführen → Episodenlisten werden erstellt
2. Start- und Endzeiten in den Episodenlisten eintragen
3. `split_folder.sh` starten → Folgen werden automatisch geschnitten

---

## ⚙️ 2. Video Downscale Toolset

Dieses Toolset konvertiert Videos in einem angegebenen Ordner (inklusive Unterordner) auf 720p, um **Dateigröße zu reduzieren**, ohne die Qualität wesentlich zu beeinträchtigen.

### Nutzung

1. Skript ausführbar machen:

```bash
chmod +x downscale_videos.sh
```

2. Skript ausführen:

```bash
./downscale_videos.sh /pfad/zum/ordner
```

* Unter Windows (Git Bash/WSL):

```bash
./downscale_videos.sh /c/Users/Benutzer/Videos
```

Alle konvertierten Videos werden im Unterordner `output/` im angegebenen Input-Ordner abgelegt.

---

### Konfiguration

Die wichtigsten Optionen sind am Anfang des Skripts als Variablen definiert:

```bash
OUTPUT_SUFFIX="_720p"       # Suffix für Ausgabedateien
CRF="20"                    # Qualität (niedriger = besser)
PRESET="slow"               # Kompressionsgeschwindigkeit
AUDIO_BITRATE="128k"        # Audio-Bitrate
TARGET_HEIGHT="720"         # Zielhöhe
VIDEO_CODEC="libx264"       # Video-Codec
AUDIO_CODEC="aac"           # Audio-Codec
EXTENSIONS=("mp4" "mkv" "mov" "avi")  # erlaubte Dateiendungen
```

* `CRF`: 18–28 → niedriger = bessere Qualität, größere Datei; 23 ist Standard
* `PRESET`: `ultrafast`, `superfast`, `fast`, `medium`, `slow`, `slower`, `veryslow`
* `EXTENSIONS`: weitere Formate einfach hinzufügen

---

### ✅ Hinweise

* FFmpeg muss installiert und im Systempfad verfügbar sein
* Originaldateien bleiben unverändert
* Bei sehr vielen Dateien kann die Verarbeitung einige Zeit dauern
* Optional kann das Skript für parallele Verarbeitung erweitert werden

---

Mit diesem Toolset kannst du **lange Aufnahmen schneiden** und **Videos verlustarm downscalen**, alles in einer sauberen Ordnerstruktur. 🎬

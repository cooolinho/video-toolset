<h1 align="center">🎬 Video Toolset</h1>

<p align="center">
  <em>Zwei Bash-Toolsets für FFmpeg: lange Aufnahmen in Folgen schneiden und Videos auf 720p downscalen.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white" alt="Bash">
  <img src="https://img.shields.io/badge/FFmpeg-007808?style=for-the-badge&logo=ffmpeg&logoColor=white" alt="FFmpeg">
</p>

<p align="center">
  <a href="README.md">🇬🇧 English version</a>
</p>

---

## 📖 Über das Projekt

Zwei unabhängige Toolsets für dasselbe wiederkehrende Problem: Videodateien, die
entweder zu lang oder zu groß sind.

**Der Splitter** schneidet eine lange Aufnahme — einen Serienmarathon, einen
Stream-Mitschnitt — in einzelne Folgen. Die Zeitstempel trägst du in eine
einfache Textdatei ein; FFmpeg schneidet per Stream-Copy, das dauert Sekunden und
kostet keine Qualität.

**Der Downscaler** läuft durch einen Ordnerbaum und kodiert alles auf 720p, um
Speicherplatz zurückzugewinnen. Die Originale bleiben unangetastet.

Beide schreiben in einen `output/`-Unterordner, der Eingabeordner bleibt also so,
wie er war.

## 🛠️ Tech-Stack

| Technologie | Version | Zweck |
|-------------|---------|-------|
| <img src="https://img.shields.io/badge/Bash-4EAA25?style=flat-square&logo=gnubash&logoColor=white" alt="Bash"> Bash | — | Skripte |
| <img src="https://img.shields.io/badge/FFmpeg-007808?style=flat-square&logo=ffmpeg&logoColor=white" alt="FFmpeg"> FFmpeg | 7.1.1+ | Schneiden und Kodieren |

## ✨ Funktionen

- **Verlustfreies Schneiden** — `-c copy` bedeutet kein Re-Encoding: schnell, ohne Qualitätsverlust
- **Generierte Episodenlisten** — pro Video eine Vorlagendatei zum Ausfüllen
- **Fehlerhafte Einträge werden übersprungen** — falsche oder negative Zeitangaben brechen den Lauf nicht ab
- **Rekursives Downscaling** — läuft durch Unterordner, konfigurierbare Dateiendungen
- **Originale bleiben unberührt** — alles landet in `output/`
- **Plattformübergreifend** — Linux, macOS und Windows über Git Bash oder WSL

## 🚀 Erste Schritte

### Voraussetzungen

- **FFmpeg** 7.1.1 oder neuer, im `PATH`
- **Bash** — unter Windows über [Git Bash](https://git-scm.com/download/win) oder WSL

```bash
ffmpeg -version   # Installation prüfen
```

### Installation

```bash
git clone https://github.com/cooolinho/video-toolset.git
cd video-toolset
chmod +x *.sh
```

## 📋 Verwendung

### ✂️ Aufnahmen in Folgen schneiden

**Schritt 1 — Episodenlisten erzeugen**

```bash
./create_episode_files.sh meine-serie
```

Zu jeder `.mkv`- oder `.mp4`-Datei im Ordner wird eine passende
`*-episodes.txt` angelegt, sofern sie noch nicht existiert:

```
meine-serie/
├── aufnahme001.mkv
├── aufnahme001-episodes.txt
├── aufnahme002.mp4
└── aufnahme002-episodes.txt
```

**Schritt 2 — Zeitstempel eintragen**

Eine Zeile pro Folge, `Name Start Ende`:

```txt
Folge01 00:00:00 00:44:55
Folge02 00:45:10 01:30:00
Folge03 01:30:15 02:15:00
```

Kommentare (`#`) und Leerzeilen werden ignoriert.

| Feld | Bedeutung |
|------|-----------|
| Name | Dateiname der Ausgabe, ohne Endung |
| Start | Beginn der Folge, `HH:MM:SS` |
| Ende | Ende der Folge, `HH:MM:SS` |

**Schritt 3 — schneiden**

```bash
./split_folder.sh meine-serie
```

```
meine-serie/output/
├── Folge01.mkv
├── Folge02.mkv
└── Folge03.mkv
```

### 📉 Auf 720p downscalen

```bash
./downscale_videos.sh /pfad/zum/ordner
```

Unter Windows über Git Bash:

```bash
./downscale_videos.sh /c/Users/Benutzer/Videos
```

Die konvertierten Dateien landen in `output/` innerhalb des angegebenen Ordners.
Die Originale bleiben unverändert.

#### Konfiguration

Die Einstellungen stehen am Anfang von `downscale_videos.sh`:

| Variable | Standard | Beschreibung |
|----------|----------|--------------|
| `OUTPUT_SUFFIX` | `_720p` | Suffix der Ausgabedateien |
| `CRF` | `20` | Qualität: 18–28, niedriger heißt besser und größer |
| `PRESET` | `slow` | `ultrafast` … `veryslow`; langsamer komprimiert besser |
| `AUDIO_BITRATE` | `128k` | Audio-Bitrate |
| `TARGET_HEIGHT` | `720` | Zielhöhe in Pixeln |
| `VIDEO_CODEC` | `libx264` | Video-Codec |
| `AUDIO_CODEC` | `aac` | Audio-Codec |
| `EXTENSIONS` | `mp4 mkv mov avi` | Welche Dateien verarbeitet werden |

Eine große Sammlung zu kodieren dauert. `PRESET` ist der wichtigste Hebel, wenn
du Dateigröße gegen Zeit tauschen willst.

## 📁 Projektstruktur

```
video-toolset/
├── create_episode_files.sh   # Vorlagen für Episodenlisten erzeugen
├── split_folder.sh           # Folgen mit FFmpeg schneiden
└── downscale_videos.sh       # Rekursiv auf 720p downscalen
```

## 📄 Lizenz

Veröffentlicht unter der [MIT-Lizenz](LICENSE).

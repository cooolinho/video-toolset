<h1 align="center">🎬 Video Toolset</h1>

<p align="center">
  <em>Two Bash toolsets for FFmpeg: split long recordings into episodes, and downscale videos to 720p.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white" alt="Bash">
  <img src="https://img.shields.io/badge/FFmpeg-007808?style=for-the-badge&logo=ffmpeg&logoColor=white" alt="FFmpeg">
</p>

<p align="center">
  <a href="README.de.md">🇩🇪 Deutsche Version</a>
</p>

---

## 📖 About

Two independent toolsets for the same recurring problem: video files that are
either too long or too large.

**The splitter** cuts one long recording — a TV marathon, a stream capture — into
individual episodes. You define the timestamps in a plain text file; FFmpeg does
the cutting with stream copy, so it takes seconds and loses nothing.

**The downscaler** walks a folder tree and re-encodes everything to 720p to
reclaim disk space. Originals are never modified.

Both write into an `output/` subfolder, so the input directory stays as it was.

## 🛠️ Tech Stack

| Technology | Version | Purpose |
|------------|---------|---------|
| <img src="https://img.shields.io/badge/Bash-4EAA25?style=flat-square&logo=gnubash&logoColor=white" alt="Bash"> Bash | — | Scripting |
| <img src="https://img.shields.io/badge/FFmpeg-007808?style=flat-square&logo=ffmpeg&logoColor=white" alt="FFmpeg"> FFmpeg | 7.1.1+ | Cutting and encoding |

## ✨ Features

- **Lossless splitting** — `-c copy` means no re-encoding: fast, no quality loss
- **Generated episode lists** — a template file per video, ready to fill in
- **Malformed entries are skipped** — bad or negative timestamps do not abort the run
- **Recursive downscaling** — walks subfolders, configurable extensions
- **Originals untouched** — everything lands in `output/`
- **Cross-platform** — Linux, macOS, and Windows via Git Bash or WSL

## 🚀 Getting Started

### Prerequisites

- **FFmpeg** 7.1.1 or newer, on your `PATH`
- **Bash** — on Windows via [Git Bash](https://git-scm.com/download/win) or WSL

```bash
ffmpeg -version   # verify the installation
```

### Installation

```bash
git clone https://github.com/cooolinho/video-toolset.git
cd video-toolset
chmod +x *.sh
```

## 📋 Usage

### ✂️ Splitting recordings into episodes

**Step 1 — generate the episode lists**

```bash
./create_episode_files.sh my-series
```

For every `.mkv` or `.mp4` in the folder, a matching `*-episodes.txt` is created
if it does not exist yet:

```
my-series/
├── recording001.mkv
├── recording001-episodes.txt
├── recording002.mp4
└── recording002-episodes.txt
```

**Step 2 — fill in the timestamps**

One line per episode, `Name Start End`:

```txt
Episode01 00:00:00 00:44:55
Episode02 00:45:10 01:30:00
Episode03 01:30:15 02:15:00
```

Comments (`#`) and blank lines are ignored.

| Field | Meaning |
|-------|---------|
| Name | Output filename, without extension |
| Start | Where the episode begins, `HH:MM:SS` |
| End | Where it ends, `HH:MM:SS` |

**Step 3 — cut**

```bash
./split_folder.sh my-series
```

```
my-series/output/
├── Episode01.mkv
├── Episode02.mkv
└── Episode03.mkv
```

### 📉 Downscaling to 720p

```bash
./downscale_videos.sh /path/to/folder
```

On Windows via Git Bash:

```bash
./downscale_videos.sh /c/Users/YourName/Videos
```

Converted files land in `output/` inside the given folder. Originals stay
untouched.

#### Configuration

The settings live at the top of `downscale_videos.sh`:

| Variable | Default | Description |
|----------|---------|-------------|
| `OUTPUT_SUFFIX` | `_720p` | Appended to output filenames |
| `CRF` | `20` | Quality: 18–28, lower means better and larger |
| `PRESET` | `slow` | `ultrafast` … `veryslow`; slower compresses better |
| `AUDIO_BITRATE` | `128k` | Audio bitrate |
| `TARGET_HEIGHT` | `720` | Target height in pixels |
| `VIDEO_CODEC` | `libx264` | Video codec |
| `AUDIO_CODEC` | `aac` | Audio codec |
| `EXTENSIONS` | `mp4 mkv mov avi` | Which files to process |

Encoding a large library takes a while — `PRESET` is the main lever if you would
rather trade file size for time.

## 📁 Project Structure

```
video-toolset/
├── create_episode_files.sh   # Generate episode list templates
├── split_folder.sh           # Cut episodes with FFmpeg
└── downscale_videos.sh       # Recursively downscale to 720p
```

## 📄 License

Released under the [MIT License](LICENSE).

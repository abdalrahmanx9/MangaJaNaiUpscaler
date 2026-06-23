# MangaJaNai Converter

AMD ROCm and NVIDIA CUDA GPU-accelerated manga upscaling for Windows and Linux.
Original project: [MangaJaNaiConverterGui](https://github.com/the-database/MangaJaNaiConverterGui)

## Features

- **Cross-Platform** — works on Windows 10/11 and Linux
- **ROCm and CUDA** — detects and uses AMD GPUs (RX 6000/7000 series) via ROCm/HIP (Linux), or NVIDIA GPUs via CUDA (Windows & Linux)
- **4× upscaling** — ESRGAN-based models for grayscale (MangaJaNai) and color (IllustrationJaNai) pages
- **CBZ/CBR archive support** — reads manga chapters, upscales images, repacks as CBZ
- **Configurable chains** — auto-selects model and settings based on image resolution and type
- **Model caching** — keeps grayscale and color models concurrently in VRAM to avoid reload cost
- **Standalone** — self-contained project with an automated Setup Wizard

## Requirements

| Component | Windows | Linux |
|-----------|---------|-------|
| OS | Windows 10 / 11 | Linux Mint 22.x / Ubuntu 24.04 |
| GPU | NVIDIA RTX 2000+ | AMD RDNA2+ (RX 6000+) or NVIDIA RTX 2000+ |
| Drivers | NVIDIA Driver with CUDA 12.1+ | ROCm 7.2.4+ **or** NVIDIA 535+ with CUDA 12.1+ |
| System deps | None | libvips, libxcb-cursor0, curl, wget |

*Note: Python, PyTorch, and `uv` are automatically installed by the built-in Setup Wizard.*

## Quick Start (Building from Source)

The GUI is built with Tauri (Rust + Node.js).

### 1. System Dependencies (Linux Only)
Ensure your GPU drivers are installed and loaded (e.g., `rocminfo` or `nvidia-smi` works). Then install basic system packages:
```bash
sudo apt update
sudo apt install -y libvips libxcb-cursor0 curl wget
```
*(Windows users skip this step).*

### 2. GUI Development Requirements
To build and run the Tauri GUI, you need Node.js, Rust, and Tauri dependencies:

**Linux:**
```bash
# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

# Install Tauri dependencies
sudo apt install -y libwebkit2gtk-4.1-dev build-essential file libssl-dev libgtk-3-dev libayatana-appindicator3-dev librsvg2-dev
```

**Windows:**
1. Install [Node.js](https://nodejs.org/).
2. Install [Rust](https://rustup.rs/).
3. Install [Visual Studio C++ Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/).

### 3. Launch the Application

**Linux:**
```bash
bash run.sh
```

**Windows:**
```bat
run.bat
```

On first launch, the application will display a **Setup Wizard** that automatically downloads:
- `uv` package manager
- Python 3.12 (isolated within `backend/src/python-runtime`)
- PyTorch (CUDA or ROCm variants based on your hardware)
- All required pip dependencies

Models can also be downloaded directly from within the GUI.

## Project Structure

```text
├── backend/
│   ├── models/              # ESRGAN model files (downloaded via GUI)
│   ├── src/
│   │   ├── python-runtime/  # Isolated Python environment created by Setup Wizard
│   │   ├── run_upscale.py   # CLI upscaler entry point
│   │   ├── nodes/           # Inference, tiling, image processing
│   │   └── pyproject.toml   # uv project configuration
├── gui/                     # Tauri GUI (TypeScript + Vite)
│   ├── src/                 # Frontend code
│   └── src-tauri/           # Rust backend bridging Python script & GUI
├── run.sh / run.bat         # Dev launch scripts
└── README.md
```

## Troubleshooting

**Linux: Slow performance / low power draw (MCLK stuck at 96Mhz) on AMD:**
A known AMD ROCm bug on Linux can cause the GPU Memory Clock (MCLK) to get permanently stuck at 96MHz instead of boosting during AI workloads.
To fix this, force the GPU into its high-performance power state:
```bash
echo "high" | sudo tee /sys/class/drm/card0/device/power_dpm_force_performance_level
```
*(Change `card0` to `card1` if you have an integrated graphics chip).*

## License

Community fork optimized for Tauri and cross-platform support. See the [original project](https://github.com/the-database/MangaJaNaiConverterGui) for license details.

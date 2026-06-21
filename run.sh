#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
source "$DIR/backend/src/.venv/bin/activate"
cd "$DIR/gui"
python3 launch_gui.py

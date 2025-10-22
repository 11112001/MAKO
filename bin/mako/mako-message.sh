#!/usr/bin/env bash

# ---- configurables ----
TITLE="HyDE "
SLEEP_BEFORE_NOTIFY=3
FLAG_DIR="${XDG_RUNTIME_DIR:-/tmp}"
FLAG_FILE="$FLAG_DIR/mako_welcome_shown.$(id -u)"
ICON_DIR="$HOME/.config/mako/icons"
# -----------------------

# si ya se mostró en este arranque, salir
if [[ -e "$FLAG_FILE" ]]; then
    exit 0
fi

MESSAGES=(
  "I love you "
  "See? Empty inside :("
  "Dear mom, Im dying "
  "Try again?"
  "Burn the boats ⚡"
  "Pain is sentation, and sentatios are mean to be enjoyed"
  "cant see me"
  "you'll be ok, or you wont. Prepare for both"
  "keep going, always"
  "Depressed? Just say no!"
  "I dont believe in nothing"
  "Im just here for the violence"
  "Its just chaos"
  "Did you complete the objective?"
  "Hack the world"
)

# Asegurar que mako esté corriendo;
if ! pgrep -x mako > /dev/null 2>&1; then
    if command -v mako > /dev/null 2>&1; then
        mako >/dev/null 2>&1 &
        SLEEP_BEFORE_NOTIFY=$((SLEEP_BEFORE_NOTIFY + 1))
    fi
fi

# esperar un poco para que mako esté listo
sleep "$SLEEP_BEFORE_NOTIFY"

# elegir mensaje aleatorio (bash puro)
count=${#MESSAGES[@]}
if (( count == 0 )); then
    exit 1
fi
index=$(( RANDOM % count ))
MESSAGE="${MESSAGES[$index]}"

# ---------------------------
# LÓGICA DE ICONOS / IMAGENES
# ---------------------------
# nullglob 
shopt -s nullglob 2>/dev/null || true

ICON=""
if [[ -d "$ICON_DIR" ]]; then
    ICONS=( "$ICON_DIR"/*.png "$ICON_DIR"/*.svg "$ICON_DIR"/*.jpg "$ICON_DIR"/*.jpeg )
    valid_icons=()
    for f in "${ICONS[@]}"; do
        [[ -f "$f" ]] && valid_icons+=( "$f" )
    done

    if (( ${#valid_icons[@]} > 0 )); then
        ICON="${valid_icons[$((RANDOM % ${#valid_icons[@]}))]}"
    fi
fi

if [[ -z "$ICON" ]]; then
    ICON="airplane"
fi

# enviar notificación (notify-send)
if command -v notify-send > /dev/null 2>&1; then
    notify-send -u low -i "$ICON" "$TITLE" "$MESSAGE"
fi

touch "$FLAG_FILE"
chmod 600 "$FLAG_FILE" 2>/dev/null || true

exit 0

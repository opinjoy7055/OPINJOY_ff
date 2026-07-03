#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
#         OP INJOY FREE FIRE - TERMUX AUTO SETUP
# ============================================================

RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
GREEN="\033[92m"
YELLOW="\033[93m"
CYAN="\033[96m"
RED="\033[91m"
BLUE="\033[94m"
WHITE="\033[97m"
ORANGE="\033[38;5;214m"

RGB=(
    "\033[38;5;196m"
    "\033[38;5;202m"
    "\033[38;5;208m"
    "\033[38;5;214m"
    "\033[38;5;220m"
    "\033[38;5;226m"
    "\033[38;5;154m"
    "\033[38;5;118m"
    "\033[38;5;51m"
    "\033[38;5;45m"
    "\033[38;5;21m"
    "\033[38;5;57m"
    "\033[38;5;93m"
    "\033[38;5;201m"
    "\033[38;5;198m"
)
RGB_LEN=15

FLASH=("$RED" "$ORANGE" "$YELLOW" "$WHITE" "$ORANGE" "$RED" "$YELLOW" "$ORANGE" "$WHITE" "$RED" "$YELLOW" "$ORANGE" "$RED")

# ============================================================
# FREE FIRE LOGO
# ============================================================
FF_L0="            ⣀⣠⡤                        "
FF_L1="   ⢀⣤⡶⠁⣠⣴⣾⠟⠋⠁                          "
FF_L2="  ⢀⣴⣿⣿⣴⣿⠿⠋⣁⣀⣀⣀⣀⣀⡀                      "
FF_L3="  ⣰⣿⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣄⡀                "
FF_L4="⣠⣾⣿⡿⠟⠋⠉⠀⣀⣀⣨⣭⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣤⣤⣤⣴⠂"
FF_L5="⠈⠉⠁⠀⣀⣴⣾⣿⣿⡿⠟⠛⠉⠉⠉⠉⠛⠻⠿⠿⠿⠿⠿⠿⠟⠋⠁          "
FF_L6="   ⢀⣴⣿⣿⣿⡿⠁⢀⣀⣤⣤⣤⣤⣀⣀                      "
FF_L7="   ⣾⣿⣿⣿⡿⠁⢀⣴⣿⠋⠉⠉⠉⠉⠛⣿⣿⣶⣤⣤⣤⣤⣶⠖            "
FF_L8="  ⢸⣿⣿⣿⣿⡇⢀⣿⣿⣇⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⡿⠃              "
FF_L9="  ⠸⣿⣿⣿⣿⡇⠈⢿⣿⣿⠇⠀⠀⠀⠀⢠⣿⣿⣿⠟⠋                "
FF_LA="   ⢿⣿⣿⣿⣷⡀⠀⠉⠉⠀⠀⠀⢀⣾⣿⣿⡏                    "
FF_LB="    ⠙⢿⣿⣿⣷⣄⡀⠀⠀⣀⣴⣿⣿⣿⣋⣠⡤⠄                  "
FF_LC="       ⠈⠙⠛⠛⠿⠿⠿⠿⠿⠟⠛⠛⠛⠉⠁                   "

print_ff_logo() {
    local offset=${1:-0}
    local dim=${2:-0}
    local ri=$(( RANDOM % RGB_LEN ))
    local rc="${RGB[$ri]}"

    echo -e "  ${rc}${BOLD} loading setup ...... ${RESET}"
    echo ""

    local lines=("$FF_L0" "$FF_L1" "$FF_L2" "$FF_L3" "$FF_L4" "$FF_L5" "$FF_L6" "$FF_L7" "$FF_L8" "$FF_L9" "$FF_LA" "$FF_LB" "$FF_LC")
    local i
    for i in $(seq 0 12); do
        local ci=$(( (i + offset) % 13 ))
        local c="${FLASH[$ci]}"
        if [ "$dim" -eq 1 ] && [ $(( i % 2 )) -ne 0 ]; then
            echo -e "  ${RED}${DIM}${lines[$i]}${RESET}"
        else
            echo -e "  ${c}${BOLD}${lines[$i]}${RESET}"
        fi
    done
    echo ""
}

# ============================================================
# ANIMATION
# ============================================================
ANIM_PID=""
FF_FLAG="${TMPDIR:-$HOME}/_op_injoy_ff_flag"
LOGO_ROWS=16
STATUS_ROW=$(( LOGO_ROWS + 2 ))

start_anim() {
    touch "$FF_FLAG"
    (
        local offset=0
        while [ -f "$FF_FLAG" ]; do
            printf "\033[H"
            local mode=$(( offset % 3 ))
            if [ "$mode" -eq 2 ]; then
                print_ff_logo "$offset" 1
            else
                print_ff_logo "$offset" 0
            fi
            offset=$(( (offset + 1) % 39 ))
            sleep 0.15
        done
    ) &
    ANIM_PID=$!
}

stop_anim() {
    rm -f "$FF_FLAG" 2>/dev/null
    [ -n "$ANIM_PID" ] && kill "$ANIM_PID" 2>/dev/null && wait "$ANIM_PID" 2>/dev/null
    ANIM_PID=""
}

# ============================================================
# RGB PROGRESS BAR
# ============================================================
rgb_bar() {
    local filled=$1
    local total=30
    local bar=""
    for i in $(seq 1 $total); do
        local ci=$(( (i + filled) % RGB_LEN ))
        local c="${RGB[$ci]}"
        if [ "$i" -le "$filled" ]; then
            bar="${bar}${c}${BOLD}█${RESET}"
        else
            bar="${bar}${DIM}░${RESET}"
        fi
    done
    echo -ne "$bar"
}

print_status() {
    local idx=$1
    local total=$2
    local name=$3
    local state=$4
    local pct=$(( idx * 100 / total ))
    local filled=$(( idx * 30 / total ))
    local ci=$(( idx % RGB_LEN ))
    local c="${RGB[$ci]}"

    printf "\033[%d;0H\033[2K" "$STATUS_ROW"
    echo -ne "  "
    rgb_bar "$filled"
    echo ""

    printf "\033[%d;0H\033[2K" "$(( STATUS_ROW + 1 ))"
    if   [ "$state" = "ok" ];   then echo -e "  ${GREEN}${BOLD}[✔] $name${RESET}  ($pct%)"
    elif [ "$state" = "fail" ]; then echo -e "  ${RED}${BOLD}[✗] $name FAILED${RESET}  ($pct%)"
    else                             echo -e "  ${c}${BOLD}[*] Installing $name...${RESET}  ($pct%)"
    fi
}

# ============================================================
# STEP 1 — Storage Permission
# ============================================================
clear
echo -e "${CYAN}${BOLD}  [*] Checking storage permission...${RESET}"

STORAGE_OK=0

# Check karo folder hai ya nahi
if [ -d ~/storage/shared ] || [ -d ~/storage/downloads ]; then
    STORAGE_OK=1
fi

# Check karo sach mein file write ho sakti hai ya nahi
if [ "$STORAGE_OK" -eq 1 ]; then
    if ! touch ~/storage/downloads/.test_write 2>/dev/null; then
        STORAGE_OK=0
    else
        rm -f ~/storage/downloads/.test_write 2>/dev/null
    fi
fi

if [ "$STORAGE_OK" -eq 0 ]; then
    echo -e "${YELLOW}${BOLD}  [!] Storage permission not found!${RESET}"
    echo -e "${YELLOW}${BOLD}  [!] Requesting permission...${RESET}"
    termux-setup-storage
    sleep 3
    echo -e "${GREEN}${BOLD}  [✔] Permission granted!${RESET}"
else
    echo -e "${GREEN}${BOLD}  [✔] Storage already permitted, skipping...${RESET}"
fi
echo ""

# ============================================================
# STEP 2 — pkg update
# ============================================================
echo -e "${CYAN}${BOLD}  [*] Updating packages...${RESET}"
pkg update -y 2>/dev/null || true
pkg upgrade -y 2>/dev/null
echo -e "${GREEN}${BOLD}  [✔] Packages updated${RESET}"
echo ""

# ============================================================
# STEP 3 — Python
# ============================================================
echo -e "${CYAN}${BOLD}  [*] Checking Python...${RESET}"
if command -v python3 &>/dev/null; then
    echo -e "${GREEN}${BOLD}  [✔] Python: $(python3 --version)${RESET}"
else
    echo -e "${YELLOW}${BOLD}  [!] Installing Python...${RESET}"
    pkg install python -y
    command -v python3 &>/dev/null || { echo -e "${RED}${BOLD}  [✗] Python install failed!${RESET}"; exit 1; }
    echo -e "${GREEN}${BOLD}  [✔] Python installed${RESET}"
fi
echo ""

# ============================================================
# STEP 4 — pip
# ============================================================
echo -e "${CYAN}${BOLD}  [*] Upgrading pip...${RESET}"
python3 -m pip install --upgrade pip -q 2>/dev/null
echo -e "${GREEN}${BOLD}  [✔] pip ready${RESET}"
echo ""

# ============================================================
# STEP 5 — Git
# ============================================================
echo -e "${CYAN}${BOLD}  [*] Checking Git...${RESET}"
if command -v git &>/dev/null; then
    echo -e "${GREEN}${BOLD}  [✔] Git: $(git --version)${RESET}"
else
    pkg install git -y
    command -v git &>/dev/null || { echo -e "${RED}${BOLD}  [✗] Git install failed!${RESET}"; exit 1; }
    echo -e "${GREEN}${BOLD}  [✔] Git installed${RESET}"
fi
echo ""

# ============================================================
# STEP 6-7 — MODULE INSTALL (BOX UI + LOGO LIGHTNING + RGB)
# ============================================================

BOX_W=58
B="${CYAN}${BOLD}"
RS="${RESET}"

box_top()  { echo -e "${B}  ╔$(printf '═%.0s' $(seq 1 $BOX_W))╗${RS}"; }
box_bot()  { echo -e "${B}  ╚$(printf '═%.0s' $(seq 1 $BOX_W))╝${RS}"; }
box_line() { echo -e "${B}  ╠$(printf '═%.0s' $(seq 1 $BOX_W))╣${RS}"; }
box_empty(){ printf "${B}  ║${RS}%-${BOX_W}s${B}║${RS}\n" ""; }

box_center() {
    local text="$1" color="${2:-$WHITE}"
    local clean; clean=$(echo -e "$text" | sed 's/\x1b\[[0-9;]*m//g')
    local tlen=${#clean}
    local lpad=$(( (BOX_W - tlen) / 2 ))
    local rpad=$(( BOX_W - tlen - lpad ))
    printf "${B}  ║${RS}%${lpad}s${color}${BOLD}%s${RS}%${rpad}s${B}║${RS}\n" "" "$text" ""
}

box_left() {
    local text="$1" color="${2:-$WHITE}"
    local clean; clean=$(echo -e "$text" | sed 's/\x1b\[[0-9;]*m//g')
    local pad=$(( BOX_W - ${#clean} - 2 ))
    [ $pad -lt 0 ] && pad=0
    printf "${B}  ║${RS} ${color}${BOLD}%s${RS}%${pad}s${B} ║${RS}\n" "$text" ""
}

# ── Logo lines 6 hain (53 char har ek) ──
LOGO_LINES=(
    "░█████╗░██████╗░ ██╗███╗   ██╗░░░██╗░█████╗░██╗   ██╗"
    "██╔══██╗██╔══██╗ ██║████╗  ██║░░░██║██╔══██╗╚██╗ ██╔╝"
    "██║  ██║██████╔╝ ██║██╔██╗ ██║░░░██║██║  ██║ ╚████╔╝ "
    "██║  ██║██╔═══╝░ ██║██║╚██╗██║██╗██║██║  ██║  ╚██╔╝  "
    "╚█████╔╝██║      ██║██║ ╚████║╚███╔╝╚█████╔╝   ██║   "
    "░╚════╝░╚═╝      ╚═╝╚═╝  ╚═══╝░╚══╝░░╚════╝░   ╚═╝   "
)

# ── Logo ek baar flash karega (3 colors mein) ──
flash_logo() {
    local colors=("$RED" "$YELLOW" "$CYAN" "$GREEN" "$ORANGE" "$WHITE")
    local ci=0
    for round in 1 2 3; do
        # Upar jaakar logo wapas draw karo (6 lines + 2 box lines = 8)
        printf "\033[8A"
        box_line
        for line in "${LOGO_LINES[@]}"; do
            local c="${colors[$ci]}"
            ci=$(( (ci + 1) % ${#colors[@]} ))
            box_center "$line" "$c"
        done
        box_line
        sleep 0.18
    done
}

# ── RGB progress bar (Box ke andar) ──
rgb_progress_box() {
    local done=$1 total=$2
    local filled=$(( done * (BOX_W - 4) / total ))
    local empty=$(( BOX_W - 4 - filled ))
    local bar=""
    local ci=0
    for i in $(seq 1 $filled); do
        ci=$(( (i + done) % RGB_LEN ))
        bar="${bar}${RGB[$ci]}${BOLD}█${RS}"
    done
    for i in $(seq 1 $empty); do
        bar="${bar}${DIM}░${RS}"
    done
    printf "${B}  ║${RS} ${bar} ${B}║${RS}\n"
}

# ══════════════════ Box draw karna shuru ══════════════════
clear
box_top
box_center "⚡  O P  I N J O Y  B O T  ⚡" "$YELLOW"
box_center "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "$YELLOW"
box_line

# Logo pehli baar draw karo
for line in "${LOGO_LINES[@]}"; do
    box_center "$line" "$CYAN"
done
box_line

# Logo flash animation
flash_logo

# install header
box_center "📦  Installing Modules  📦" "$YELLOW"
box_line

FAILED=()
MODULES=(
    "psutil|pkg"
    "requests|pip"
    "PyJWT|pip"
    "urllib3|pip"
    "aiohttp|pip"
    "flask|pip"
    "pycryptodome|pip"
    "protobuf|pip"
    "protobuf-decoder|pip"
    "google-play-scraper|pip"
    "pytz|pip"
    "pyfiglet|pip"
)
TOTAL=${#MODULES[@]}
DONE=0

for entry in "${MODULES[@]}"; do
    name="${entry%%|*}"
    method="${entry##*|}"
    DONE=$(( DONE + 1 ))

    # ⏳ installing row
    box_left "  ⏳ ${name}  [${DONE}/${TOTAL}]" "$YELLOW"

    if [ "$method" = "pkg" ]; then
        pkg install "python-${name}" -y &>/dev/null || python3 -m pip install "$name" -q &>/dev/null
    else
        python3 -m pip install "$name" -q &>/dev/null
    fi

    if [ $? -eq 0 ]; then
        # Upar wali line mita kar ✔ dikhao
        printf "\033[1A\033[2K"
        box_left "  ✔  ${name}" "$GREEN"
    else
        printf "\033[1A\033[2K"
        box_left "  ✗  ${name} FAILED" "$RED"
        FAILED+=("$name")
    fi

    # RGB progress bar update
    rgb_progress_box "$DONE" "$TOTAL"
    # Agle loop mein bar mita kar wapas draw karega
    printf "\033[1A"

done

# Last bar full dikhao
echo ""
rgb_progress_box "$TOTAL" "$TOTAL"
box_bot

# ============================================================
# FINAL REPORT
# ============================================================
clear
print_ff_logo 4 0
echo -e "${BLUE}${BOLD}  ══════════════════════════════════════════════════════${RESET}"
if [ ${#FAILED[@]} -gt 0 ]; then
    echo -e "${YELLOW}${BOLD}  [!] Failed modules:${RESET}"
    for f in "${FAILED[@]}"; do
        echo -e "  ${RED}    ✗ $f${RESET}"
    done
    echo -e "${YELLOW}${BOLD}  [!] Check internet and retry.${RESET}"
else
    echo -e "${GREEN}${BOLD}  [✔] All modules installed successfully!${RESET}"
fi
echo -e "${BLUE}${BOLD}  ══════════════════════════════════════════════════════${RESET}"
echo ""

# ============================================================
# STEP 9 — Clone repo & run main.py
# ============================================================
REPO_URL="https://github.com/opinjoy7055/OPINJOY_ff.git"
REPO_DIR="$HOME/$(basename "$REPO_URL" .git)"

echo -e "${CYAN}${BOLD}  [*] Cloning repository...${RESET}"
echo -e "${DIM}      $REPO_URL${RESET}"
echo ""

if [ -d "$REPO_DIR/.git" ]; then
    echo -e "${YELLOW}${BOLD}  [!] Repo exists, pulling latest...${RESET}"
    git -C "$REPO_DIR" pull 2>/dev/null
    echo -e "${GREEN}${BOLD}  [✔] Repo updated${RESET}"
else
    git clone "$REPO_URL" "$REPO_DIR"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}${BOLD}  [✔] Repo cloned${RESET}"
    else
        echo -e "${RED}${BOLD}  [✗] Clone failed! Check repo URL.${RESET}"
        exit 1
    fi
fi

echo ""
MAIN_PATH="$REPO_DIR/main.py"

if [ -f "$MAIN_PATH" ]; then
    echo -e "${GREEN}${BOLD}  [✔] main.py found${RESET}"
    echo ""
    echo -e "${BLUE}${BOLD}  ══════════════════════════════════════════════════════${RESET}"
    echo -e "${GREEN}${BOLD}       Setup complete! Launching...${RESET}"
    echo -e "${BLUE}${BOLD}  ══════════════════════════════════════════════════════${RESET}"
    echo ""
    sleep 1
    cd "$REPO_DIR" && python3 main.py
else
    echo -e "${RED}${BOLD}  [✗] main.py not found in repo!${RESET}"
    echo -e "${CYAN}      Run: python3 $MAIN_PATH${RESET}"
fi

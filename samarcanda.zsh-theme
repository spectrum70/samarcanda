# samarcanda
# By Angelo Durghello With LLM help

function get_custom_git_stats() {
    # Se non siamo in un repo Git, esce senza stampare nulla
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        return
    fi

    # Recupera il nome del branch
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

    # Conta lo stato dei file nel repository
    local status_output=$(git status --porcelain 2>/dev/null)
    local staged=$(echo "$status_output" | grep -c "^[AMDRT]")
    local changed=$(echo "$status_output" | grep -c "^.[MDRT]")
    local untracked=$(echo "$status_output" | grep -c "^??")

    # Colori dei contatori
    local c_branch="%F{39}"    # Azzurro
    local c_staged="%F{76}"    # Verde
    local c_changed="%F{214}"  # Arancione
    local c_untracked="%F{244}" # Grigio
    local c_clean="%F{76}"     # Verde per spunta

    # Costruzione della stringa Git
    local git_str="  %B%F{244}(%F{214}${c_branch}${branch}%F{244}"
    local has_changes=0

    git_str+="%B"
    if [ "$staged" -gt 0 ]; then git_str+="|${c_staged}✚${staged}"; has_changes=1; fi
    if [ "$changed" -gt 0 ]; then git_str+="|${c_changed}●${changed}"; has_changes=1; fi
    if [ "$untracked" -gt 0 ]; then git_str+="|${c_untracked}…${untracked}"; has_changes=1; fi

    # Se il repository è perfettamente pulito
    if [ "$has_changes" -eq 0 ]; then
        git_str+="|${c_clean}✓"
    fi

    git_str+=")%b%f"
    echo "$git_str"
}

PROMPT='%F{76}✨%f %B%F{250}%~%f$(get_custom_git_stats)%b $ '


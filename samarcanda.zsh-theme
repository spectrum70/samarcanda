# samarcanda
# By Angelo Durghello With LLM help

function get_custom_git_stats() {
    local ahead=0
    local behind=0

    # Check for git repo
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        return
    fi

    # Get branch name
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

    # Status
    local git_status_full=$(git status --porcelain -b 2>/dev/null)
    local branch_info=$(echo "$git_status_full" | head -n 1)
    if [[ "$branch_info" =~ "ahead ([0-9]+)" ]]; then
        ahead="${match[1]}"
    fi
    if [[ "$branch_info" =~ "behind ([0-9]+)" ]]; then
        behind="${match[1]}"
    fi

    local status_output=$(echo "$git_status_full" | grep -v "^##")
    local staged=$(echo "$status_output" | grep -c "^[AMDRT]")
    local changed=$(echo "$status_output" | grep -c "^.[MDRT]")
    local untracked=$(echo "$status_output" | grep -c "^??")

    # Colors
    local c_branch="%F{39}"      # Cyan
    local c_staged="%F{76}"      # Green 
    local c_changed="%F{214}"    # Orange
    local c_untracked="%F{244}"  # Grey
    local c_remote="%F{75}"
    local c_clean="%F{76}"       # Green/ok

    # Build up Git string
    local git_str="  %B%F{244}(%F{214}${c_branch}${branch}%F{244}"
    local has_changes=0

    git_str+="%B"
    if [ "$staged" -gt 0 ]; then git_str+="|${c_staged}✚${staged}"; has_changes=1; fi
    if [ "$changed" -gt 0 ]; then git_str+="|${c_changed}●${changed}"; has_changes=1; fi
    if [ "$untracked" -gt 0 ]; then git_str+="|${c_untracked}…${untracked}"; has_changes=1; fi

    # If perfectly clean
    if [ "$has_changes" -eq 0 ]; then
        git_str+="|${c_clean}✓"
    fi

    # Align with remote: ⇡ (Ahead), ⇣ (Behind)
    if [ "$ahead" -gt 0 ]; then git_str+=" ${c_remote}⇡${ahead}"; fi
    if [ "$behind" -gt 0 ]; then git_str+=" ${c_remote}⇣${behind}"; fi

    git_str+=")%b%f"
    echo "$git_str"
}

PROMPT='%F{76}✨%f %B%F{250}%~%f$(get_custom_git_stats)%b $ '


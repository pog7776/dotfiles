# Track loaded custom modules in a global array
typeset -gaU LOADED_ZSH_CONFIGS
LOADED_ZSH_CONFIGS=()

# Iterate and source everything in conf.d
for file in ~/.config/zsh/conf.d/*.zsh; do
    if [[ -r "$file" ]]; then
        source "$file"
        LOADED_ZSH_CONFIGS+=("${file:t}")
    fi
done

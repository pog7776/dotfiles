for file in ~/.config/zsh/conf.d/windows/*.zsh; do
    if [[ -r "$file" ]]; then
        source "$file"
    fi
done

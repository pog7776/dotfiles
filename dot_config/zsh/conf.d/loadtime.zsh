loadtime () {
    if [[ -n "$ZSH_LOAD_TIME" ]]; then
        printf "Zsh initialized in %.2f ms\n" $ZSH_LOAD_TIME
    else
        echo "Zsh load time metric unavailable."
    fi
}

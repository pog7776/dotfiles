# Seamless Perforce wrapper for WSL & Symlinks
# p4() {
#   local real_path=$(pwd -P)
#   if [[ "$real_path" == /mnt/c/* ]]; then
#     p4.exe "$@"
#   else
#     command p4 -d "$real_path" "$@"
#   fi
# }

p4() {
  local mode="auto"

  # Parse force flags if passed as the first argument
  case "$1" in
    --win|-w)
      mode="win"
      shift
      ;;
    --native|--linux|-l)
      mode="linux"
      shift
      ;;
  esac

  local real_path=$(pwd -P)

  if [[ "$mode" == "win" ]] || { [[ "$mode" == "auto" ]] && [[ "$real_path" == /mnt/c/* ]]; }; then
    p4.exe "$@"
  else
    command p4 -d "$real_path" "$@"
  fi
}

# Improved PATH handling

path_array=(
    /home/linuxbrew/.linuxbrew/bin
    /home/linuxbrew/.linuxbrew/sbin
    /bin/tesseract
    $HOME/.local/bin
    $HOME/.asdf/shims
    $HOME/.local/share/pnpm
    $HOME/.asdf/bin
    $HOME/.deno/bin
    $HOME/.rye/shims
    /usr/local/bin
    /usr/bin
    /bin
    /usr/local/games
    /usr/games
    /snap/bin
    $HOME/.dotnet/tools
    $HOME/.local/share/JetBrains/Toolbox/scripts
    $HOME/.yarn/bin
    $OH_MY_ZSH_HOME/custom/plugins/fzf/bin
    /home/tiagoluizpoli/.asdf/installs/nodejs/20.18.3/bin #This line still has an absolute path
)

# Remove duplicate paths and ensure paths exist
path_array=($(printf "%s\n" "${path_array[@]}" | sort -u))

# Add paths to PATH
for path in "${path_array[@]}"; do
  if [ -d "$path" ] && [[ ":$PATH:" != *":$path:"* ]]; then
    PATH="$path:$PATH"
  fi
done

export PATH
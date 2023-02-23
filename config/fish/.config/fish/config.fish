if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Support to use  the !! for run previous command
function sudo
    if test "$argv" = !!
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end

# Pacman
abbr -a -g pmcs "pacman -Ss"
abbr -a -g pmcr "sudo pacman -Rc"
abbr -a -g pmci "sudo pacman -S"
abbr -a -g pmccc "sudo pacman -Scc"
abbr -a -g pmcu "sudo pacman -Sy"
abbr -a -g pmcsu "sudo pacman -Syu"

# Yay
abbr -a -g yys "yay -Ss"
abbr -a -g yyi "yay -S"
abbr -a -g yyr "yay -Rc"
abbr -a -g yyu "yay -Sy"
abbr -a -g yysu "yay -Syu"
abbr -a -g yycc "yay -Sc"

# Config
abbr -a -g polyconf "vim $HOME/.config/polybar/config"
abbr -a -g i3conf "vim $HOME/.config/i3/config"
abbr -a -g dunstconf "vim $HOME/.config/dunst/dunstrc"

# Short hand
abbr -a -g vscup "yay -Sy && yay -S visual-studio-code-bin"

# Aura Dev
abbr -a -g mkcls "make clean"
abbr -a -g mkup "make update PM=pnpm"
abbr -a -g mksvr "make server PM=pnpm"

# Git
abbr -a -g gtf "git fetch"
abbr -a -g gtfp "git fetch --prune"
abbr -a -g gtpl "git pull"
abbr -a -g gtps "git push"
abbr -a -g gts "git stash"
abbr -a -g gtsa "git stash apply"
abbr -a -g gtsd "git stash drop"

# Git Flow
abbr -a -g gfi "git flow init"
abbr -a -g gffs "git flow feature start"
abbr -a -g gfff "git flow feature finish"
abbr -a -g gfbs "git flow bugfix start"
abbr -a -g gfbf "git flow bugfix finish"
abbr -a -g gfrs "git flow release start"
abbr -a -g gfrf "git flow release finish"
abbr -a -g gfhs "git flow hotfix start"
abbr -a -g gfhf "git flow hotfix finish"
abbr -a -g gfss "git flow support start"

# PHPBREW #
abbr -a -g brew "phpbrew"
abbr -a -g brewu "phpbrew use"
abbr -a -g brewl "phpbrew list"
abbr -a -g brewi "phpbrew install"
abbr -a -g brewei "phpbrew ext install"
abbr -a -g brewo "phpbrew switchh-off"

abbr -a -g fishsrc "source ~/.config/fish/config.fish"

abbr -a -g xrc "xrdb -merge $HOME/.Xresources"

# THEME PURE #
set fish_function_path /home/kali/.config/fish/functions/theme-pure/functions/ $fish_function_path
source /home/kali/.config/fish/functions/theme-pure/conf.d/pure.fish
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
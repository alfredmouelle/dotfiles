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
abbr -a -g pmc-s "pacman -Ss"
abbr -a -g pmc-r "sudo pacman -Rc"
abbr -a -g pmc-i "sudo pacman -S"
abbr -a -g pmc-cc "sudo pacman -Scc"
abbr -a -g pmc-u "sudo pacman -Sy"
abbr -a -g pmc-su "sudo pacman -Syu"

# Yay
abbr -a -g yy-s "yay -Ss"
abbr -a -g yy-i "yay -S"
abbr -a -g yy-r "yay -Rc"
abbr -a -g yy-u "yay -Sy"
abbr -a -g yy-su "yay -Syu"
abbr -a -g yy-cc "yay -Sc"

# Config
abbr -a -g polyconf "vim $HOME/.config/polybar/config"
abbr -a -g i3conf "vim $HOME/.config/i3/config"
abbr -a -g dunstconf "vim $HOME/.config/dunst/dunstrc"
abbr -a -g crittyconf "vim $HOME/.config/alacritty/alacritty.yml"

# Short hand
abbr -a -g vscupdate "yay -Sy && yay -S visual-studio-code-bin"

# Aura Dev
abbr -a -g mkcls "make clean"
abbr -a -g mkup "make update PM=pnpm"
abbr -a -g mksvr "make server PM=pnpm"

abbr -a -g fishsrc "source ~/.config/fish/config.fish"

# THEME PURE #
set fish_function_path /home/kali/.config/fish/functions/theme-pure/functions/ $fish_function_path
source /home/kali/.config/fish/functions/theme-pure/conf.d/pure.fish

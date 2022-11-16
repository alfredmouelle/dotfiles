stow = cd config && stow -v -t ~

.PHONY: fonts
fonts:
	xargs -d '\n' -a packages/fonts.list yay --noconfirm --needed -S

.PHONY: system
system: fonts
	xargs -d '\n' -a packages/system.list yay --noconfirm --needed -S

.PHONY: i3
i3: fonts system
	xargs -d '\n' -a packages/i3.list yay --noconfirm --needed -S

.PHONY: base
base: fonts
	xargs -d '\n' -a packages/base.list yay --noconfirm --needed -S

.PHONY: install
install: fonts system i3 base

.PHONY: conf
conf:
	$(stow) urxvt
	xrdb ~/.Xresources
	$(stow) dunst
	$(stow) fish
	$(stow) git
	$(stow) gtk-3.0
	$(stow) i3
	$(stow) omf
	$(stow) picom
	$(stow) polybar
	$(stow) rofi
	$(stow) Thunar
	cp -f ./.bashrc ~/.bashrc

.PHONY: restore
restore: install conf

.PHONY: test
test:
	$(stow) picom

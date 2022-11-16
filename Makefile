stow = cd config && stow -v -t ~

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	
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
	$(stow) i3
	$(stow) picom
	$(stow) polybar
	$(stow) rofi
	cp ./config/git/.gitignore ~/.gitignore

.PHONY: restore
restore: install conf

.PHONY: test
test:
	$(stow) git
	cp ./config/git/.gitignore ~/.gitignore

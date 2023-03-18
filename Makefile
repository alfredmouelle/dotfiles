stow = cd config && stow -v -t ~/

.PHONY: help
help: ## Affiche cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: fonts
fonts: ## Installer toutes les fonts nécessaires
	xargs -d '\n' -a packages/fonts.list yay --noconfirm --needed -S

.PHONY: system
system: fonts ## Installe les packages core
	xargs -d '\n' -a packages/system.list yay --noconfirm --needed -S

.PHONY: i3
i3: fonts system ## Installer i3 et ses dépendances
	xargs -d '\n' -a packages/i3.list yay --noconfirm --needed -S

.PHONY: base
base: fonts ## Installer les logiciels de bases
	xargs -d '\n' -a packages/base.list yay --noconfirm --needed -S

.PHONY: install ## Execute toutes les installations
install: fonts system i3 base

.PHONY: conf
conf: ## Link mes confs à mon système
	$(stow) urxvt
	xrdb -merge ~/.Xresources
	$(stow) dunst
	$(stow) fish
	$(stow) git
	$(stow) i3
	$(stow) vim
	$(stow) picom
	$(stow) polybar
	$(stow) rofi
	cp ./config/git/.gitignore ~/.gitignore

.PHONY: restore
restore: install conf ## Restore entièrement mon système

.PHONY: test
test:
	$(stow) vim

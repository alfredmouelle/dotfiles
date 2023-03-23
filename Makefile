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



.PHONY: services
services: ## Active les services
	chsh -s /bin/fish kali
	systemctl enable polkit
	systemctl enable lightdm
	systemctl enable NetworkManager



.PHONY: dev
dev: ## Installe les packages de dev
	xargs -d '\n' -a packages/base.list yay --noconfirm --needed -S
	mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	systemctl enable mysql
	#usermod -aG mysql kali

	## Phpbrew
	curl -L -O https://github.com/phpbrew/phpbrew/releases/latest/download/phpbrew.phar
	chmod +x phpbrew.phar
	mv phpbrew.phar /usr/local/bin/phpbrew
	sudo -su kali phpbrew init

	## Volta
	sudo -su kali curl https://get.volta.sh | bash
	sudo -su kali volta install node
	sudo -su kali volta install pnpm



.PHONY: conf
conf: ## Link mes confs à mon système
	$(stow) urxvt
	xrdb -merge ~/.Xresources
	$(stow) i3
	$(stow) git
	$(stow) vim
	$(stow) rofi
	$(stow) fish
	$(stow) dunst
	$(stow) picom
	$(stow) polybar
	cp ./config/git/.gitignore ~/.gitignore



.PHONY: restore
restore: install conf services ## Restore entièrement mon système
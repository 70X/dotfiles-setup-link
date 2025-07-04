REPO_DIRECTORY=~/.dotfiles

function install_homebrew {
	echo "------ HOMEBREW -------"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	for package in $(cat ./osx/packages.txt); do
		brew install $package
	done
}

# function install_oh_my {
#     echo "------ OH MY -------"
#     sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#     echo "(Setting theme)"
#     sed -I "" "s/^ZSH_THEME=.*/DEFAULT_USER=$USER\nZSH_THEME=agnoster/" ~/.zshrc
# }

# install_oh_my

echo "------ COPYING THIS REPO -------"
cd ~
if [ ! -d $REPO_DIRECTORY ]; then
	git clone https://github.com/70X/dotfiles-setup-link.git $REPO_DIRECTORY
fi

cd $REPO_DIRECTORY
git pull

function create_and_overwrite_dotfiles {
	for item in $(ls); do
		new_item=$(echo $item | sed s/^_/./)
		echo "$item -> $new_item"
		if [ -d $item ]; then
			cp -r $item ~/$new_item
		else
			cp $item ~/$new_item
		fi
	done
}

install_homebrew

cd "./osx/dotfiles"
create_and_overwrite_dotfiles

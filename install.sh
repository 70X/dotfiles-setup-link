OS=unnamed #Darwin
REPO_DIRECTORY=~/.dotfiles

function install_homebrew {
    echo "------ HOMEBREW -------"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    for package in $(cat ./osx/packages.txt)
    do
        brew install $package
				break
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
if [ ! -d $REPO_DIRECTORY ]
then
    git clone https://github.com/70X/dotfiles-setup-link.git $REPO_DIRECTORY
fi

cd $REPO_DIRECTORY
git pull

if [ $OS == "Darwin" ]
then
	folder="./osx/dotfiles"
	install_homebrew
else
	echo "OS no supported: $OS"
	exit 1
fi

cd $folder

for item in $(ls)
do
  new_item=$(echo $item | sed s/^_/./)
	echo "$item -> $new_item"
	if [ -d $item ]
	then
			cp -r $item ~/$new_item
	else
			cp $item ~/$new_item
	fi
done
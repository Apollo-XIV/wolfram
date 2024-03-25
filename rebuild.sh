git add .
git commit
sudo nixos-rebuild switch --flake ~/.config/nixos#default && \
git push

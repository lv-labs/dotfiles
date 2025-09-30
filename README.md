# luke's dotfiles


⚡ bootstrap a fresh mac

# install Xcode CLI tools
```bash
xcode-select --install
```

# get git (via apple cli tools)
```bash
git --version
```

# clone dotfiles
```bash
git clone https://github.com/lv-labs/dotfiles.git ~/Documents/lv-labs/dotfiles
cd ~/Documents/lv-labs/dotfiles/scripts
```

# run bootstrap
```bash
chmod +x bootstrap.sh
./bootstrap.sh
```


generate SSH keys


1. new personal ssh key
```bash
ssh-keygen -t ed25519 -C "your_personal_email@example.com" -f ~/.ssh/id_ed25519_personal
chmod 600 ~/.ssh/id_ed25519_personal
```

repeat for id_ed25519_work.



2. add to agent:
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_personal
ssh-add ~/.ssh/id_ed25519_work
```

3. upload to github

```bash
cat ~/.ssh/id_ed25519_personal.pub
cat ~/.ssh/id_ed25519_work.pub
```

4. set dotfiles to ssh
```bash
cd ~/Documents/lv-labs/dotfiles
git remote set-url origin git@github.com-personal:lv-labs/dotfiles.git
```


4. test:

```bash
ssh -T git@github.com-personal
ssh -T git@github.com-work
```

# finalise setup with work kicad libraries
```bash 
cd ~/Documents/lv-labs/dotfiles/scripts
chmod +x setup_kicad.sh
./setup_kicad.sh
```



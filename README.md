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


restore SSH keys


1. copy private key from 1Password → paste into ~/.ssh/id_ed25519_personal
```bash
nano ~/.ssh/id_ed25519_personal
chmod 600 ~/.ssh/id_ed25519_personal
```

repeat for id_ed25519_work.


2. add .pub files.

3. add to agent:
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_personal
ssh-add ~/.ssh/id_ed25519_work
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



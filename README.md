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


add SSH keys


1. new personal ssh key
```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
```

# create and paste private key
```bash
nano ~/.ssh/id_ed25519_personal
```
# paste the private key content, save (Ctrl+O, Enter, Ctrl+X)

# create and paste public key
```bash
nano ~/.ssh/id_ed25519_personal.pub
```
# paste, save

# repeat for work
```bash
nano ~/.ssh/id_ed25519_work
nano ~/.ssh/id_ed25519_work.pub
```

# fix permissions
```bash
chmod 600 ~/.ssh/id_ed25519_personal ~/.ssh/id_ed25519_work
chmod 644 ~/.ssh/id_ed25519_personal.pub ~/.ssh/id_ed25519_work.pub
```



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



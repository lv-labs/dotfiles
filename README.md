# Luke's dotfiles

Personal settings for my Macs, plus a few useful scripts. Set up each component
when needed; there is no all-in-one bootstrap script. Application installation,
SSH keys, and work repositories are managed separately.

## What's here

| File or folder | Purpose | Installed location |
| --- | --- | --- |
| `zshrc` | Shell setup, completion, aliases, and functions | `~/.zshrc` |
| `zsh/fade.zsh` | Fade prompt with Git status and Python environment | `~/.config/zsh/fade.zsh` |
| `gitconfig` | Personal Git identity and work-folder override | `~/.gitconfig` |
| `gitconfig-work` | Git identity for repositories under `~/Documents/thonk/` | `~/.gitconfig-work` |
| `.ssh/config` | Personal and work GitHub SSH host aliases | `~/.ssh/config` |
| `ghostty/` | Terminal appearance and behaviour | `~/.config/ghostty` |
| `dinky/dinky.toml` | Dinky window management and shortcuts | `~/.config/dinky/dinky.toml` |
| `aerospace.toml` | Previous AeroSpace configuration, kept for reference / other Macs | `~/.aerospace.toml` |
| `vscode/` | Settings, shortcuts, tasks, and extension list | VS Code's user settings folder |
| `tuna/config.toml` | Live Tuna configuration | Select the repo’s `tuna/` folder in Tuna Settings |
| `tuna/scripts/current_workspace.py` | Keep new windows on the current workspace | Linked by `scripts/setup_tuna.sh` |
| `tuna/scripts/open_here.py` | Open Finder, Ghostty, or VS Code at the current folder | Linked by `scripts/setup_tuna.sh` |
| `scripts/check_gerbers.sh` | Process a supplier Gerber ZIP and optionally open GerbView | Run explicitly when needed |
| `scripts/setup_tuna.sh` | Link the Tuna helper and VS Code tasks | Run explicitly when needed |
| `scripts/setup_kicad.sh` | Clone the work KiCad library and set GUI environment variables | Optional work-machine setup |

The old bootstrap, duplicate Git configs, standalone “open here” scripts,
compiled centre-window executable, and repository checker have been retired.
Their previous versions remain in Git history.

## Restore only what you need

Clone this repository to `~/Documents/lv-labs/dotfiles`, or adjust the path below:

```sh
DOTFILES="$HOME/Documents/lv-labs/dotfiles"
```

The commands below create links, not copies: edits to a linked configuration
change the file in this repository. Back up any existing regular files first.
They intentionally omit `-f` so an existing configuration is not overwritten.
If a destination is already correctly linked, leave it alone. For directory
links, the destination directory must not already exist.

### Shell and prompt

Install Zsh, Git, Oh My Zsh, and its `zsh-autosuggestions` and
`zsh-syntax-highlighting` plugins before loading this configuration. Install
`zoxide` for folder jumping and `uv` for the Python helpers. The PATH currently
assumes Apple Silicon Homebrew at `/opt/homebrew/bin` and the standard KiCad app
location; adjust these on a different machine. Pure is not required.

```sh
mkdir -p "$HOME/.config/zsh"
ln -s "$DOTFILES/zshrc" "$HOME/.zshrc"
ln -s "$DOTFILES/zsh/fade.zsh" "$HOME/.config/zsh/fade.zsh"
```

Open a new terminal tab, or use `zrl` to reload an already configured shell.
Edit `zsh/fade.zsh` for prompt appearance. Its `*` indicates uncommitted changes;
`↑N` counts commits ahead of the tracked upstream using the last fetched state.
The Python label appears while an environment is active.

Useful commands:

- `root`: go to the current Git repository's top folder.
- `z <keyword>`: jump to a folder zoxide has learned through previous visits.
- `ll` / `la`: detailed file listings, without / with hidden files.
- `zedit` / `zrl`: edit / reload the shell configuration.
- `mkvenv [name]` / `actvenv`: create and activate / activate a local `.venv`.
- `grh`: discard tracked changes only after an explicit confirmation.

### Git and SSH

```sh
ln -s "$DOTFILES/gitconfig" "$HOME/.gitconfig"
ln -s "$DOTFILES/gitconfig-work" "$HOME/.gitconfig-work"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
ln -s "$DOTFILES/.ssh/config" "$HOME/.ssh/config"
```

Use `gitconfig` and `gitconfig-work` as the authoritative Git settings.
The work override is selected by repository location under `~/Documents/thonk/`.
SSH aliases `github.com-personal` / `lv-labs` and `github.com-work` / `thonk`
select the respective SSH key. Restore or generate the keys separately and
register their public keys with the appropriate GitHub account. Private keys
are not part of this repository.

The personal config references `~/.gitignore_global`, which is currently missing
on the personal Mac. Restore the intended ignore rules or remove that setting
when deciding how global ignores should work.

### Ghostty and Dinky

Install the apps and the JetBrainsMono Nerd Font used by Ghostty. Dinky uses its
built-in borders, with the previous border width and colours.

```sh
mkdir -p "$HOME/.config"
ln -s "$DOTFILES/ghostty" "$HOME/.config/ghostty"
mkdir -p "$HOME/.config/dinky"
ln -s "$DOTFILES/dinky/dinky.toml" "$HOME/.config/dinky/dinky.toml"
ln -s "$DOTFILES/dinky/focus-next-display.py" "$HOME/.config/dinky/focus-next-display.py"
```

Back up Dinky's generated `dinky.toml` before linking if it already exists.
Dinky follows the symlink and reloads on save. Validate the config with:

```sh
/Applications/dinky.app/Contents/MacOS/dinky doctor --config "$DOTFILES/dinky/dinky.toml"
```

Quit AeroSpace before running Dinky, and turn off AeroSpace's launch-at-login
setting on machines you migrate. Stop any separately running `borders` service
if it is still drawing borders. Dinky is configured to start at login.

The migration preserves the 20-point inner / 16-point outer gaps, 20-point
accordion padding, floating rules, service mode, and most shortcuts. Differences
from AeroSpace, as described in Dinky's [configuration](https://dinky.rodeo/configuration/)
and [commands](https://dinky.rodeo/commands/) references:

- Workspaces use native macOS Spaces. There are ten: 1–7 on the main display,
  8–10 on the secondary (falling back to main when disconnected). `alt-0` and
  `alt-shift-0` select / move to workspace 10, replacing AeroSpace's workspace 0.
- `cmd-left/right` traverse only the focused display's workspaces.
- `alt-tab` runs the linked `focus-next-display.py` helper to cycle through
  connected displays, wrapping back to the first.
- `alt-shift-left/right` move within the workspace. Use `alt-shift-tab` to move
  the focused window to the next display and follow it; Dinky cannot move an
  entire workspace to another display via a command.
- `alt-slash` and `alt-comma` select tiles / accordion and toggle their orientation.
  Dinky's default tiles layout splits the focused tile along its longer side;
  AeroSpace's container normalization options have no direct config equivalent.
- `alt-shift-c` is commented out because the centre-window script is missing;
  see the outstanding items below.

The original `aerospace.toml` remains available for other Macs. To restore it,
link it to `~/.aerospace.toml`; its startup command still requires `borders`.

Workspace 8 uses the master layout. New normal Slack windows go there and take
the master position on the left (60% of the available width), with other windows
stacked on the right. Slack dialogs keep Dinky's usual floating behaviour.

KiCad's manager, Assign Footprints, Footprint Editor, and Symbol Editor windows
open tiled and in Dinky fullscreen, filling the current workspace while keeping
their place in the layout. `alt-f` returns them to their tile. PCB Editor and
Schematic Editor keep their normal tiling behaviour.

### VS Code and Tuna

```sh
VSCODE_USER="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER"
ln -s "$DOTFILES/vscode/settings.json" "$VSCODE_USER/settings.json"
ln -s "$DOTFILES/vscode/keybindings.json" "$VSCODE_USER/keybindings.json"
sh "$DOTFILES/scripts/setup_tuna.sh"
```

The Tuna setup script links its workspace helper and `vscode/tasks.json`,
backing up existing regular files at those destinations. Review
`vscode/extensions.txt` as a saved extension list rather than a complete,
automatically maintained dependency list.

In Tuna Settings → General → Configuration, select this repository’s `tuna/`
folder as the custom configuration folder. This Mac already uses it directly:
Tuna saves changes back to `tuna/config.toml`. Back up before editing it externally,
then run `open "tuna://config/reload"` to reload. Some existing commands still
include `/Users/luke` paths, so review them on another account.

In Tuna Combo Mode, the existing sequences work from Finder, Ghostty, Rex, or VS Code:

| Sequence | Action |
| --- | --- |
| `f` → `h` | New Finder window here |
| `g` → `h` | New Ghostty window here |
| `c` → `h` | New VS Code window here |
| `r` → `n` | New Rex tab |
| `r` → `h` | New Rex tab here |

“Here” means the front Finder window’s folder, the focused Ghostty terminal’s
working directory, the focused Rex terminal’s reported working directory, or
VS Code’s project folder. Opening the same app creates
another window at that folder. VS Code needs an open local project; with multiple
workspace folders it may ask which folder to use. Remote terminal paths must be
available locally; these commands do not establish SSH or remote VS Code sessions.

Rex actions use its bundled CLI and reuse the current Rex session. Open Rex with
a local session first. Rex also works as a source for every “here” action, using
its terminal `pwd` API. These bindings do not change macOS defaults.

The workspace helper prefers a running Dinky and falls back to AeroSpace on
machines still using it. It uses Dinky's bundled CLI, so no CLI symlink is needed.

The shared `open_here.py` helper waits for Tuna to dismiss, identifies the source
app, and delegates window placement to `current_workspace.py`. VS Code supplies
its project folder through the linked tasks and `ctrl+alt+cmd+f/g/c/r` keybindings.
Unsupported source apps produce an error rather than opening an unrelated Finder
folder. Allow the necessary Accessibility and Automation access when macOS
requests it.

### Optional work KiCad setup

Review `scripts/setup_kicad.sh` before running it on a work machine. It clones
`thonksynth/thonk-kicad-lib` using the work SSH alias, then uses `launchctl setenv`
for `THONK_LIB_DIR` and `THONK_3D_MODELS`. Those GUI environment settings are not a
persistent login setup. The script does not install KiCad preferences or tables.

## Scripts still to bring over from the work Mac

Keep the existing references until the real scripts have been copied and checked:

- **Gerber command:** `cgerb` currently calls `~/.cgerb.sh`. Copy the work Mac's
  script into `scripts/`, check whether it duplicates `check_gerbers.sh`, then
  update the alias or replace the old home-folder file with a symlink.
- **Centre window:** AeroSpace's `alt-shift-c` calls
  `/Users/luke/.center-window.sh`. Bring that script into `scripts/`, then update
  the binding or create a compatibility symlink on each Mac. The deleted
  compiled `scripts/center-window` was not the file referenced by the binding.
- **Screenshot shortcut:** `ss` calls `~/.screenshot.py`, which is missing on
  the personal Mac. Confirm whether it is still wanted and recover it if so.

Do not replace these with guessed implementations; the work-machine copies
are the source to review. The Gerber and old AeroSpace centre-window shortcuts
remain configured but need their missing scripts on this Mac; Dinky's
centre-window shortcut is commented out until the script is recovered and adapted.

## Keeping this repository current

Edit linked files normally, review `git diff`, then commit and push the changes
you want to keep. On another Mac, pulling updates linked files immediately;
reload the shell or relevant app as needed. Document new dependencies and links
here when adding a component.

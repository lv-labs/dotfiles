#!/usr/bin/python3
"""Open Finder, Ghostty, or VS Code at the current app's folder via Tuna."""

import argparse
from pathlib import Path
import subprocess
import sys

APP_IDS = {
    'finder': 'com.apple.finder',
    'ghostty': 'com.mitchellh.ghostty',
    'vscode': 'com.microsoft.VSCode',
}
TASK_KEYS = {'finder': 'f', 'ghostty': 'g', 'vscode': 'c'}

# Wait for Tuna to dismiss so the source app, not the launcher, is inspected.
SOURCE_SCRIPT = '''
on run argv
set taskKey to item 1 of argv
tell application "System Events"
    repeat 60 times
        set sourceID to bundle identifier of first application process whose frontmost is true
        if sourceID is not "com.brnbw.Tuna" then exit repeat
        delay 0.05
    end repeat
end tell
if sourceID is "com.microsoft.VSCode" then
    tell application "System Events"
        keystroke taskKey using {command down, control down, option down}
    end tell
    return "vscode"
else if sourceID is "com.mitchellh.ghostty" then
    tell application "Ghostty"
        if (count of windows) is 0 then error "Open a Ghostty terminal first."
        set term to focused terminal of selected tab of front window
        set folderPath to working directory of term
    end tell
    if folderPath is "" then error "Ghostty has not reported a working directory yet."
    return "folder:" & folderPath
else if sourceID is "com.apple.finder" then
    tell application "Finder"
        if (count of Finder windows) is 0 then error "Open a Finder folder first."
        try
            set folderPath to POSIX path of (target of front Finder window as alias)
        on error
            error "Choose a regular folder in Finder first."
        end try
    end tell
    return "folder:" & folderPath
else
    error "Use this command from Finder, Ghostty, or a VS Code project."
end if
end run
'''

OPEN_SCRIPT = '''
on run argv
    set destination to item 1 of argv
    set folderPath to item 2 of argv
    if destination is "finder" then
        tell application "Finder"
            make new Finder window to (POSIX file folderPath)
            activate
        end tell
    else if destination is "ghostty" then
        tell application "Ghostty"
            set cfg to new surface configuration
            set initial working directory of cfg to folderPath
            new window with configuration cfg
            activate
        end tell
    end if
end run
'''


def apple(script, *args):
    result = subprocess.run(
        ['/usr/bin/osascript', '-e', script, *args],
        capture_output=True, text=True, timeout=15,
    )
    if result.returncode:
        raise RuntimeError(result.stderr.strip() or 'Could not read the current folder.')
    return result.stdout.rstrip('\n')


def open_folder(destination, folder):
    folder = str(Path(folder).expanduser())
    if not Path(folder).is_dir():
        raise RuntimeError('The current folder is not available locally: ' + folder)
    from current_workspace import main as run_on_workspace
    if destination == 'vscode':
        code = Path('/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code')
        if not code.is_file():
            raise RuntimeError('VS Code was not found in /Applications.')
        command = [str(code), '--new-window', folder]
    else:
        command = ['/usr/bin/osascript', '-e', OPEN_SCRIPT, destination, folder]
    return run_on_workspace([
        '--app-id', APP_IDS[destination], '--', *command,
    ])


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('destination', choices=APP_IDS)
    parser.add_argument('--folder', help='Explicit project folder supplied by a VS Code task')
    args = parser.parse_args(argv)
    try:
        if args.folder is not None:
            return open_folder(args.destination, args.folder)
        source = apple(SOURCE_SCRIPT, TASK_KEYS[args.destination])
        if source == 'vscode':
            # VS Code resolves ${workspaceFolder}; do not guess from a window title.
            return 0
        if not source.startswith('folder:'):
            raise RuntimeError('Could not determine the current folder.')
        return open_folder(args.destination, source[len('folder:'):])
    except (RuntimeError, OSError, subprocess.TimeoutExpired) as error:
        print('Tuna: ' + str(error), file=sys.stderr)
        return 1


if __name__ == '__main__':
    sys.exit(main())

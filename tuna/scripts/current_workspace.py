#!/usr/bin/python3
"""Run a Tuna command and keep its new window on the current workspace."""

import argparse
import shutil
import subprocess
import sys
import time


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--app-id', required=True)
    parser.add_argument('--reuse', action='store_true')
    parser.add_argument('command', nargs=argparse.REMAINDER)
    args = parser.parse_args(argv)
    command = args.command
    if command[:1] == ['--']:
        command = command[1:]
    if not command:
        parser.error('a command is required after --')

    manager = None

    def query(*arguments):
        if not manager:
            return None
        try:
            result = subprocess.run(
                [manager, *arguments], capture_output=True, text=True, timeout=3
            )
        except (OSError, subprocess.TimeoutExpired):
            return None
        return result.stdout.strip() if result.returncode == 0 else None

    def windows():
        output = query('list-windows', '--monitor', 'all', '--app-bundle-id', args.app_id,
                       '--format', '%{window-id}')
        return set(output.splitlines()) if output else set()

    # Prefer a running Dinky, retaining AeroSpace support on the other Mac.
    workspace = None
    using_dinky = False
    for name, paths in (
        ('dinky', ('/Applications/dinky.app/Contents/MacOS/dinky',
                   '/opt/homebrew/bin/dinky', '/usr/local/bin/dinky')),
        ('aerospace', ('/opt/homebrew/bin/aerospace', '/usr/local/bin/aerospace')),
    ):
        manager = shutil.which(name)
        if not manager:
            manager = next((path for path in paths if shutil.which(path)), None)
        workspace = query('list-workspaces', '--focused')
        if workspace:
            using_dinky = name == 'dinky'
            break

    def focus(window):
        if using_dinky:
            # Dinky has no focus --window-id; --follow also focuses a window
            # already on the destination workspace.
            query('move-window-to-workspace', workspace, '--window-id', window, '--follow')
        else:
            query('focus', '--window-id', window)

    before = windows() if workspace else set()
    if workspace and args.reuse:
        existing = query('list-windows', '--workspace', workspace,
                         '--app-bundle-id', args.app_id, '--format', '%{window-id}')
        if existing:
            focus(existing.splitlines()[0])
            return 0

    result = subprocess.run(command)
    if result.returncode or not workspace:
        return result.returncode

    deadline = time.monotonic() + 10
    while time.monotonic() < deadline:
        candidates = windows() - before
        if candidates:
            for window in sorted(candidates):
                query('move-window-to-workspace' if using_dinky else 'move-node-to-workspace',
                      '--window-id', window, workspace)
            focus(sorted(candidates)[0])
            return 0
        time.sleep(0.1)
    print('Tuna: no new window detected; command completed.', file=sys.stderr)
    return 0


if __name__ == '__main__':
    sys.exit(main())

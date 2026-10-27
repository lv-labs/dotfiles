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

    aerospace = shutil.which('aerospace')
    if not aerospace:
        for path in ('/opt/homebrew/bin/aerospace', '/usr/local/bin/aerospace'):
            if shutil.which(path):
                aerospace = path
                break

    def query(*arguments):
        if not aerospace:
            return None
        try:
            result = subprocess.run(
                [aerospace, *arguments], capture_output=True, text=True, timeout=3
            )
        except (OSError, subprocess.TimeoutExpired):
            return None
        return result.stdout.strip() if result.returncode == 0 else None

    def windows():
        output = query('list-windows', '--monitor', 'all', '--app-bundle-id', args.app_id,
                       '--format', '%{window-id}')
        return set(output.splitlines()) if output else set()

    workspace = query('list-workspaces', '--focused')
    before = windows() if workspace else set()
    if workspace and args.reuse:
        existing = query('list-windows', '--workspace', workspace,
                         '--app-bundle-id', args.app_id, '--format', '%{window-id}')
        if existing:
            query('focus', '--window-id', existing.splitlines()[0])
            return 0

    result = subprocess.run(command)
    if result.returncode or not workspace:
        return result.returncode

    deadline = time.monotonic() + 10
    while time.monotonic() < deadline:
        candidates = windows() - before
        if candidates:
            for window in sorted(candidates):
                query('move-node-to-workspace', '--window-id', window, workspace)
            query('focus', '--window-id', sorted(candidates)[0])
            return 0
        time.sleep(0.1)
    print('Tuna: no new window detected; command completed.', file=sys.stderr)
    return 0


if __name__ == '__main__':
    sys.exit(main())

#!/usr/bin/python3
"""Focus the next connected Dinky display, wrapping back to the first."""

import shutil
import subprocess
import sys


def main():
    dinky = shutil.which('dinky') or '/Applications/dinky.app/Contents/MacOS/dinky'

    def query(*args):
        return subprocess.check_output([dinky, *args], text=True, timeout=3).strip()

    displays = query('list-monitors', '--format', '%{monitor-id}').splitlines()
    if len(displays) < 2:
        return 0
    focused = query('list-monitors', '--focused', '--format', '%{monitor-id}')
    if focused not in displays:
        raise ValueError('focused display is absent from the connected displays')
    target = displays[(displays.index(focused) + 1) % len(displays)]
    subprocess.run([dinky, 'focus-monitor', target], check=True, timeout=3)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print(f'focus-next-display: {error}', file=sys.stderr)
        sys.exit(1)

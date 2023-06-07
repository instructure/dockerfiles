#!/usr/bin/env python3
import subprocess
from pathlib import Path

import requests
from ruamel.yaml import YAML


def main():
    update_golang()


def update_golang():
    new_golang_versions = requests.get("https://go.dev/dl/?mode=json").json()

    yaml = YAML()
    yaml.preserve_quotes = True
    yaml.sequence_dash_offset = 2

    manifest_file = Path(__file__).parent.joinpath('manifest.yml').absolute()
    with open(manifest_file) as f:
        manifest = yaml.load(f)

    for v in new_golang_versions:
        files = v['files']
        candidates = [f for f in files if f['os']
                      == 'linux' and f['arch'] == 'amd64']
        if len(candidates) != 1:
            msg = f"Expected 1 candidate, got {len(candidates)}: {candidates}"
            raise Exception(msg)

        go_file = candidates[0]

        full_version = v['version'][2:]
        minor_version = full_version.rsplit('.', 1)[0]

        manifest['golang']['versions'][minor_version] = {
            'full_version': full_version,
            'package_sha': go_file['sha256']
        }

    with open(manifest_file, 'w') as f:
        yaml.dump(manifest, f)

    p = subprocess.Popen(['rake', 'generate:golang'])
    p.communicate()
    rc = p.returncode
    if rc != 0:
        msg = f"Failed to update golang: 'rake generate:golang' returned {rc}"
        raise Exception(msg)


if __name__ == '__main__':
    main()

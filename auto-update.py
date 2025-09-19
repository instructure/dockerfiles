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

        # Find AMD64 package
        amd64_candidates = [f for f in files if f['os'] == 'linux' and f['arch'] == 'amd64']
        if len(amd64_candidates) != 1:
            msg = f"Expected 1 AMD64 candidate, got {len(amd64_candidates)}: {amd64_candidates}"
            raise Exception(msg)

        # Find ARM64 package
        arm64_candidates = [f for f in files if f['os'] == 'linux' and f['arch'] == 'arm64']
        if len(arm64_candidates) != 1:
            msg = f"Expected 1 ARM64 candidate, got {len(arm64_candidates)}: {arm64_candidates}"
            raise Exception(msg)

        amd64_file = amd64_candidates[0]
        arm64_file = arm64_candidates[0]

        full_version = v['version'][2:]
        minor_version = full_version.rsplit('.', 1)[0]

        manifest['golang']['versions'][minor_version] = {
            'full_version': full_version,
            'package_sha': amd64_file['sha256'],
            'package_sha_arm64': arm64_file['sha256'],
            'multiarch': True
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

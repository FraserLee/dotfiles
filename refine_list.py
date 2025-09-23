
#!/usr/bin/env -S uv run --script
# /// script
# requires-python = "~=3.12"
# dependencies = [ "tomlkit" ]
# ///

import subprocess
import tomlkit
from typing import Optional

def run(cmd: str) -> str:
    print('running', cmd)
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.stdout.strip()

def get_brew_description(package_name: str) -> Optional[str]:
    output = run(f"brew info {package_name}")
    lines = output.split('\n')

    for i, line in enumerate(lines[:-1]):
        if line.strip() == "==> Description":
            return lines[i + 1].strip()

    # Fall back to just taking the second line
    if len(lines) >= 2:
        second_line = lines[1].strip()
        return second_line

    return None

def get_npm_description(package_name: str) -> Optional[str]:

    pkg_name = ' '.join([w for w in package_name.split() if not w == '-g'])
    info = run(f"npm info {pkg_name}")
    lines = info.split('\n')

    if len(lines) >= 2:
        desc = lines[1].strip()
        return desc

    return None

with open('install_list.toml', 'r') as f:
    config = tomlkit.load(f)

for package_name, details in config.items():
    if 'description' in details:
        print(f"Skipping {package_name} - description already exists")
        continue

    description = None

    install_cmd = details.get('install', '')
    if isinstance(install_cmd, list):
        install_cmd = install_cmd[0]

    if install_cmd.startswith('brew install'):
        description = get_brew_description(install_cmd[13:])
    elif install_cmd.startswith('npm install'):
        description = get_npm_description(install_cmd[12:])

    if description:
        details['description'] = description
        print(f"Added description for {package_name}: {description}")
    else:
        print(f"Couldn't find description for {package_name}")

with open('install_list.toml', 'w') as f:
    tomlkit.dump(config, f)

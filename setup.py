#!/usr/bin/env python3

import tomllib
import subprocess
from typing import Dict, List, Any

with open('install_list.toml', 'rb') as f:
    config = tomllib.load(f)

def run(cmd: str) -> bool:
    try:
        result = subprocess.run(cmd, shell=True, text=True)
        return result.returncode == 0
    except Exception:
        return False

installed = {}
def check_installed(package: str) -> bool:
    if package not in installed:
        installed[package] = run(config[package]['test'])
    return installed[package]

queue = list(config.keys())

while queue:
    package = queue.pop(0)
    details = config[package]
    print(f"Checking {package}...")

    # Check prerequisites
    prereqs_met = True
    prereqs = details.get('prereqs', [])
    for prereq in prereqs:
        if prereq in config:
            if not check_installed(prereq):
                print(f">   Prerequisite '{prereq}' not satisfied")
                prereqs_met = False
                break
        else:
            if not run(f"which {prereq}"):
                print(f">   Prerequisite '{prereq}' not found")
                prereqs_met = False
                break

    if not prereqs_met:
        print(f">   Skipping {package} due to unmet prerequisites, will retry later")
        queue.append(package)
        continue

    # Test if already installed
    if check_installed(package):
        print(f">   {package} already installed")
    else:
        print(f">   Installing {package}...")

        install_cmds = details['install']
        if isinstance(install_cmds, str):
            install_cmds = [install_cmds]

        total_cmds = len(install_cmds)
        for i, cmd in enumerate(install_cmds, 1):
            if total_cmds > 1:
                print(f">   Running command {i}/{total_cmds}: {cmd}")
            else:
                print(f">   Running command: {cmd}")
            run(cmd)

            if input("continue? [Y / n]").lower().strip() == 'n':
                break
        else:
            # Only mark as installed if we completed all commands
            installed[package] = True



import os

for package in sorted(os.popen('brew list --cask').read().split()):
    print(f'brew install --cask {package}')

# brew packages (leaves only)
for package in sorted(os.popen('brew leaves').read().split()):
    print(f'brew install {package}')

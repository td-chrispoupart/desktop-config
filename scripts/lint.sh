#!/bin/sh

# YAML
yamllint .

# Bash
shellcheck scripts/*.sh

# Markdown
# Ignore CHANGELOG.md as it has duplicate headings by design
# TODO: markdownlint is a node package. Install it once we get node/npm installed.
# markdownlint README.md AUTHORS.md
# markdownlint docs/*.md

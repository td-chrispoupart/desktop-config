
.PHONY: help

# Shell that make should use
# Make changes to path persistent
# https://stackoverflow.com/a/13468229/13577666
SHELL := /bin/bash
PATH := $(PATH)
UNAME_S := $(shell uname -s)

HOSTNAME = $(shell hostname)

# Source for conditional: https://stackoverflow.com/a/2741747/13577666
ifneq (,$(findstring $(LOCAL_BIN),$(PATH)))
	# Found: all set; do nothing, $(LOCAL_BIN) is on PATH
	PATH := $(PATH);
else
	# Not found: adding $(LOCAL_BIN) to PATH for this shell session
export PATH := $(LOCAL_BIN):$(PATH); @echo $(PATH)
endif

VARIABLES = '{"ansible_user": "$(shell whoami)"}'

# Main Ansible Playbook Command (prompts for password)
PLAYBOOK = site.yml
ANSIBLE_PLAYBOOK = ansible-playbook $(PLAYBOOK) -v -e $(VARIABLES)

# If your desktop environment is configured to use biometrics for sudo
# escalation, --ask-become-pass will not work. In such a case, run "sudo -l"
# before running your playbook, and add "ANSIBLE = sudo -l &&
# $(ANSIBLE_PLAYBOOK)" to make.env
ANSIBLE = $(ANSIBLE_PLAYBOOK) --ask-become-pass

# # - to suppress if it doesn't exist
-include make.env

# $(warning ANSIBLE is $(ANSIBLE))

help:
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
# adds anything that has a double # comment to the phony help list
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ".:*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

bootstrap-before-install:
bootstrap-before-install:
ifeq ($(UNAME_S), Linux)
	@bash scripts/before_install_dnf_dependencies.sh
else ifeq ($(UNAME_S), Darwin)
	@bash scripts/before_install_brew_dependencies.sh
else
	@echo "Your OS is currently unsupported. Contributions are welcome!"
endif

bootstrap-install:
bootstrap-install:
	python3 -m pip install -r ./requirements.txt --user --upgrade

bootstrap: bootstrap-before-install bootstrap-install
bootstrap: ## Installs dependencies needed to run playbook

bootstrap-check:
bootstrap-check: ## Check that PATH and requirements are correct
	@ansible --version | grep "python version"

terminal: ## Initializes any machine
terminal:
	@$(ANSIBLE) --tags="terminal"

desktop: ## Adds extras for an OS with a GUI
desktop:
	@$(ANSIBLE) --tags="desktop"

all: ## Does most eveything with Ansible and Make targets
all: bootstrap-before-install bootstrap bootstrap-check install

lint:  ## Lint the repo
lint:
	bash scripts/lint.sh

debug: ## Debug Ansible Vars
debug:
	@$(ANSIBLE) --tags="debug"

codium:
codium: ## Install VS Codium and extensions
	@$(ANSIBLE) --tags="codium"

terraform:
terraform: ## TODO: Install HCP Terraform
	@$(ANSIBLE) --tags="terraform"

fish:
fish: ## Install Fish and oh-my-fish
	@$(ANSIBLE) --tags="fish"

fonts:
fonts: ## Install Nerd Font
	@$(ANSIBLE) --tags="fonts"

podman:
podman: ## TODO: Install Podman and Podman-Compose
	@$(ANSIBLE) --tags="podman"

peek:
peek: ## TODO: Install Peek (GIF Screen Recorder) using a Flatpak
	@$(ANSIBLE) --tags="flatpak" -e '{"flatpak_applications": ["com.uploadedlobster.peek"]}'

pdf-slicer:
pdf-slicer: ## TODO: Install PDFSlicer (split and combine PDFs) using a Flatpak
	@$(ANSIBLE) --tags="flatpak" -e '{"flatpak_applications": ["com.github.junrrein.PDFSlicer"]}'

timeshift:
timeshift: ## TODO: Install Timeshift (Backup Utility)
	@$(ANSIBLE) --tags="timeshift"

gitlab-cli:
gitlab-cli: ## TODO: Install GitLab CLI package, directly from Fedora YUM repo
	@$(ANSIBLE) --tags="gitlab_cli"

stacer:
stacer: ## TODO: Install Stacer (Material System Utility)
	@$(ANSIBLE) --tags="stacer"

cherrytree:
cherrytree: ## TODO: Install Cherrytree, using Flatpak
	@$(ANSIBLE) --tags="flatpak" -e '{"flatpak_applications": ["com.giuspen.cherrytree"]}'

nodejs:
nodejs: ## TODO: Install Nodejs, NPM, and Yarn
	# This role takes care of $$PATH
	@$(ANSIBLE) --tags="nodejs"

discord:
discord: ## Install Discord, using Flatpak
	@$(ANSIBLE) --tags="flatpak" -e '{"flatpak_applications": ["com.discordapp.Discord"]}'

mattermost:
mattermost: ## Install Mattermost, using Flatpak
	@$(ANSIBLE) --tags="flatpak" -e '{"flatpak_applications": ["com.mattermost.Desktop"]}'

msteams:
msteams: ## Install Microsft Teams, using Flatpak
	@$(ANSIBLE) --tags="flatpak" -e '{"flatpak_applications": ["com.microsoft.Teams"]}'

signal:
signal: ## Install Signal, using Flatpak
	@$(ANSIBLE) --tags="flatpak" -e '{"flatpak_applications": ["org.signal.Signal"]}'

slack:
slack: ## Install Slack, using Flatpak
	@$(ANSIBLE) --tags="flatpak" -e '{"flatpak_applications": ["com.slack.Slack"]}'

webex:
webex: ## Install WebEx Desktop Client via RPM
	@$(ANSIBLE) --tags="webex"

zoom:
zoom: ## Install Zoom, using Flatpak
	@$(ANSIBLE) --tags="flatpak" -e '{"flatpak_applications": ["us.zoom.Zoom"]}'

chat: discord mattermost msteams signal slack webex zoom
chat: ## Install all chat software.

git:
git: ## Install and configure git
	@$(ANSIBLE) --tags="git"

untagged:
untagged: ## Run playbook with no tags
	@$(ANSIBLE)

# Running the playbook untagged will skip Flatpack applications, so we must call
# them separately here.
install: untagged chat
install: ## Install everything

.DEFAULT_GOAL := help

# Workstation Standards: A Programatic Approach Getting Up and Running

## Quickstart

> :warning: Currently this playbook is written and tested on Fedora 35. Attempts
> have been made to make it work with other RedHat-based systems, and it should
> not be difficult to port roles to other Linux distributions. MRs to this end
> are welcome!

1. Clone this repository and CD into it in a terminal
1. Create a `config.yml` for any local customizations
1. `python install -r requirements.txt --user`
1. `ansible-playbook --ask-become site.yml`

## Customizations

You can override any specific variables by creating a file in the root of the
project called `config.yml`. Simply use the same syntax as `default.config.yml`
for any variables you wish to override. By default, this file will not be
tracked bit git.

## Ansible Tags and Variables

### Tags

| Tag Name    | Description |
| :---------: | ----------- |
| browser     | Ensures additional web browsers are present and configured. |
| codium      | Ensures that VSCodium is installed and configured. |
| desktop     | Ensures all desktop apps are installed and configured. |
| development | Ensures all development-related apps are installed and configured |
| fonts       | Ensures that custom fonts are installed and configured. |
| gaming      | Ensures that gaming-related apps are installed, such as Steam. |
| git         | Ensures that git is properly configured with our defaults. |
| gnome       | Ensures that GNOME-related customizations are done. |
| gpg         | Ensures that gpg is installed and configured. Also runs `gpg-agent` instead of `ssh-agent`. |
| hashicorp   | Ensures that HashiCorp-related apps are installed and configured. |
| nodejs      | Ensures that nodejs is installed and configured. |
| terminal    | Ensures that terminal apps are installed and configured. |
| vm          | Ensures that our virtualization software is installed and configured. Currently that means VirtualBox. |
| vpn         | Ensures that `openconnect-sso` is installed. (Currently does not seem to work with Fedora 35) |
| webex       | Ensures that the WebEx Client is installed. |

### Variables

Roles with variables will have the variables exposed in the `defauls/main.yml`
file under the role directory.

For variables that are more likely to need editing, they have been exposed in
the `default.config.yml` file.

## Notes

For ease of logic, all applications currently installed with `flatpak` are
lumped together into a single list. This may be refactored in the future.

Ditto with npm global packages.

## Depricated

### Makefile

For a list of available `make` options, type `make help`.

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

asdf/test: ## Test HEAD of current asdf plugin
> asdf plugin-test $(PLUGIN_NAME) . --asdf-tool-version latest

shell/fmt: ## Format bash code
> shfmt -l -w .

asdf/install: ## install asdf for bash
> @if ! command -v asdf &> /dev/null
> @then
>     echo "Installing ASDF for Bash"
>     @git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
>     @echo -e '\nsource $$HOME/.asdf/asdf.sh' >> ~/.bashrc
>     @source $$HOME/.asdf/asdf.sh
> @fi

asdf/install-plugins: ## install all tools needed with the asdf version manager
> @cut -d' ' -f1 .tool-versions|xargs -i asdf plugin add {} || true

asdf/install-tools: asdf/install-plugins ## install all tools needed with the asdf version manager
> @asdf install

help:
> @egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
.PHONY: test fmt install-tools install-asdf
.DEFAULT_GOAL := help

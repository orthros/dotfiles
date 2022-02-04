.PHONY: all
all: dotfiles ## Intalls the dotfiles

.PHONY: dotfiles
dotfiles:  ## Installs the dotfile
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -maxdepth 1 -name ".*" -not -name ".gitignore" -not -name ".travis.yml" -not -name ".git" -not -name ".*.swp" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done; \
	for file in $(shell find $(CURDIR)/config ! -path $(CURDIR)/config -type d); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/.config/$$f; \
	done; \
	gpg --list-keys || true;
	ln -sfn $(CURDIR)/.gnupg/gpg.conf $(HOME)/.gnupg/gpg.conf;
	if [ "$(shell uname -s)" = "Darwin" ]; then \
    	ln -sfn $(CURDIR)/.gnupg/gpg-agent-mac.conf $(HOME)/.gnupg/gpg-agent.conf; \
	else \
		ln -sfn $(CURDIR)/.gnupg/gpg-agent-unix.conf $(HOME)/.gnupg/gpg-agent.conf; \
	fi;

.PHONY: test
test: shellcheck ## Runs all the tests on the files in the repository.


# if this session isn't interactive, then we don't want to allocate a
# TTY, which would fail, but if it is interactive, we do want to attach
# so that the user can send e.g. ^C through.
INTERACTIVE := $(shell [ -t 0 ] && echo 1 || echo 0)
ifeq ($(INTERACTIVE), 1)
	DOCKER_FLAGS += -t
endif

.PHONY: shellcheck
shellcheck: ## Runs the shellcheck tests on the scripts.
	docker run --rm -i $(DOCKER_FLAGS) \
		--name df-shellcheck \
		-v $(CURDIR):/usr/src:ro \
		--workdir /usr/src \
		r.j3ss.co/shellcheck ./test.sh

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

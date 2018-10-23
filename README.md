# dotfiles
The settings for the things I like

## What the heck is `.darwin`?

I found when using OSX and [Homebrew](https://brew.sh), I was installing brew to a non standard directory (`$HOME/.homebrew`). 
This meant my shell would not pick up the executeables I had installed via `brew install` (which are numerous).

Rather than try to continue to hack it, I added a `.darwin` file to be sourced first (and therefore fix the path).

The `.darwin` file is in [orthros/brewfiles](https://github.com/orthros/brewfiles)
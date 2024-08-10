# What is this?
This is an opinionated [Nix](https://nixos.org/) [flake](https://nixos.wiki/wiki/Flakes) for getting started with the [Guile](https://www.gnu.org/software/guile/) programming language.

The first time you use this subshell these tools will be downloaded and cached. Once you exit the subshell they will no longer be on your path. The second run is instantaneous.

# Installation
1. Install the Nix package manager by selecting your OS in the [official guide](https://nixos.org/download.html). Don't forget to reopen the terminal!

1. Enable the flakes feature:

    ```bash
    mkdir -p ~/.config/nix
    echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
    ```
    If the Nix installation is in multi-user mode, don’t forget to restart the `nix-daemon` by running:
    ```bash
    sudo systemctl restart nix-daemon
    ```
# Alternative unofficial installation
Taken from https://zero-to-nix.com/start/install
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

# Usage
Use the default subshell (there is **NO** need to clone this repo) by running:
```bash
nix develop github:behaghel/guile-seed
```
For [direnv](https://direnv.net/)/[nix-direnv](https://github.com/nix-community/nix-direnv) users put the following into your `.envrc`:
```bash
use flake github:behaghel/guile-seed
```
Here is how you can see the metadata of the flake:
```bash
nix flake metadata github:behaghel/guile-seed
```
And here is how you can see everything the flake has to offer:
```bash
nix flake show github:behaghel/guile-seed --all-systems
```
Here is a useful incantation to pretty print a filtered list of what's on the path:
```bash
echo -e ${buildInputs// /\\n} | cut -d - -f 2- | sort
```
And here is another one that also shows the locations:
```bash
echo -e ${buildInputs// /\\n} | sort -t- -k2,2 -k3,3
```
And here is yet another one that shows **everything** Nix put on the path:
```bash
echo $PATH | sed 's/:/\n/g' | grep /nix/store | sort --unique -t- -k2,2 -k3,3
```
Just like any other subshell this one can be exited by typing `exit` or pressing `Ctrl+D`.

# Guile first steps
Now that you have a working dev environment you can create your first guile project like this:

Basic project using my nix template:
```bash
nix flake new --template github:behaghel/guile-seed my-project
```
Now `cd` into your newly created project and launch `guile`.

If you have a working `guix` installation already, you can use [guile-hall](https://gitlab.com/a-sassmannshausen/guile-hall) for more serious project management and publishing:
```bash
which guile       # record output for later
hall init --author "Jane Doe" frobnigator --execute
cd frobnigator
hall build -x     # creates the build infra
hall dist -xf     # creates file guix.scm
guix shell -Df guix.scm # to enter a development shell as setup by hall for guix
# Next command is necessary as nix guile and guix guile may not be aligned
export GUILE=/path/to/nix/guile # see first command output
autoreconf -vif && ./configure  # somehow guix shell isn't enough
make check        # to run the tests
```


## Learning Guile

- [The Little
  Schemer](https://mitpress.mit.edu/9780262560993/the-little-schemer/)
- [Structure and Interpretation of Computer Programs](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/index.html)
- [Simply Scheme](https://people.eecs.berkeley.edu/~bh/ss-toc2.html)
- [The Scheme Programming Language](https://scheme.com/tspl4/)
- `info r5rs` (TODO) and `info guile`

Going further:
- [Software Design for Flexibility](https://mitpress.mit.edu/9780262045490/software-design-for-flexibility/)

```bash
TODO: nix template
```

Welcome to Guile!

PS

I recommend coding in Guile using [Emacs](https://www.gnu.org/software/emacs/) with [Geiser](https://www.nongnu.org/geiser/) and [SmartParens](https://github.com/Fuco1/smartparens).

This flake was tested on Ubuntu-22.04 LTS, but it should work on Macs as well. I will set up CI eventually to test on them. Please report issues until then. Thank you!

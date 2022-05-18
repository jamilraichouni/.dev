# .dev

## Setup

Ensure that `curl` and `git` are installed.

```sh
[[ -d ~/My\ Drive ]] && [[ ! -L ~/mydrive ]] && ln -s ~/My\ Drive ~/mydrive
export DEVHOME=...  # e. g. export DEVHOME=~/mydrive/.dev
git clone git@github.com:jamilraichouni/.dev.git $DEVHOME
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $DEVHOME/ohmyzsh/custom/themes/powerlevel10k
rm -rf $DEVHOME/ohmyzsh/custom/themes/powerlevel10k/.git
```

## How `oh-my-zsh` has been installed

```sh
git clone https://github.com/ohmyzsh/ohmyzsh $DEVHOME/ohmyzsh
rm -rf $DEVHOME/ohmyzsh/.git
```

whereby `DEVHOME` might be `~/My\ Drive`

## nvim

`git clone git@github.com:jamilraichouni/nvim-config.git ~/.config/nvim`

## Packer

```shell
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

## Fonts

see:
<https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts>

## fzf

```shell
git clone --depth 1 https://github.com/junegunn/fzf.git ~/opt/fzf
~/opt/fzf/install
```

## `rg`

Needed by Telescope's grep / search etc.

```shell
brew install rg
```

## Todo

1. nvim and language servers etc. in Docker container (also pushed to registry)

1. Learn use of `vim-fugitive`

1. ipython colors for tracebacks of raised exceptions (just try `import dummy`)

1. Multiple filter lines
   use case: count no of build targets in builddesc.yml

1. light green background for current debugger line

1. Snippets (translate VSCode -> UltiSnips)

1. Snippet or JarVim command to add a new working times entry

1. Document in tagged .txt help files (JarVim plugin)
   -> to have everything at hand

## Recipes

### Filter lines into # buffer

`:vimgrep pattern %`
`:cwindow`

## Reasons for NeoVIM

- Treesitter support !!
- Really nice completion engine nvim-cmp that uses the following important sources:

  - LSP client,
  - UltiSnips,
  - Buffer

- Builtin LSP client in NVIM instead of A.L.E.
- Real Python plugin development in NVIM
- Lua scripting instead of VimScript only
- Bigger community, hence possibly more cool plugins etc.

## Reasons for VIM

- vimspector with nice toolbar
- Nearly always available on Unix machines
- Maybe better tested (stability)

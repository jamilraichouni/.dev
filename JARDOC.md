# JAR Documentation

## Contents

- [Development](#development)
  - [Environment setup](#environment-setup)
    - [Fonts](#fonts)
    - [Tools](#tools)
      - [`Neovim`](#neovim)
      - [`fzf`](#fzf)

## Development

### Environment setup

```zsh
curl -fsSL https://raw.githubusercontent.com/jamilraichouni/.dev/main/install_macos.zsh | zsh
```

**How `oh-my-zsh` had been installed**

```sh
git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh $DEVHOME/ohmyzsh
rm -rf $DEVHOME/ohmyzsh/.git
```

**How `powerlevel10k` had been installed**

```sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $DEVHOME/ohmyzsh/custom/themes/powerlevel10k
rm -rf $DEVHOME/ohmyzsh/custom/themes/powerlevel10k/.git
```

#### Fonts

see:
<https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts>

#### Tools

##### `Neovim`

###### Recipe: Filter lines into # buffer

```vim
:vimgrep PATTERN %
:cwindow
```

###### Plugin management with `packer`

```shell
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

##### `fzf`

<https://github.com/junegunn/fzf>

```shell
git clone --depth 1 https://github.com/junegunn/fzf.git ~/opt/fzf
~/opt/fzf/install
```

## Todo

Consider:

```text
curl is keg-only, which means it was not symlinked into /usr/local,
because macOS already provides this software and installing another version in
parallel can cause all kinds of trouble.

If you need to have curl first in your PATH, run:
  echo 'export PATH="/usr/local/opt/curl/bin:$PATH"' >> ~/.zshrc

For compilers to find curl you may need to set:
  export LDFLAGS="-L/usr/local/opt/curl/lib"
  export CPPFLAGS="-I/usr/local/opt/curl/include"

For pkg-config to find curl you may need to set:
  export PKG_CONFIG_PATH="/usr/local/opt/curl/lib/pkgconfig"


zsh completions have been installed to:
  /usr/local/opt/curl/share/zsh/site-functions
```

1. Make install script in `.dev` repo that can be called like `curl github.../install.zsh -o install.zsh | zsh`

1. Consider `.vimrc` sourcing `init.vim` with `has('nvim')` etc.

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

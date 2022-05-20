# JAt Documentation

## Contents

- [Development](#development)
  - [Environment setup](#environment-setup)
    - [Fonts](#fonts)
    - [Tools](#tools)
      - [`Neovim`](#neovim)
      - [`IPython`](#ipython)
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

###### Recipe: Upper case inner word: ```gUiw```

###### Recipe: Lower case inner word: ```guiw```

###### Plugin management with `packer`

```shell
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

###### Reasons for Nvim

- Treesitter support !!
- Good working completion engine `nvim-cmp` that uses the following important sources:
  - LSP client,
  - UltiSnips,
  - Buffer,
  - File

- Builtin LSP client in Nvim instead of A.L.E.
- Real Python plugin development in Nvim
- Lua scripting instead of VimScript only
- Bigger community, hence possibly more cool plugins etc.

###### Reasons for VIM

- vimspector with nice toolbar
- Nearly always available on Unix machines
- Maybe better tested (stability)

##### `IPython`

###### Debug code with `ipdb` in `IPython`

```sh
pip install ipdb
export PYTHONBREAKPOINT=IPython.terminal.debugger.set_trace
```

**Variant 1:**

Manually put a `breakpoint()` statement in the code and run

```python
%run [-m] statement  # e. g.: %run -m mddocgen.jobgen builddesc.yml .
```

**Variant 2:**

```python
%run -d [-m] statement  # e. g.: %run -d -m mddocgen.jobgen.__main__ builddesc.yml .
```

This will stop on entry in line 1 of the module `__main__`.

##### `fzf`

<https://github.com/junegunn/fzf>

```shell
git clone --depth 1 https://github.com/junegunn/fzf.git ~/opt/fzf
~/opt/fzf/install
```

## Todo

- Advanced select, copy etc.

  Example:

  How to copy the quoted `Pmenu...` entries?

  ```vim
  call <sid>hi('Pmenu', s:cdPopupFront, s:cdPopupBack, 'none', {})
  call <sid>hi('PmenuSel', s:cdPopupFront, s:cdPopupHighlightBlue, 'none', {})
  call <sid>hi('PmenuSbar', {}, s:cdPopupHighlightGray, 'none', {})
  call <sid>hi('PmenuThumb', {}, s:cdPopupFront, 'none', {})
  ```


- ipython colors for tracebacks of raised exceptions (just try `import dummy`)

- Write Treesitter extension for KeepassXC entries

- Align cursor shapes in `kitty` and terminal buffer in `(n)vim`:
  Want to have a red blinking beam in insert mode of Nvim's terminal!

- Learn use of `netrw`

- Learn use of `vim-fugitive`

- Avoid macos cmd key for `kitty` keymaps

- Lint/ format `.toml` files:
  - <https://www.npmjs.com/package/eslint-plugin-toml>

- Snippets (translate VSCode -> UltiSnips)

- Turquise (#008787) background for current debugger line in `vimspector`

- Snippet or JarVim command to add a new working times entry

- Nvim and language servers etc. in Docker container (also pushed to registry)

- Consider:

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

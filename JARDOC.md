# JAR Documentation

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

###### Analyse shell command outputs

**Example: List symbolic links:**

```ipython
In [14]: items = !ls -la

In [15]: [i for i in items if i[0].startswith("l")]
Out[15]:
['lrwxr-xr-x     1 jamilraichouni  staff      38 May  6 07:49 .config -> /Users/jamilraichouni/My Drive/.config',
 'lrwxr-xr-x     1 jamilraichouni  staff      39 May 16 21:46 .gdbinit -> /Users/jamilraichouni/My Drive/.gdbinit',
 'lrwxr-xr-x     1 jamilraichouni  staff      41 May  6 13:59 .gitconfig -> /Users/jamilraichouni/My Drive/.gitconfig',
 'lrwxr-xr-x     1 jamilraichouni  staff      41 May  6 14:00 .gitignore -> /Users/jamilraichouni/My Drive/.gitignore',
 'lrwxr-xr-x     1 jamilraichouni  staff      37 May  7 10:12 .icons -> /Users/jamilraichouni/My Drive/.icons',
 'lrwxr-xr-x     1 jamilraichouni  staff      41 May 19 14:06 .ipython -> /Users/jamilraichouni/repos/.dev/.ipython',
 'lrwxr-xr-x     1 jamilraichouni  staff      41 May  6 13:58 .oh-my-zsh -> /Users/jamilraichouni/My Drive/.oh-my-zsh',
 'lrwxr-xr-x     1 jamilraichouni  staff      40 May  6 13:58 .p10k.zsh -> /Users/jamilraichouni/My Drive/.p10k.zsh',
 'lrwxr-xr-x     1 jamilraichouni  staff      39 May 19 22:09 .pdbrc -> /Users/jamilraichouni/repos/.dev/.pdbrc',
 'lrwxr-xr-x     1 jamilraichouni  staff      35 May  6 07:54 .ssh -> /Users/jamilraichouni/My Drive/.ssh',
 'lrwxr-xr-x     1 jamilraichouni  staff      39 May 18 15:38 .vimrc -> /Users/jamilraichouni/repos/.dev/.vimrc',
 'lrwxr-xr-x     1 jamilraichouni  staff      37 May  7 10:19 .zshrc -> /Users/jamilraichouni/My Drive/.zshrc',
 'lrwxr-xr-x     1 jamilraichouni  staff      11 May 12 12:22 DB -> My Drive/DB',
 'lrwxr-xr-x     1 jamilraichouni  staff      38 May  6 08:07 Desktop -> /Users/jamilraichouni/My Drive/Desktop',
 'lrwxr-xr-x     1 jamilraichouni  staff      40 May  8 12:24 Downloads -> /Users/jamilraichouni/My Drive/Downloads',
 'lrwx------     1 jamilraichouni  staff      20 May 20 20:19 Google Drive -> /Volumes/GoogleDrive',
 'lrwxr-xr-x     1 jamilraichouni  staff      12 May 12 12:22 JAR -> My Drive/JAR',
 'lrwxr-xr-x     1 jamilraichouni  staff      12 May 11 07:05 bak -> My Drive/bak',
 'lrwxr-xr-x     1 jamilraichouni  staff      30 May 16 22:01 mydrive -> /Users/jamilraichouni/My Drive',
 'lrwxr-xr-x     1 jamilraichouni  staff      34 May  6 08:12 tmp -> /Users/jamilraichouni/My Drive/tmp']
```

##### `fzf`

<https://github.com/junegunn/fzf>

```shell
git clone --depth 1 https://github.com/junegunn/fzf.git ~/opt/fzf
~/opt/fzf/install
```

## Todo

- Undercurled line instead of underlines for lsp diagnostics

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

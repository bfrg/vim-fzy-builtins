# vim-fzy-builtins

Fuzzy-select buffers, files in `arglist`, tags, help tags, `oldfiles`, and file
marks using the fuzzy-searcher [fzy][fzy].

**Note:** This plugin requires [vim-fzy][vim-fzy]. See
[installation](#installation) instructions below.

<dl>
  <p align="center">
  <a href="https://asciinema.org/a/268637">
    <img src="https://asciinema.org/a/268637.png" width="480">
  </a>
  </p>
</dl>


## Usage

| Command       | Description                                                             |
|---------------|-------------------------------------------------------------------------|
| `:Buffer`     | List **buffers**, edit selected buffer in current window.               |
| `:SBuffer`\*  | Same as `:Buffer`, but edit the selected buffer in a new split.         |
| `:Args`       | List **global arglist**, edit selected file in current window.          |
| `:SArgs`\*    | Same as `:Args`, but edit the selected file in a new split.             |
| `:Largs`      | List **local arglist**, edit selected file in current window.           |
| `:SLargs`\*   | Same as `:Largs`, but edit the selected file in a new split.            |
| `:MRUedit`    | List **Most-Recently-Used** files, edit selected file in current window.|
| `:MRUsplit`\* | Same as `:MRUedit`, but edit the selected file in a new split.          |
| `:Tjump`      | List **tags**, jump to selected tag in current window.                  |
| `:STjump`\*   | Same as `:Tjump`, but jump to the selected tag in a new split.          |
| `:Marks`      | List **marks**, jump to the selected mark in the current window.        |
| `:SMarks`\*   | Same as `:Marks`, but jump to the selected mark in a new split.         |
| `:Help`\*     | List **help tags**, open help page with the selected tag in new split.  |


\*Commands that split the current window accept a **command modifier**. For
example, to open the help page with the selected tag in a new vertical split,
run `:vertical Help`. `:tab MRUsplit` will open the selected file in a new tab.

For a full list of supported command modifiers, see `:help fzy-:SBuffer`.


## Configuration

Options can be passed to `fzy` through the variable `g:fzy`. Currently, the
following entries are supported:

| Entry             | Description                                                                       | Default |
| ----------------- | --------------------------------------------------------------------------------- | ------- |
| `g:fzy.lines`     | Specify how many lines of results to show. Equivalent to fzy's `--lines` option.  | `10`    |
| `g:fzy.prompt`    | Fzy input prompt. Equivalent to fzy's `--prompt` option.                          | `▶ `    |
| `g:fzy.showinfo`  | Show selection info line. Equivalent to fzy's `--show-info` option.               | `0`     |

Example:
```vim
let g:fzy = {'lines': 15, 'prompt': '>>> ', 'showinfo': 1}
```

**Note:** The values are also used by [vim-fzy-find][fzy-find] to provide a
uniform fzy interface.


## Tips and Tricks

#### Custom commands

If you prefer shorter Ex commands, add the following to your `vimrc`:
```vim
command! ME MRUedit
command! MS MRUsplit
command! MV vertical MRUsplit
command! MT tab MRUsplit
```
The command names are inspired by [vim-tinyMRU][tinymru].

#### Mappings

If you prefer mappings over Ex commands, you might find the following useful:
```vim
" Jump between listed buffers
nnoremap <silent> <leader>be :<c-u>Buffer<cr>
nnoremap <silent> <leader>bs :<c-u>SBuffer<cr>
nnoremap <silent> <leader>bv :<c-u>vertical SBuffer<cr>
nnoremap <silent> <leader>bt :<c-u>tab SBuffer<cr>

" Jump between buffers in global arglist
nnoremap <silent> <leader>ae :<c-u>Args<cr>
nnoremap <silent> <leader>as :<c-u>SArgs<cr>
nnoremap <silent> <leader>av :<c-u>vertical SArgs<cr>
nnoremap <silent> <leader>at :<c-u>tab SArgs<cr>

" Quickly edit oldfiles
nnoremap <silent> <leader>me :<c-u>MRUedit<cr>
nnoremap <silent> <leader>ms :<c-u>MRUsplit<cr>
nnoremap <silent> <leader>mv :<c-u>vertical MRUsplit<cr>
nnoremap <silent> <leader>mt :<c-u>tab MRUsplit<cr>

" Quickly jump to tag location
nnoremap <silent> <leader>te :<c-u>Tjump<cr>
nnoremap <silent> <leader>ts :<c-u>STjump<cr>
nnoremap <silent> <leader>tv :<c-u>vertical STjump<cr>
nnoremap <silent> <leader>tt :<c-u>tab STjump<cr>

" Quickly open help pages
nnoremap <silent> <leader>hh :<c-u>Help<cr>
nnoremap <silent> <leader>hv :<c-u>vertical Help<cr>
nnoremap <silent> <leader>ht :<c-u>tab Help<cr>
```


## Installation

#### Manual Installation

Run the following commands in your terminal:
```bash
$ cd ~/.vim/pack/git-plugins/start
$ git clone https://github.com/bfrg/vim-fzy
$ git clone https://github.com/bfrg/vim-fzy-builtins
$ vim -u NONE -c "helptags vim-fzy/doc" -c q
$ vim -u NONE -c "helptags vim-fzy-builtins/doc" -c q
```
**Note:** The directory name `git-plugins` is arbitrary, you can pick any other
name. For more details see `:help packages`.

#### Plugin Managers

Assuming [vim-plug][plug] is your favorite plugin manager, add the following to
your `vimrc`:
```vim
Plug 'bfrg/vim-fzy'
Plug 'bfrg/vim-fzy-builtins'
```


## License

Distributed under the same terms as Vim itself. See `:help license`.

[fzy]: https://github.com/jhawthorn/fzy
[vim-fzy]: https://github.com/bfrg/vim-fzy
[fzy-find]: https://github.com/bfrg/vim-fzy-find
[tinymru]: https://github.com/romainl/vim-tinyMRU
[plug]: https://github.com/junegunn/vim-plug

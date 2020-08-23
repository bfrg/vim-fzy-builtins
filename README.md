# vim-fzy-builtins

Fuzzy-select buffers, files in `arglist`, tags, help tags, `oldfiles`, and file
marks using the fuzzy-searcher [fzy][fzy].

<dl>
  <p align="center">
  <a href="https://asciinema.org/a/268637">
    <img src="https://asciinema.org/a/268637.png" width="480">
  </a>
  </p>
</dl>

## Requirements

- Vim `>= 8.1.1828` (`>= 8.2.0204` for popup window)
- [fzy][fzy]
- [vim-fzy][vim-fzy] (see [installation](#installation) instructions below)
- [cut(1)][cut] (for the <kbd>:Help</kbd> command)


## Usage

| Command                 | Description                                                               |
| ----------------------- | ------------------------------------------------------------------------- |
| <kbd>:Buffer</kbd>      | List **buffers**, edit selected buffer in current window.                 |
| <kbd>:SBuffer</kbd>\*   | Same as <kbd>:Buffer</kbd>, but edit the selected buffer in a new split.  |
| <kbd>:Args</kbd>        | List **global arglist**, edit selected file in current window.            |
| <kbd>:SArgs</kbd>\*     | Same as <kbd>:Args</kbd>, but edit the selected file in a new split.      |
| <kbd>:Largs</kbd>       | List **local arglist**, edit selected file in current window.             |
| <kbd>:SLargs</kbd>\*    | Same as <kbd>:Largs</kbd>, but edit the selected file in a new split.     |
| <kbd>:MRUedit</kbd>     | List **Most-Recently-Used** files, edit selected file in current window.  |
| <kbd>:MRUsplit</kbd>\*  | Same as <kbd>:MRUedit</kbd>, but edit the selected file in a new split.   |
| <kbd>:Tjump</kbd>       | List **tags**, jump to selected tag in current window.                    |
| <kbd>:STjump</kbd>\*    | Same as <kbd>:Tjump</kbd>, but jump to the selected tag in a new split.   |
| <kbd>:Marks</kbd>       | List **marks**, jump to the selected mark in the current window.          |
| <kbd>:SMarks</kbd>\*    | Same as <kbd>:Marks</kbd>, but jump to the selected mark in a new split.  |
| <kbd>:Help</kbd>\*      | List **help tags**, open help page with the selected tag in new split.    |


\*Commands that split the current window accept a **command modifier**. For
example, to open the help page with the selected tag in a new vertical split,
run <kbd>:vertical Help</kbd>. <kbd>:tab MRUsplit</kbd> will open the selected
file in a new tab.

For a full list of supported command modifiers, see <kbd>:help fzy-:SBuffer</kbd>.


## Configuration

Options can be passed to fzy through the dictionary `g:fzy`. Currently, the
following entries are supported:

| Entry            | Description                                                               | Default      |
| ---------------- | ------------------------------------------------------------------------- | ------------ |
| `lines`          | Specify how many lines of results to show. Sets the fzy `--lines` option. | `10`         |
| `prompt`         | Set the fzy input prompt.                                                 | `'▶ '`       |
| `showinfo`       | If true, fzy is invoked with the `--show-info` option.                    | `0`          |
| `term_highlight` | Highlight group for the terminal window.                                  | `'Terminal'` |
| `popup`          | Display fzy in a popup window. Entry must be a dictionary.                | see below    |

**Note:** All entries are also used by [vim-fzy-find][fzy-find] to provide a
uniform fzy interface.

When the `popup` entry is specified, the fzy terminal is displayed in a popup
window in the center of the screen. When set to an empty dictionary, the
following values are used:
```vim
{
    'padding': [0, 1, 0, 1],
    'border': [],
    'minwidth': 80
}
```

The following `popup` entries can be set: `line`, `col`, `pos`, `minwidth`,
`drag`, `resize`, `close`, `padding`, `border`, `borderhighlight`,
`borderchars`, `highlight`, and `zindex`. For more details on each entry see
<kbd>:help popup-usage</kbd> as well as the examples below.


## Examples

1. Display 15 items, use a custom prompt, and show the selection info line:
   ```vim
   let g:fzy = {
           \ 'lines': 15,
           \ 'prompt': '>>> ',
           \ 'showinfo': 1
           \ }
   ```
2. Same as 1. but display fzy in a popup window, use the default popup options:
   ```vim
   let g:fzy = {
           \ 'lines': 15,
           \ 'prompt': '>>> ',
           \ 'showinfo': 1,
           \ 'popup': {}
           \ }
   ```
3. Use a custom popup border and custom highlighting:
   ```vim
   let g:fzy = {
           \   'lines': 15,
           \   'showinfo': 1,
           \   'term_highlight': 'NormalDark',
           \   'popup': {
           \     'minwidth': 90,
           \     'highlight': 'NormalDark',
           \     'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
           \     'padding': [0, 1, 0, 1],
           \     'borderhighlight': ['GreyDark']
           \   }
           \ }
   ```
4. Same as 3. but don't draw a popup border:
   ```vim
   let g:fzy = {
           \   'lines': 15,
           \   'showinfo': 1,
           \   'term_highlight': 'NormalDark',
           \   'popup': {
           \     'minwidth': 90,
           \     'highlight': 'NormalDark',
           \     'borderchars': [' '],
           \     'padding': [0, 1, 0, 1],
           \     'borderhighlight': ['GreyDark']
           \   }
           \ }
   ```
5. Open the popup window at the 5th screen line from the top of the screen:
   ```vim
   let g:fzy = {
           \   'lines': 15,
           \   'showinfo': 1,
           \   'popup': {
           \     'padding': [0, 1, 0, 1],
           \     'pos': 'topleft',
           \     'line': 5,
           \   }
           \ }
   ```


## Tips and Tricks

#### Custom commands

If you prefer shorter Ex commands, add the following to your `vimrc`:
```vim
command ME MRUedit
command MS MRUsplit
command MV vertical MRUsplit
command MT tab MRUsplit
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
name. For more details see <kbd>:help packages</kbd>.

#### Plugin Managers

Assuming [vim-plug][plug] is your favorite plugin manager, add the following to
your `vimrc`:
```vim
Plug 'bfrg/vim-fzy'
Plug 'bfrg/vim-fzy-builtins'
```


## License

Distributed under the same terms as Vim itself. See <kbd>:help license</kbd>.

[fzy]: https://github.com/jhawthorn/fzy
[vim-fzy]: https://github.com/bfrg/vim-fzy
[cut]: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/cut.html
[fzy-find]: https://github.com/bfrg/vim-fzy-find
[tinymru]: https://github.com/romainl/vim-tinyMRU
[plug]: https://github.com/junegunn/vim-plug

" ==============================================================================
" Fuzzy-select tags, buffers, help tags, oldfiles
" File:         autoload/fzy/common.vim
" Author:       bfrg <https://github.com/bfrg>
" Website:      https://github.com/bfrg/vim-fzy-common
" Last Change:  Sep 15, 2019
" License:      Same as Vim itself (see :h license)
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

function! s:open_file_cb(vim_cmd, choice) abort
    let fname = fnameescape(a:choice)
    call histadd('cmd', a:vim_cmd . ' ' . fname)
    execute a:vim_cmd fname
endfunction

function! s:open_tag_cb(vim_cmd, choice) abort
    call histadd('cmd', a:vim_cmd . ' ' . a:choice)
    execute a:vim_cmd escape(a:choice, '"')
endfunction

function! fzy#common#buffers(edit_cmd, ...) abort
    let cmd = a:0
            \ ? empty(a:1) ? a:edit_cmd : (a:1 . ' ' . a:edit_cmd)
            \ : a:edit_cmd
    let items = map(
            \ filter(range(1, bufnr('$')), 'buflisted(v:val)'),
            \ 'empty(bufname(v:val)) ? v:val : bufname(v:val)'
            \ )
    call fzy#start(items, function('s:open_file_cb', [cmd]), {
            \ 'statusline': printf(':%s [listed buffers (%d)]', cmd, len(items))
            \ })
endfunction

function! fzy#common#mru(edit_cmd, ...) abort
    let cmd = a:0
            \ ? empty(a:1) ? a:edit_cmd : (a:1 . ' ' . a:edit_cmd)
            \ : a:edit_cmd
    let items = filter(copy(v:oldfiles), "filereadable(fnamemodify(v:val, ':p'))")
    call fzy#start(items, function('s:open_file_cb', [cmd]), {
            \ 'statusline': printf(':%s [oldfiles (%d)]', cmd, len(items))
            \ })
endfunction

function! fzy#common#arg(edit_cmd, local, ...) abort
    let items = a:local ? argv() : argv(-1, -1)
    let str = a:local ? 'local arglist' : 'global arglist'
    let cmd = a:0
            \ ? empty(a:1) ? a:edit_cmd : (a:1 . ' ' . a:edit_cmd)
            \ : a:edit_cmd
    call fzy#start(items, function('s:open_file_cb', [cmd]), {
            \ 'statusline': printf(':%s [%s (%d)]', cmd, str, len(items))
            \ })
endfunction

function! fzy#common#help(help_cmd, mods) abort
    let cmd = empty(a:mods) ? a:help_cmd : (a:mods . ' ' . a:help_cmd)
    let items = 'cut -f 1 ' . join(findfile('doc/tags', &runtimepath, -1))
    call fzy#start(items, function('s:open_tag_cb', [cmd]), {
            \ 'statusline': printf(':%s [helptags (%d)]', cmd, len(items))
            \ })
endfunction

function! fzy#common#tags(tags_cmd, ...) abort
    let cmd = a:0
            \ ? empty(a:1) ? a:tags_cmd : (a:1 . ' ' . a:tags_cmd)
            \ : a:tags_cmd
    let items = uniq(sort(map(taglist('.*'), 'v:val.name')))
    call fzy#start(items, function('s:open_tag_cb', [cmd]), {
            \ 'statusline': printf(':%s [tags (%d)]', cmd, len(items))
            \ })
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

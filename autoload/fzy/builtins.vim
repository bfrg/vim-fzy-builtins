" ==============================================================================
" Fuzzy-select buffers, args, tags, help tags, oldfiles, marks
" File:         autoload/fzy/builtins.vim
" Author:       bfrg <https://github.com/bfrg>
" Website:      https://github.com/bfrg/vim-fzy-builtins
" Last Change:  Feb 11, 2020
" License:      Same as Vim itself (see :h license)
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let s:defaults = {'prompt': '▶ ', 'height': 11}
let s:get = {k -> has_key(get(g:, 'fzy', {}), k) ? get(g:fzy, k) : get(s:defaults, k)}

function! s:open_file_cb(vim_cmd, choice) abort
    let fname = fnameescape(a:choice)
    call histadd('cmd', a:vim_cmd . ' ' . fname)
    execute a:vim_cmd fname
endfunction

function! s:open_tag_cb(vim_cmd, choice) abort
    call histadd('cmd', a:vim_cmd . ' ' . a:choice)
    execute a:vim_cmd escape(a:choice, '"')
endfunction

function! s:marks_cb(split_cmd, bang, item) abort
    if !empty(a:split_cmd)
        execute a:split_cmd
    endif
    let cmd = a:bang ? "g`" : "`"
    execute 'normal! ' .. cmd .. a:item[1]
endfunction

function! fzy#builtins#buffers(edit_cmd, bang, ...) abort
    let cmd = a:0
            \ ? empty(a:1) ? a:edit_cmd : (a:1 . ' ' . a:edit_cmd)
            \ : a:edit_cmd
    let items = map(
            \ filter(range(1, bufnr('$')),
            \   {_,val -> a:bang ? bufexists(val) : buflisted(val)}),
            \ {_,val -> empty(bufname(val)) ? val : bufname(val)}
            \ )
    let stl = printf(':%s [%s buffers (%d)]', cmd, a:bang ? 'all' : 'listed', len(items))
    return fzy#start(items, funcref('s:open_file_cb', [cmd]), {
            \ 'prompt': s:get('prompt'),
            \ 'height': s:get('height'),
            \ 'statusline': stl
            \ })
endfunction

function! fzy#builtins#mru(edit_cmd, ...) abort
    let cmd = a:0
            \ ? empty(a:1) ? a:edit_cmd : (a:1 . ' ' . a:edit_cmd)
            \ : a:edit_cmd
    let items = filter(copy(v:oldfiles), "filereadable(fnamemodify(v:val, ':p'))")
    return fzy#start(items, funcref('s:open_file_cb', [cmd]), {
            \ 'prompt': s:get('prompt'),
            \ 'height': s:get('height'),
            \ 'statusline': printf(':%s [oldfiles (%d)]', cmd, len(items))
            \ })
endfunction

function! fzy#builtins#arg(edit_cmd, local, ...) abort
    let items = a:local ? argv() : argv(-1, -1)
    let str = a:local ? 'local arglist' : 'global arglist'
    let cmd = a:0
            \ ? empty(a:1) ? a:edit_cmd : (a:1 . ' ' . a:edit_cmd)
            \ : a:edit_cmd
    return fzy#start(items, funcref('s:open_file_cb', [cmd]), {
            \ 'prompt': s:get('prompt'),
            \ 'height': s:get('height'),
            \ 'statusline': printf(':%s [%s (%d)]', cmd, str, len(items))
            \ })
endfunction

function! fzy#builtins#help(help_cmd, mods) abort
    let cmd = empty(a:mods) ? a:help_cmd : (a:mods . ' ' . a:help_cmd)
    let items = 'cut -f 1 ' . join(findfile('doc/tags', &runtimepath, -1))
    return fzy#start(items, funcref('s:open_tag_cb', [cmd]), {
            \ 'prompt': s:get('prompt'),
            \ 'height': s:get('height'),
            \ 'statusline': printf(':%s [helptags (%d)]', cmd, len(items))
            \ })
endfunction

function! fzy#builtins#tags(tags_cmd, ...) abort
    let cmd = a:0
            \ ? empty(a:1) ? a:tags_cmd : (a:1 . ' ' . a:tags_cmd)
            \ : a:tags_cmd
    let items = uniq(sort(map(taglist('.*'), 'v:val.name')))
    return fzy#start(items, funcref('s:open_tag_cb', [cmd]), {
            \ 'prompt': s:get('prompt'),
            \ 'height': s:get('height'),
            \ 'statusline': printf(':%s [tags (%d)]', cmd, len(items))
            \ })
endfunction

function! fzy#builtins#marks(bang, ...) abort
    let cmd = a:0 ? a:1 .. ' split' : ''
    let output = split(execute('marks'), '\n')
    return fzy#start(output[1:], funcref('s:marks_cb', [cmd, a:bang]), {
            \ 'prompt': s:get('prompt'),
            \ 'height': s:get('height'),
            \ 'statusline': output[0]
            \ })
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

" ==============================================================================
" Fuzzy-select buffers, args, tags, help tags, oldfiles, marks
" File:         autoload/fzy/builtins.vim
" Author:       bfrg <https://github.com/bfrg>
" Website:      https://github.com/bfrg/vim-fzy-builtins
" Last Change:  Apr 4, 2020
" License:      Same as Vim itself (see :h license)
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let s:defaults = {'prompt': '▶ ', 'lines': 10, 'showinfo': 0}
let s:get = {k -> get(g:, 'fzy', {})->get(k, get(s:defaults, k))}

function! s:open_file_cb(vim_cmd, choice) abort
    let fname = fnameescape(a:choice)
    call histadd('cmd', a:vim_cmd .. ' ' .. fname)
    execute a:vim_cmd fname
endfunction

function! s:open_tag_cb(vim_cmd, choice) abort
    call histadd('cmd', a:vim_cmd .. ' ' .. a:choice)
    execute a:vim_cmd escape(a:choice, '"')
endfunction

function! s:marks_cb(split_cmd, bang, item) abort
    if !empty(a:split_cmd)
        execute a:split_cmd
    endif
    let cmd = a:bang ? "g`" : "`"
    execute 'normal! ' .. cmd .. a:item[1]
endfunction

function! fzy#builtins#buffers(edit_cmd, bang, mods) abort
    let cmd = empty(a:mods) ? a:edit_cmd : (a:mods .. ' ' .. a:edit_cmd)
    let items = range(1, bufnr('$'))
            \ ->filter({_,i -> a:bang ? bufexists(i) : buflisted(i)})
            \ ->map({_,i -> empty(bufname(i)) ? i : bufname(i)})
    let stl = printf(':%s [%s buffers (%d)]', cmd, a:bang ? 'all' : 'listed', len(items))
    return fzy#start(items, funcref('s:open_file_cb', [cmd]), {
            \ 'prompt': s:get('prompt'),
            \ 'lines': s:get('lines'),
            \ 'showinfo': s:get('showinfo'),
            \ 'statusline': stl
            \ })
endfunction

function! fzy#builtins#mru(edit_cmd, mods) abort
    let cmd = empty(a:mods) ? a:edit_cmd : (a:mods .. ' ' .. a:edit_cmd)
    let items = copy(v:oldfiles)
            \ ->filter("filereadable(fnamemodify(v:val, ':p'))")
            \ ->map("fnamemodify(v:val, ':~:.')")
    return fzy#start(items, funcref('s:open_file_cb', [cmd]), {
            \ 'prompt': s:get('prompt'),
            \ 'lines': s:get('lines'),
            \ 'showinfo': s:get('showinfo'),
            \ 'statusline': printf(':%s [oldfiles (%d)]', cmd, len(items))
            \ })
endfunction

function! fzy#builtins#arg(edit_cmd, local, mods) abort
    let items = a:local ? argv() : argv(-1, -1)
    let str = a:local ? 'local arglist' : 'global arglist'
    let cmd = empty(a:mods) ? a:edit_cmd : (a:mods .. ' ' .. a:edit_cmd)
    return fzy#start(items, funcref('s:open_file_cb', [cmd]), {
            \ 'prompt': s:get('prompt'),
            \ 'lines': s:get('lines'),
            \ 'showinfo': s:get('showinfo'),
            \ 'statusline': printf(':%s [%s (%d)]', cmd, str, len(items))
            \ })
endfunction

function! fzy#builtins#help(help_cmd, mods) abort
    let cmd = empty(a:mods) ? a:help_cmd : (a:mods .. ' ' .. a:help_cmd)
    let items = 'cut -f 1 ' .. join(findfile('doc/tags', &runtimepath, -1))
    return fzy#start(items, funcref('s:open_tag_cb', [cmd]), {
            \ 'prompt': s:get('prompt'),
            \ 'lines': s:get('lines'),
            \ 'showinfo': s:get('showinfo'),
            \ 'statusline': printf(':%s [helptags]', cmd)
            \ })
endfunction

function! fzy#builtins#tags(tags_cmd, mods) abort
    let cmd = empty(a:mods) ? a:tags_cmd : (a:mods .. ' ' .. a:tags_cmd)
    let items = taglist('.*')->map('v:val.name')->sort()->uniq()
    return fzy#start(items, funcref('s:open_tag_cb', [cmd]), {
            \ 'prompt': s:get('prompt'),
            \ 'lines': s:get('lines'),
            \ 'showinfo': s:get('showinfo'),
            \ 'statusline': printf(':%s [tags (%d)]', cmd, len(items))
            \ })
endfunction

function! fzy#builtins#marks(bang, ...) abort
    let cmd = a:0 ? a:1 .. ' split' : ''
    let output = execute('marks')->split('\n')
    return fzy#start(output[1:], funcref('s:marks_cb', [cmd, a:bang]), {
            \ 'prompt': s:get('prompt'),
            \ 'lines': s:get('lines'),
            \ 'showinfo': s:get('showinfo'),
            \ 'statusline': output[0]
            \ })
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

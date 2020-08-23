" ==============================================================================
" Fuzzy-select buffers, args, tags, help tags, oldfiles, marks
" File:         autoload/fzy/builtins.vim
" Author:       bfrg <https://github.com/bfrg>
" Website:      https://github.com/bfrg/vim-fzy-builtins
" Last Change:  Aug 23, 2020
" License:      Same as Vim itself (see :h license)
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

const s:defaults = {
        \ 'prompt': '▶ ',
        \ 'lines': 10,
        \ 'showinfo': 0,
        \ 'term_highlight': 'Terminal',
        \ 'popup': {}
        \ }

const s:get = {k -> get(g:, 'fzy', {})->get(k, get(s:defaults, k))}
const s:use_popup = {-> has_key(get(g:, 'fzy', {}), 'popup')}

const s:fzyopts = {s -> {
        \ 'prompt': s:get('prompt'),
        \ 'lines': s:get('lines'),
        \ 'showinfo': s:get('showinfo'),
        \ 'term_highlight': s:get('term_highlight'),
        \ 'statusline': s
        \ }}

function s:set_popup_opts(dict, title) abort
    let opts = {'popup': {'title': a:title }}
    call extend(opts.popup, s:get('popup'), 'keep')
    call extend(a:dict, opts)
endfunction

function s:open_file_cb(vim_cmd, choice) abort
    const fname = fnameescape(a:choice)
    call histadd('cmd', a:vim_cmd .. ' ' .. fname)
    execute a:vim_cmd fname
endfunction

function s:open_tag_cb(vim_cmd, choice) abort
    call histadd('cmd', a:vim_cmd .. ' ' .. a:choice)
    execute a:vim_cmd escape(a:choice, '"')
endfunction

function s:marks_cb(split_cmd, bang, item) abort
    if !empty(a:split_cmd)
        execute a:split_cmd
    endif
    const cmd = a:bang ? "g`" : "`"
    execute 'normal! ' .. cmd .. a:item[1]
endfunction

function fzy#builtins#buffers(edit_cmd, bang, mods) abort
    const cmd = empty(a:mods) ? a:edit_cmd : (a:mods .. ' ' .. a:edit_cmd)
    const items = range(1, bufnr('$'))
            \ ->filter(a:bang ? 'bufexists(v:val)' : 'buflisted(v:val)')
            \ ->map('empty(bufname(v:val)) ? v:val : fnamemodify(bufname(v:val), ":~:.")')
    const stl = printf(':%s (%s buffers)', cmd, a:bang ? 'all' : 'listed')
    let opts = s:fzyopts(stl)

    if s:use_popup()
        call s:set_popup_opts(opts, stl)
    endif

    return fzy#start(items, funcref('s:open_file_cb', [cmd]), opts)
endfunction

function fzy#builtins#mru(edit_cmd, mods) abort
    const cmd = empty(a:mods) ? a:edit_cmd : (a:mods .. ' ' .. a:edit_cmd)
    const items = copy(v:oldfiles)
            \ ->filter("fnamemodify(v:val, ':p')->filereadable()")
            \ ->map("fnamemodify(v:val, ':~:.')")
    const stl = printf(':%s (oldfiles)', cmd, len(items))
    let opts = s:fzyopts(stl)

    if s:use_popup()
        call s:set_popup_opts(opts, stl)
    endif

    return fzy#start(items, funcref('s:open_file_cb', [cmd]), opts)
endfunction

function fzy#builtins#arg(edit_cmd, local, mods) abort
    const items = a:local ? argv() : argv(-1, -1)
    const str = a:local ? 'local arglist' : 'global arglist'
    const cmd = empty(a:mods) ? a:edit_cmd : (a:mods .. ' ' .. a:edit_cmd)
    const stl = printf(':%s (%s)', cmd, str, len(items))
    let opts = s:fzyopts(stl)

    if s:use_popup()
        call s:set_popup_opts(opts, stl)
    endif

    return fzy#start(items, funcref('s:open_file_cb', [cmd]), opts)
endfunction

function fzy#builtins#help(help_cmd, mods) abort
    const cmd = empty(a:mods) ? a:help_cmd : (a:mods .. ' ' .. a:help_cmd)
    const items = 'cut -f 1 ' .. findfile('doc/tags', &runtimepath, -1)->join()
    const stl = printf(':%s (helptags)', cmd)
    let opts = s:fzyopts(stl)

    if s:use_popup()
        call s:set_popup_opts(opts, stl)
    endif

    return fzy#start(items, funcref('s:open_tag_cb', [cmd]), opts)
endfunction

function fzy#builtins#tags(tags_cmd, mods) abort
    const cmd = empty(a:mods) ? a:tags_cmd : (a:mods .. ' ' .. a:tags_cmd)
    const items = taglist('.*')->map('v:val.name')->sort()->uniq()
    const stl = printf(':%s [%s]', cmd, tagfiles()->map('fnamemodify(v:val, ":~:.")')->join(', '))
    let opts = s:fzyopts(stl)

    if s:use_popup()
        call s:set_popup_opts(opts, stl)
    endif

    return fzy#start(items, funcref('s:open_tag_cb', [cmd]), opts)
endfunction

function fzy#builtins#marks(bang, ...) abort
    const cmd = a:0 ? a:1 .. ' split' : ''
    const output = execute('marks')->split('\n')
    let opts = s:fzyopts(output[0])

    if s:use_popup()
        call s:set_popup_opts(opts, ' ' .. output[0])
    endif

    return fzy#start(output[1:], funcref('s:marks_cb', [cmd, a:bang]), opts)
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

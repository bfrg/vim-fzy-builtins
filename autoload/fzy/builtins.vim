" ==============================================================================
" Fuzzy-select buffers, args, tags, help tags, oldfiles, marks
" File:         autoload/fzy/builtins.vim
" Author:       bfrg <https://github.com/bfrg>
" Website:      https://github.com/bfrg/vim-fzy-builtins
" Last Change:  Oct 12, 2020
" License:      Same as Vim itself (see :h license)
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

function s:opts(title, space = 0) abort
    let opts = get(g:, 'fzy', {})->copy()->extend({'statusline': a:title, 'prompt': '▶ '})
    call get(opts, 'popup', {})->extend({'title': a:space ? ' ' .. a:title : a:title})
    return opts
endfunction

function s:tryexe(cmd)
    try
        execute a:cmd
    catch
        echohl ErrorMsg
        echomsg matchstr(v:exception, '^Vim\%((\a\+)\)\=:\zs.*')
        echohl None
    endtry
endfunction

function s:open_file_cb(vim_cmd, choice) abort
    const fname = fnameescape(a:choice)
    call histadd('cmd', a:vim_cmd .. ' ' .. fname)
    call s:tryexe(a:vim_cmd .. ' ' .. fname)
endfunction

function s:open_tag_cb(vim_cmd, choice) abort
    call histadd('cmd', a:vim_cmd .. ' ' .. a:choice)
    call s:tryexe(a:vim_cmd .. ' ' .. escape(a:choice, '"'))
endfunction

function s:marks_cb(split_cmd, bang, item) abort
    if !empty(a:split_cmd)
        execute a:split_cmd
    endif
    const cmd = a:bang ? "g`" : "`"
    call s:tryexe('normal! ' .. cmd .. a:item[1])
endfunction

function fzy#builtins#buffers(edit_cmd, bang, mods) abort
    const cmd = empty(a:mods) ? a:edit_cmd : (a:mods .. ' ' .. a:edit_cmd)
    const items = range(1, bufnr('$'))
            \ ->filter(a:bang ? 'bufexists(v:val)' : 'buflisted(v:val)')
            \ ->map('empty(bufname(v:val)) ? v:val : fnamemodify(bufname(v:val), ":~:.")')
    const stl = printf(':%s (%s buffers)', cmd, a:bang ? 'all' : 'listed')
    return fzy#start(items, funcref('s:open_file_cb', [cmd]), s:opts(stl))
endfunction

function fzy#builtins#mru(edit_cmd, mods) abort
    const cmd = empty(a:mods) ? a:edit_cmd : (a:mods .. ' ' .. a:edit_cmd)
    const items = copy(v:oldfiles)
            \ ->filter("fnamemodify(v:val, ':p')->filereadable()")
            \ ->map("fnamemodify(v:val, ':~:.')")
    const stl = printf(':%s (oldfiles)', cmd)
    return fzy#start(items, funcref('s:open_file_cb', [cmd]), s:opts(stl))
endfunction

function fzy#builtins#arg(edit_cmd, local, mods) abort
    const items = a:local ? argv() : argv(-1, -1)
    const str = a:local ? 'local arglist' : 'global arglist'
    const cmd = empty(a:mods) ? a:edit_cmd : (a:mods .. ' ' .. a:edit_cmd)
    const stl = printf(':%s (%s)', cmd, str)
    return fzy#start(items, funcref('s:open_file_cb', [cmd]), s:opts(stl))
endfunction

function fzy#builtins#help(help_cmd, mods) abort
    const cmd = empty(a:mods) ? a:help_cmd : (a:mods .. ' ' .. a:help_cmd)
    const items = 'cut -f 1 ' .. findfile('doc/tags', &runtimepath, -1)->join()
    const stl = printf(':%s (helptags)', cmd)
    return fzy#start(items, funcref('s:open_tag_cb', [cmd]), s:opts(stl))
endfunction

function fzy#builtins#tags(tags_cmd, mods) abort
    const cmd = empty(a:mods) ? a:tags_cmd : (a:mods .. ' ' .. a:tags_cmd)
    const items = executable('sed') && executable('cut') && executable('sort') && executable('uniq')
            \ ? printf("sed '/^!_TAG_/ d' %s | cut -f 1 | sort | uniq", tagfiles()->join())
            \ : taglist('.*')->map('v:val.name')->sort()->uniq()
    const stl = printf(':%s [%s]', cmd, tagfiles()->map('fnamemodify(v:val, ":~:.")')->join(', '))
    return fzy#start(items, funcref('s:open_tag_cb', [cmd]), s:opts(stl))
endfunction

function fzy#builtins#marks(bang, ...) abort
    const cmd = a:0 ? a:1 .. ' split' : ''
    const output = execute('marks')->split('\n')
    return fzy#start(output[1:], funcref('s:marks_cb', [cmd, a:bang]), s:opts(output[0], 1))
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

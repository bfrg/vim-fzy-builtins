" ==============================================================================
" Fuzzy-select tags, buffers, help tags, oldfiles
" File:         plugin/fzycommon.vim
" Author:       bfrg <https://github.com/bfrg>
" Website:      https://github.com/bfrg/vim-fzy-common
" Last Change:  Sep 15, 2019
" License:      Same as Vim itself (see :h license)
" ==============================================================================

if exists('g:loaded_fzycommon')
    finish
endif
let g:loaded_fzycommon = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Jump to Most-Recently-Used files, v:oldfiles
command! MRUedit  call fzy#common#mru('edit')
command! MRUsplit call fzy#common#mru('split', <q-mods>)

" Jump to listed buffers
command! -bang Buffer  call fzy#common#buffers('buffer', <bang>0)
command! -bang SBuffer call fzy#common#buffers('sbuffer', <bang>0, <q-mods>)

" Jump to file in global arglist
command! Args  call fzy#common#arg('edit', 0)
command! SArgs call fzy#common#arg('split', 0, <q-mods>)

" Jump to file in local arglist
command! Largs  call fzy#common#arg('edit', 1)
command! SLargs call fzy#common#arg('split', 1, <q-mods>)

" Jump to tags
command!  Tjump call fzy#common#tags('tjump')
command! STjump call fzy#common#tags('stjump', <q-mods>)

" Jump to Vim's help tags
command! Help call fzy#common#help('help', <q-mods>)

let &cpoptions = s:save_cpo
unlet s:save_cpo

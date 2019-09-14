" ==============================================================================
" Fuzzy-select tags, buffers, help tags, oldfiles
" File:         plugin/fzycommon.vim
" Author:       bfrg <https://github.com/bfrg>
" Website:      https://github.com/bfrg/vim-fzy-common
" Last Change:  Sep 14, 2019
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
command! Buffer  call fzy#common#buffers('buffer')
command! SBuffer call fzy#common#buffers('sbuffer', <q-mods>)

" Jump to tags
command!  Tjump call fzy#common#tags('tjump')
command! STjump call fzy#common#tags('stjump', <q-mods>)

" Jump to Vim's help tags
command! Help call fzy#common#help('help', <q-mods>)

let &cpoptions = s:save_cpo
unlet s:save_cpo

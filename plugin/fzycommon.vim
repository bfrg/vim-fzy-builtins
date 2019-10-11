" ==============================================================================
" Fuzzy-select buffers, args, tags, help tags, oldfiles, marks
" File:         plugin/fzycommon.vim
" Author:       bfrg <https://github.com/bfrg>
" Website:      https://github.com/bfrg/vim-fzy-common
" Last Change:  Oct 11, 2019
" License:      Same as Vim itself (see :h license)
" ==============================================================================

if exists('g:loaded_fzycommon')
    finish
endif
let g:loaded_fzycommon = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Jump to Most-Recently-Used files, v:oldfiles
command! -bar MRUedit  call fzy#common#mru('edit')
command! -bar MRUsplit call fzy#common#mru('split', <q-mods>)

" Jump to listed buffers
command! -bar -bang Buffer  call fzy#common#buffers('buffer', <bang>0)
command! -bar -bang SBuffer call fzy#common#buffers('sbuffer', <bang>0, <q-mods>)

" Jump to file in global arglist
command! -bar Args  call fzy#common#arg('edit', 0)
command! -bar SArgs call fzy#common#arg('split', 0, <q-mods>)

" Jump to file in local arglist
command! -bar Largs  call fzy#common#arg('edit', 1)
command! -bar SLargs call fzy#common#arg('split', 1, <q-mods>)

" Jump to tags
command! -bar  Tjump call fzy#common#tags('tjump')
command! -bar STjump call fzy#common#tags('stjump', <q-mods>)

" Jump to file marks
command! -bar -bang  Marks call fzy#marks#jump(<bang>0)
command! -bar -bang SMarks call fzy#marks#jump(<bang>0, <q-mods>)

" Jump to Vim's help tags
command! -bar Help call fzy#common#help('help', <q-mods>)

let &cpoptions = s:save_cpo
unlet s:save_cpo

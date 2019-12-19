" ==============================================================================
" Fuzzy-select buffers, args, tags, help tags, oldfiles, marks
" File:         plugin/fzybuiltins.vim
" Author:       bfrg <https://github.com/bfrg>
" Website:      https://github.com/bfrg/vim-fzy-builtins
" Last Change:  Dec 20, 2019
" License:      Same as Vim itself (see :h license)
" ==============================================================================

if exists('g:loaded_fzybuiltins')
    finish
endif
let g:loaded_fzybuiltins = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Jump to Most-Recently-Used files, v:oldfiles
command! -bar MRUedit  call fzy#builtins#mru('edit')
command! -bar MRUsplit call fzy#builtins#mru('split', <q-mods>)

" Jump to listed buffers
command! -bar -bang Buffer  call fzy#builtins#buffers('buffer', <bang>0)
command! -bar -bang SBuffer call fzy#builtins#buffers('sbuffer', <bang>0, <q-mods>)

" Jump to file in global arglist
command! -bar Args  call fzy#builtins#arg('edit', 0)
command! -bar SArgs call fzy#builtins#arg('split', 0, <q-mods>)

" Jump to file in local arglist
command! -bar Largs  call fzy#builtins#arg('edit', 1)
command! -bar SLargs call fzy#builtins#arg('split', 1, <q-mods>)

" Jump to tags
command! -bar  Tjump call fzy#builtins#tags('tjump')
command! -bar STjump call fzy#builtins#tags('stjump', <q-mods>)

" Jump to file marks
command! -bar -bang  Marks call fzy#builtins#marks(<bang>0)
command! -bar -bang SMarks call fzy#builtins#marks(<bang>0, <q-mods>)

" Jump to Vim's help tags
command! -bar Help call fzy#builtins#help('help', <q-mods>)

let &cpoptions = s:save_cpo
unlet s:save_cpo

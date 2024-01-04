set completeopt=menuone,noselect
" hide commplete info under the statusline
set shortmess+=c

function! OpenLSPCompletion()
    if v:char =~ '[A-Za-z_.]' && !pumvisible() 
        call feedkeys("\<C-x>\<C-o>", "n")
    endif
endfunction

function! OpenNoLSPCompletion()
    if v:char =~ '[A-Za-z_]' && !pumvisible() 
        call feedkeys("\<C-n>", "n")
    endif
endfunction

function! OpenFilePathCompletion()
    if v:char =~ '[/]' && !pumvisible()
        call feedkeys("\<C-x>\<C-f>", "n")
    endif
endfunction

function! AutoComplete()
    if luaeval('#vim.lsp.buf_get_clients()') != 0
        if exists('#openNoLSPCompletion#InsertCharPre')
            autocmd! openNoLSPCompletion
        endif
        augroup openLSPCompletion
            autocmd!
            autocmd InsertCharPre * silent! call OpenLSPCompletion()
        augroup END
    else
        if exists('#openLSPCompletion#InsertCharPre')
            autocmd! openLSPCompletion
        endif
        augroup openNoLSPCompletion
            autocmd!
            autocmd InsertCharPre * silent! call OpenNoLSPCompletion()
        augroup END
    endif
endfunction

augroup initAutoComplete
    autocmd!
    autocmd WinEnter,LspAttach * call AutoComplete()
augroup END

augroup openFilePathCompletion
    autocmd!
    autocmd InsertCharPre * silent! call OpenFilePathCompletion()
augroup END

" use tab for navigating the autocomplete menu
inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" use up and down keys for navigating the autocomplete menu
inoremap <expr> <down> pumvisible() ? "\<C-n>" : "\<down>"
inoremap <expr> <up> pumvisible() ? "\<C-p>" : "\<up>"

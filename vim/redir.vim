function! ChangeDir(path)
    if !isdirectory(expand(a:path))
        echo ">> Error Path!"
        return
    endif
    if a:path=="."
        let t:rootDir=expand("%:p:h")
        exec "tc ".t:rootDir
    else
        let t:rootDir=a:path
        exec "tc ".t:rootDir
    endif
    echo getcwd()
endfunction

function! OpenRedirWindow()
    if win_id2tabwin(t:redirWinid)[1] != 0
        call win_gotoid(t:redirWinid)
        return
    end
    let t:redirPreviewWinid = win_getid()
    bot 10new
    let t:redirWinid = win_getid()
endfunction

function! QuitRedirWindow()
    if win_id2tabwin(t:redirWinid)[1] != 0
        call win_execute(t:redirWinid, 'close')
        return
    end
    echo ">> No OpenRedirWindow!"
endfunction

function! JumpWhenPressEnter(locateTargetFunctionName)
    exec "tc ".t:rootDir
    let t:redirLocateTarget=getline('.')
    if win_id2tabwin(t:redirPreviewWinid)[1] == 0
        top new
        let t:redirPreviewWinid = win_getid()
    else
        call win_gotoid(t:redirPreviewWinid)
    endif
    call function(a:locateTargetFunctionName)()
endfunction

function! JumpWhenPressJOrK(direction,locateTargetFunctionName)
    exec "tc ".t:rootDir
    exec "normal! ".a:direction
    let t:redirLocateTarget=getline('.')
    if win_id2tabwin(t:redirPreviewWinid)[1] == 0
        top new
        let t:redirPreviewWinid = win_getid()
        wincmd p
    endif
    call win_execute(t:redirPreviewWinid, "call ".a:locateTargetFunctionName."()")
endfunction

nnoremap <silent><space>q <cmd>call QuitRedirWindow()<CR>

command! -nargs=1 -complete=command C call ChangeDir(<f-args>)

augroup redirWhenTabNew
    autocmd!
    autocmd VimEnter,TabNew * let t:rootDir=getcwd() | let t:redirWinid=0
augroup END

augroup redirBufWinLeave
    autocmd!
    autocmd BufWinLeave * silent! call clearmatches(t:redirPreviewWinid)
augroup END

augroup redirCursorLine
    autocmd! 
    autocmd Filetype redirWindows setlocal cursorlineopt=line
augroup END

hi RedirFocusCurMatch ctermfg=lightgreen ctermbg=darkgray cterm=bold

exec "source ".g:config_path."/vim/redir/buffer-list.vim"
exec "source ".g:config_path."/vim/redir/file-search.vim"
exec "source ".g:config_path."/vim/redir/word-search.vim"
exec "source ".g:config_path."/vim/redir/quickfix.vim"

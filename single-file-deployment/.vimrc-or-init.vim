" +-----------------------------------------------+
" |                                               |
" |                  COLORSCHEME                  |
" |                                               |
" +-----------------------------------------------+


colorscheme retrobox


" +-----------------------------------------------+
" |                                               |
" |              BASIC SETS AND MAPS              |
" |                                               |
" +-----------------------------------------------+


syntax on

" hovel settings -----------------------------------------------------------------------------------
" case insensitive
set ignorecase

" only support command mode, no click
set mouse=a

let $LANG = 'en_US'

" tab settings
set tabstop=4
set shiftwidth=4
set softtabstop=4

" let tap become four spaces
set expandtab

" autoindent
set autoindent

" foldmethod
set foldmethod=syntax
set nofoldenable

" auto sync
set autoread

" disable error bells
set noerrorbells
set novisualbell

" set double key separation time
set timeoutlen=200

" set no swap file
set noswapfile

set cursorline
set cursorlineopt=number

" show pressed keys in vim normal mode statusline
set showcmd

" When scrolling vertically, the cursor is kept 5 rows away from the top/bottom
""set scrolloff=5

" Notice : nvim has remove these features
" Use a line cursor within insert mode and a block cursor everywhere else.
"
" Reference chart of values:
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinking underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"


" jump to the last position when reopening a file
augroup resCur
  autocmd!
  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END

set incsearch
set hlsearch

" show line number
set number
set relativenumber

if has('nvim') && exists('$TMUX')
    " share system clipboard
    set clipboard+=unnamedplus,unnamed
    vnoremap y "+y
    vnoremap d "+d
    vnoremap p "+p
    vnoremap yy "+yy
    vnoremap dd "+dd
    
    nnoremap y "+y
    nnoremap d "+d
    nnoremap p "+p
    nnoremap yy "+yy
    nnoremap dd "+dd
endif

" " visual block short-cut
" nnoremap vv <C-v>

" paste in command mod
cnoremap <C-v> <C-r>"

" show current buffer path
cnoreabbrev fd echo expand("%:p:h")

if has('nvim')
    cnoreabbrev vt vs \| term
    cnoreabbrev st sp \| term
else
    cnoreabbrev vt vert term
    cnoreabbrev st term
endif


" auto pair ---------------------------------------------------------------------------------------
inoremap { {}<Left>
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap ' ''<Left>
inoremap " ""<Left>
inoremap ` ``<Left>

" {} and ()completion when press enter in the middle of them
function! s:InsertCRBrace()
    call feedkeys("\<BS>",'n')
    let l:frontChar = getline('.')[col('.') - 2]
    if l:frontChar == "{" || l:frontChar == "("
        call feedkeys("\<CR>\<C-c>\O", 'n')
    else
        call feedkeys("\<CR>", 'n')
    endif
endfunction
inoremap <expr> <CR> <SID>InsertCRBrace()


" map ;; to esc -----------------------------------------------------------------------------------
function! s:ESC_IMAP()
    " If the char in front the cursor is ";"
    if getline('.')[col('.') - 2]== ";"
        call feedkeys("\<BS>\<BS>\<C-c>", 'n')
    else
        call feedkeys("\<BS>\;", 'n')
    endif
endfunction
inoremap <expr> ; <SID>ESC_IMAP()

vnoremap ;; <C-c>
snoremap ;; <C-c>
xnoremap ;; <C-c>
cnoremap ;; <C-c>
onoremap ;; <C-c>

" exit windows
tnoremap ;; <C-\><C-n>

if has('nvim')
    " internal terminal settings
    augroup internal_terminal
        autocmd!
        autocmd TermOpen * setlocal nonumber norelativenumber
    augroup END
else
    augroup internal_terminal
        autocmd!
        autocmd TerminalOpen * setlocal nonumber norelativenumber
    augroup END
endif
" switch windows -----------------------------------------------------------------------------------
nnoremap <silent><Tab> :wincmd w<CR>


" Search only in displayed scope -------------------------------------------------------------------
function! s:LimitSearchScope()
    let l:top = line('w0') - 1
    let l:bottom = line('w$') + 1
    call feedkeys("H^")
    call feedkeys("/\\%>".l:top."l".@/."\\%<".l:bottom."l\<CR>")
endfunction

function! s:QuickMovement()
    let l:top = line('w0')
    let l:bottom = line('w$')
    let l:toLefts=""
    let l:limitSearchScopeCmdStr="/ | LimitSearchScope"
    for i in range(1,strlen(l:limitSearchScopeCmdStr))
        let l:toLefts = l:toLefts."\<Left>"
    endfor
    call feedkeys(":silent! ".l:top.",".l:bottom."g/".l:limitSearchScopeCmdStr.l:toLefts)
endfunction

command! LimitSearchScope call s:LimitSearchScope()
nnoremap <silent> s :call <SID>QuickMovement()<CR>


" highlight settings -------------------------------------------------------------------------------
hi! def link FocusCurMatch DiffText
function! s:StressCurMatch()
    let l:target = '\c\%#'.@/
    call matchadd('FocusCurMatch', l:target)
endfunction

" centre the screen on the current search result
nnoremap <silent> n n:call <SID>StressCurMatch()<CR>
nnoremap <silent> N N:call <SID>StressCurMatch()<CR>
nnoremap <silent><expr> <Space><Space> @/=='' ?
    \ ':let @/=@s<CR>' :
    \ ':let @/=""<CR>
        \:call clearmatches()<CR>'
cnoremap <silent><expr> <CR> getcmdtype() =~ '[/?]' ?
    \ '<CR>:let @s=@/<CR>
        \:call <SID>StressCurMatch()<CR>' :
    \ '<CR>'
" cnoremap <silent><expr> <CR> getcmdtype() =~ '[/?]' ? '<CR>:call StressCurMatch()<CR>' : '<CR>'


" wild* settings -----------------------------------------------------------------------------------
set wildmenu
set wildoptions=pum
set wildcharm=<Tab>
if has('nvim')
    cnoremap <expr> <Up> wildmenumode() ? "\<Left>" : "\<Up>"
    cnoremap <expr> <Down> wildmenumode() ? "\<Right>" : "\<Down>"
    cnoremap <expr> <Left> wildmenumode() ? "\<Space>\<BS>" : "\<Left>"
    cnoremap <expr> <Right> wildmenumode() ? "\<Space>\<BS>" : "\<Right>"
endif


" quick action to move the cursor to the begin or end of the line
nnoremap <expr>0 col('.') == 1 ? '$' : '0'
vnoremap <expr>0 col('.') == 1 ? '$' : '0'

" move code block up or down
nnoremap <silent><S-Down> :m .+1<CR>==
nnoremap <silent><S-Up> :m .-2<CR>==
vnoremap <silent><S-Down> :m '>+1<CR>gv=gv
vnoremap <silent><S-Up> :m '<-2<CR>gv=gv

" %s/\s\+$//e
function! s:RmTrailingSpace()
    %s/\s\+$//e
endfunction

command! RmTrailingSpace call s:RmTrailingSpace()

nnoremap <silent><S-Tab> :tabnext<CR>

" spetial chars
set fillchars+=eob:\ 
set fillchars+=vert:\│

set list
set listchars=tab:┊\ ,eol:\ 
set listchars+=trail:\ 
set listchars+=leadmultispace:┊\ \ \ 

" Break line at predefined characters
set linebreak
" Character to show before the lines that have been soft-wrapped
set showbreak=↪\ 


" +-----------------------------------------------+
" |                                               |
" |                AUTO COMPLETION                |
" |                                               |
" +-----------------------------------------------+


set completeopt=menuone,noselect
" hide commplete info under the statusline
set shortmess+=c

function! s:OpenLSPCompletion()
    if v:char =~ '[A-Za-z_.]' && !pumvisible()
        call feedkeys("\<C-x>\<C-o>", "n")
    endif
endfunction

function! s:OpenNoLSPCompletion()
    if v:char =~ '[A-Za-z_]' && !pumvisible()
        call feedkeys("\<C-n>", "n")
    endif
endfunction

function! s:OpenFilePathCompletion()
    if v:char =~ '[/]' && !pumvisible()
        call feedkeys("\<C-x>\<C-f>", "n")
    endif
endfunction

function! s:AutoComplete()
    if has('nvim') && luaeval('#vim.lsp.buf_get_clients()') != 0
        augroup openCompletion
            autocmd! * <buffer>
            autocmd InsertCharPre <buffer> silent! call s:OpenLSPCompletion()
        augroup END
    else
        augroup openCompletion
            autocmd! * <buffer>
            autocmd InsertCharPre <buffer> silent! call s:OpenNoLSPCompletion()
        augroup END
    endif
endfunction

if has('nvim')
    augroup initAutoComplete
        autocmd!
        autocmd BufEnter,LspAttach * call s:AutoComplete()
    augroup END
else
    augroup initAutoComplete
        autocmd!
        autocmd BufEnter * call s:AutoComplete()
    augroup END
endif

augroup openFilePathCompletion
    autocmd!
    autocmd InsertCharPre * silent! call s:OpenFilePathCompletion()
augroup END

" use tab for navigating the autocomplete menu
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use up and down keys for navigating the autocomplete menu
inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"


" +-----------------------------------------------+
" |                                               |
" |     FOLD ACCORDING TO "/" SEARCH PATTERN      |
" |                                               |
" +-----------------------------------------------+


function! s:HasFolds()
    let l:numLines = line('$')
    for l:lineNum in range(1, l:numLines)
        if foldclosed(l:lineNum) != -1
            return 1
        endif
    endfor
    return 0
endfunction

function! s:SearchFoldEpxr()
    if getline(v:lnum) =~ @/
        return 0
    elseif getline(v:lnum-1) =~ @/ || getline(v:lnum+1) =~ @/
        return 1
    else
        return 2
    endif
endfunction

" Folding according to search result
function! s:ToggleSearchFolding()
    if s:HasFolds()
        setlocal foldmethod=syntax foldcolumn=0
        exec "normal! zR"
    else
        setlocal foldexpr=s:SearchFoldEpxr() foldmethod=expr foldlevel=0 foldcolumn=2
        exec "normal! zM"
    endif
endfunction

nnoremap <Space>z :call <SID>ToggleSearchFolding()<CR>


" +-----------------------------------------------+
" |                                               |
" |                 CODE FORMATER                 |
" |                                               |
" +-----------------------------------------------+


function! s:FormatCodes(formatCmd,formatArgs)
    if !executable(a:formatCmd)
        echo ">>  "a:formatCmd. " formater not found"
        return
    endif
    execute "%!".a:formatCmd." ".a:formatArgs
endfunction

augroup codeFormat
    autocmd!
    autocmd Filetype python command! -buffer Format silent! call s:FormatCodes('autopep8','-')
    ""autocmd Filetype c,cpp,objc,objcpp,cuda,proto command! -buffer Format silent! call FormatCodes('clang-format','-style="{IndentWidth: 4}"')
    autocmd Filetype c,cpp,objc,objcpp,cuda,proto,cs,java command! -buffer Format silent! call s:FormatCodes('astyle','--style=google 2>/dev/null')
    autocmd Filetype lua command! -buffer Format silent! execute s:FormatCodes('stylua','- --indent-type Spaces --indent-width 4')
    autocmd Filetype yaml command! -buffer Format execute s:FormatCodes('yamlfmt','--formatter indent=4')
augroup END


" +-----------------------------------------------+
" |                                               |
" |            KEEP NETRW OPEN STATUS             |
" |                                               |
" +-----------------------------------------------+


" netrw settings -----------------------------------------------------------------------------------
" not show the help banner on top
let g:netrw_banner = 0

" make explorer show files like a tree
let g:netrw_liststyle = 3

" see help doc to know more about this global var
let g:netrw_browse_split = 4

" explorer vertical split max win width
let g:max_explore_win_width=35

let g:netrw_dirhistmax = 0

" let g:netrw_bufsettings = 'noma nomod nobl nowrap ro number relativenumber cursorlineopt=number,line'
let g:netrw_bufsettings = 'noma nomod nobl nowrap ro nonumber norelativenumber cursorlineopt=line'

" skip the netrw win when the netrw hidden
function! s:SkipNetrwWin()
    augroup skipNetrwWin
        autocmd!
        autocmd BufEnter NetrwTreeListing wincmd w
    augroup END
endfunction

function! s:GetExploreWinnr()
    let l:expl_win_num = win_id2tabwin(t:netrw_winid)[1]
    if l:expl_win_num <= 1
        return l:expl_win_num
    endif
    let l:filetype = getbufvar(winbufnr(l:expl_win_num), '&filetype')
    if substitute(l:filetype, '\n', '', '') !=# 'netrw'
        return 0
    endif
    return l:expl_win_num
endfunction

" open explorer by specific size
function! s:OpenExplorerOnSize(size)
    let t:win_width=a:size
    exec "Vexplore!"
    exec "vertical resize ".a:size
    setlocal winfixwidth
    let t:netrw_winid = win_getid()
    return winnr()
endfunction

function! s:ToggleExplorer()
    let l:expl_win_num = s:GetExploreWinnr()
    " handling the case where explorer takes up the entire window
    if l:expl_win_num == 1
        enew
        let l:expl_win_num = 0
    endif
    if l:expl_win_num==0
        let t:cur_work_win_num = winnr()
        call s:OpenExplorerOnSize(g:max_explore_win_width)
        if exists('#skipNetrwWin#BufEnter')
            autocmd! skipNetrwWin
        endif
        return
    endif
    " if expl_win_num exists
    " if cursor is not in explorer
    if l:expl_win_num != winnr()
        let t:cur_work_win_num = winnr()
    endif
    " if explorer is not hidden
    if winwidth(l:expl_win_num)!=0
        call s:SkipNetrwWin()
        let t:win_width=0
        exec t:cur_work_win_num."wincmd w"
    else
        let t:win_width=g:max_explore_win_width
        " disable skip netrw win
        if exists('#skipNetrwWin#BufEnter')
            autocmd! skipNetrwWin
        endif
        exec l:expl_win_num."wincmd w"
    endif
    exec "vertical ".l:expl_win_num."resize ".t:win_width
endfunction

function! s:ExploreWhenEnter()
    if !exists('t:netrw_winid')
        let t:netrw_winid=0
    endif
    let l:expl_win_num = s:GetExploreWinnr()
    " handling the case where explorer takes up the entire window
    if l:expl_win_num == 1
        enew
        let l:expl_win_num = 0
    endif
    " if expl_win_num not exists
    if l:expl_win_num == 0
        " record the win num of workspace except explorer where cursor in
        let t:cur_work_win_num = winnr()
        let l:expl_win_num=s:OpenExplorerOnSize(g:max_explore_win_width)
        " handling the case where explorer not takes up the entire window
        exec t:cur_work_win_num."wincmd w"
        " hide the explorer
        exec "vertical ".l:expl_win_num."resize 0"
        call s:SkipNetrwWin()
        return
    endif
    if winwidth(l:expl_win_num)==0
        call s:SkipNetrwWin()
        return
    endif
    if exists('#skipNetrwWin#BufEnter')
        autocmd! skipNetrwWin
        return
    endif
endfunction

function! s:NetrwCd()
    let t:rootDir=netrw#Call('NetrwTreePath', w:netrw_treetop)
    let t:rootDir=substitute(t:rootDir, '.$', '', '')
    echo t:rootDir
endfunction

command! Ncd call s:NetrwCd()

augroup initExplore
    autocmd!
    autocmd TabEnter,VimEnter * call s:ExploreWhenEnter()
augroup END

nnoremap <silent><Space>e :call <SID>ToggleExplorer()<CR>


" +-----------------------------------------------+
" |                                               |
" |     REDIRECT CMD OUTPUT AND SELF-QUICKFIX     |
" |                                               |
" +-----------------------------------------------+


function! s:RedirCdWithPathString(path)
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

function! s:RedirCdWithNetrw()
    if &filetype !=# 'netrw'
        echo ">> Not in netrw window!"
        return
    endif
    let t:rootDir=netrw#Call('NetrwTreePath', w:netrw_treetop)
    let t:rootDir=substitute(t:rootDir, '.$', '', '')
    exec 'tc '.t:rootDir
    echo t:rootDir
endfunction

function! s:RedirCd(path)
    if empty(a:path)
        call s:RedirCdWithNetrw()
        return
    endif
    call s:RedirCdWithPathString(a:path)
endfunction

function! s:ShowRootDir()
    echo t:rootDir
endfunction

function! s:OpenRedirWindow()
    if win_id2tabwin(t:redirWinid)[1] != 0
        call win_gotoid(t:redirWinid)
        return
    end
    let t:redirPreviewWinid = win_getid()
    bot 10new
    let t:redirWinid = win_getid()
endfunction

function! s:QuitRedirWindow()
    if win_id2tabwin(t:redirWinid)[1] != 0
        call win_execute(t:redirWinid, 'close')
        return
    end
    echo ">> No OpenRedirWindow!"
endfunction

function! s:JumpWhenPressEnter(locateTargetFunctionName)
    let t:redirLocateTarget=getline('.')
    if win_id2tabwin(t:redirPreviewWinid)[1] == 0
        top new
        let t:redirPreviewWinid = win_getid()
    else
        call win_gotoid(t:redirPreviewWinid)
    endif
    call function(a:locateTargetFunctionName)()
endfunction

function! s:JumpWhenPressJOrK(direction,locateTargetFunctionName)
    exec "normal! ".a:direction
    let t:redirLocateTarget=getline('.')
    if win_id2tabwin(t:redirPreviewWinid)[1] == 0
        top new
        let t:redirPreviewWinid = win_getid()
        wincmd p
    endif
    call win_execute(t:redirPreviewWinid, "call ".a:locateTargetFunctionName."()")
endfunction

nnoremap <silent><Space>q :call <SID>QuitRedirWindow()<CR>

command! Rpwd call s:ShowRootDir()
command! -nargs=? Rcd call s:RedirCd(<q-args>)

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

hi def link RedirFocusCurMatch DiffChange

" exec "source ".g:config_path."/vim/redir/buffer-list.vim"
" exec "source ".g:config_path."/vim/redir/file-search.vim"
" exec "source ".g:config_path."/vim/redir/word-search.vim"
" exec "source ".g:config_path."/vim/redir/quickfix.vim"


" +-----------------------------------------------+
" |                                               |
" |             BUFFER LIST REDIRECT              |
" |                                               |
" +-----------------------------------------------+


" Go to the buffer on line
function! s:BufferListLocateTarget()
    let l:bufNum=split(t:redirLocateTarget,"\ ")[0]
    try
        exec "buffer".l:bufNum
    catch
        echo ">> Buffer Not Exist!"
    endtry
endfunction

" redirect the command output to a buffer
function! s:BufferListRedir()
    call s:OpenRedirWindow()
    exec "edit BufferList".tabpagenr()
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile cursorline filetype=redirWindows
    silent! put = execute('buffers')
    exec "normal! gg"
    while getline('.') == ""
        exec "normal! dd"
    endwhile
    call s:BufferListJumpMap()
endfunction

" autocmd to jump to buffer with CR only in BufferList buffer
function! s:BufferListJumpMap()
    nnoremap <buffer><silent><CR> :call <SID>JumpWhenPressEnter('s:BufferListLocateTarget')<CR>
    nnoremap <buffer><silent>j :call <SID>JumpWhenPressJOrK('+', 's:BufferListLocateTarget')<CR>
    nnoremap <buffer><silent>k :call <SID>JumpWhenPressJOrK('-', 's:BufferListLocateTarget')<CR>
endfunction

nnoremap <silent><Space>l :call <SID>BufferListRedir()<CR>


" +-----------------------------------------------+
" |                                               |
" |    FUZZY FILE SEARCH WITH RIPGREP REDIRECT    |
" |                                               |
" +-----------------------------------------------+


" Fuzzy Match filenames -----------------------------------------------------------------------------
function! s:FileSearchLocateTarget()
    if filereadable(t:redirLocateTarget)
        exec "edit ".t:redirLocateTarget
    else
        echo ">> File Not Exist!"
    endif
endfunction

" redirect the command output to a buffer
function! s:FileSearchRedir(cmd)
    call s:OpenRedirWindow()
    exec "edit FuzzyFilenameSearch".tabpagenr()."\ ->\ ".t:fileSubStr
    exec "read ".a:cmd
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile cursorline filetype=redirWindows
    call s:FileSearchJumpMap()
endfunction

" Show Files fuzzily searched with git
function! s:FileSearchWithGit(substr)
    let t:fileSubStr=a:substr
    exec "tc ".t:rootDir
    exec "FileSearchRedir !rg --files \| rg --ignore-case ".a:substr
    exec "normal! gg"
    if getline('.') == ""
        exec "normal! dd"
    endif
    exec "%s/^/".escape(t:rootDir.'/','/')
    echo t:rootDir
endfunction

" Show Files searched fuzzily without git
function! s:FileSearchWithoutGit(substr)
    let t:fileSubStr=a:substr
    exec "tc ".t:rootDir
    exec "FileSearchRedir !rg --no-ignore --files \| rg --ignore-case ".a:substr
    exec "normal! gg"
    if getline('.') == ""
        exec "normal! dd"
    endif
    exec "%s/^/".escape(t:rootDir.'/','/')
    echo t:rootDir
endfunction

" autocmd to jump to file with CR only in FuzzyFilenameSearch buffer
function! s:FileSearchJumpMap()
    nnoremap <buffer><silent><CR> :call <SID>JumpWhenPressEnter('s:FileSearchLocateTarget')<CR>
    nnoremap <buffer><silent>j :call <SID>JumpWhenPressJOrK('+', 's:FileSearchLocateTarget')<CR>
    nnoremap <buffer><silent>k :call <SID>JumpWhenPressJOrK('-', 's:FileSearchLocateTarget')<CR>
endfunction

command! -nargs=1 -complete=command FileSearchRedir silent! call s:FileSearchRedir(<q-args>)

" Fg means 'file git', search file names fuzzily with git
command! -nargs=1 -complete=command Fg call s:FileSearchWithGit(<q-args>)

" Fs means 'file search', search file names fuzzily
command! -nargs=1 -complete=command Fs call s:FileSearchWithoutGit(<q-args>)


" +-----------------------------------------------+
" |                                               |
" |    FUZZY WORD SEARCH WITH RIPGREP REDIRECT    |
" |                                               |
" +-----------------------------------------------+


function! s:LegalLocationsInUnix()
    let l:location = split(t:redirLocateTarget, ":")
    " return path, row, column
    return [l:location[0], l:location[1], l:location[2]]
endfunction

function! s:LegalLocationsInWindows()
    let l:location = split(t:redirLocateTarget, ":")
    " return path, row, column
    let l:path = substitute(l:location[0].":".l:location[1], '\\\\', '/', 'g')
    let l:path = substitute(l:path, '\\', '/', 'g')
    return [l:path, l:location[2], l:location[3]]
endfunction

if has('win32') || has('win64') || has('win32unix')
    let s:LegalLocations=function('s:LegalLocationsInWindows')
else
    let s:LegalLocations=function('s:LegalLocationsInUnix')
endif

" Global Fuzzy Match words -------------------------------------------------------------------------
function! s:WordSearchLocateTarget()
    try
        let l:location=s:LegalLocations()
        let l:path=l:location[0]
        let l:row=l:location[1]
        let l:column=l:location[2]
        if expand("%:p")!=#l:path
            exec "edit ".l:path
        endif
        cal cursor(l:row, l:column)
        normal! zz
        call matchadd('RedirFocusCurMatch', '\c\%#'.t:rgrepSubStr)
    catch
        echo ">> File Not Exist!"
    endtry
endfunction

" redirect the command output to a buffer
function! s:WordSearchRedir(cmd)
    call s:OpenRedirWindow()
    exec "edit RipgrepWordSearch".tabpagenr()."\ ->\ ".t:rgrepSubStr
    exec "read "a:cmd
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile cursorline filetype=redirWindows
    call s:WordSearchJumpMap()
endfunction

" Show Words fuzzily searched with git
function! s:WordSearchWithGit(substr)
    let t:rgrepSubStr=a:substr
    let l:rgArgs="--ignore-case --vimgrep --no-heading"
    exec "tc ".t:rootDir
    exec "WordSearchRedir !rg ".l:rgArgs." ".a:substr." ".t:rootDir
    exec "normal! gg"
    if getline('.') == ""
        exec "normal! dd"
    endif
    echo t:rootDir
endfunction

" Show Files fuzzily searched without git
function! s:WordSearchWithoutGit(substr)
    let t:rgrepSubStr=a:substr
    let l:rgArgs="--ignore-case --vimgrep --no-heading --no-ignore"
    exec "tc ".t:rootDir
    exec "WordSearchRedir !rg ".l:rgArgs." ".a:substr." ".t:rootDir
    exec "normal! gg"
    if getline('.') == ""
        exec "normal! dd"
    endif
    echo t:rootDir
endfunction

" autocmd to jump to file with CR only in RipgrepWordSearch buffer
function! s:WordSearchJumpMap()
    nnoremap <buffer><silent><CR> :call <SID>JumpWhenPressEnter('s:WordSearchLocateTarget')<CR>
    nnoremap <buffer><silent>j :call <SID>JumpWhenPressJOrK('+', 's:WordSearchLocateTarget')<CR>
    nnoremap <buffer><silent>k :call <SID>JumpWhenPressJOrK('-', 's:WordSearchLocateTarget')<CR>
endfunction

command! -nargs=1 -complete=command WordSearchRedir silent! call s:WordSearchRedir(<q-args>)

" Wg means 'word git', search file fuzzily names with git
command! -nargs=1 -complete=command Wg call s:WordSearchWithGit(<q-args>)

" Ws means 'word search', search file fuzzily names without git
command! -nargs=1 -complete=command Ws call s:WordSearchWithoutGit(<q-args>)


" +-----------------------------------------------+
" |                                               |
" |  COMBINE QUICKFIX SHORTCUT WITH REDIRECT SYS  |
" |                                               |
" +-----------------------------------------------+


function! s:PrepareForQuickfix()
    let l:cur_win_id=win_getid()
    if win_id2tabwin(t:redirWinid)[1] != 0 && t:redirWinid != l:cur_win_id
        call win_execute(t:redirWinid, 'close')
    end
    let t:redirPreviewWinid=win_getid(winnr('#'),tabpagenr())
    let t:redirWinid = l:cur_win_id
    bo wincmd J
    resize 10
    setlocal bufhidden=wipe nobuflisted noswapfile nocursorline
endfunction

augroup quickFixPreparation
    autocmd!
    autocmd FileType qf call s:PrepareForQuickfix()
    autocmd FileType qf nnoremap <buffer> j j<CR>zz<C-w>p
    autocmd FileType qf nnoremap <buffer> k k<CR>zz<C-w>p
augroup END


" +-----------------------------------------------+
" |                                               |
" |      COPY OF ojroques/vim-oscyank GITHUB      |
" |                                               |
" +-----------------------------------------------+


" -------------------- VARIABLES ---------------------------
let s:yank_commands = {
  \ 'operator': {'block': '`[\<C-v>`]y', 'char': '`[v`]y', 'line': "'[V']y"},
  \ 'visual': {'': 'gvy', 'V': 'gvy', 'v': 'gvy'}}
let s:b64_table = [
  \ 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
  \ 'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
  \ 'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
  \ 'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/']

" -------------------- OPTIONS ---------------------------
function s:options_max_length()
  return get(g:, 'oscyank_max_length', 0)
endfunction

function s:options_silent()
  return get(g:, 'oscyank_silent', 0)
endfunction

function s:options_trim()
  return get(g:, 'oscyank_trim', 0)
endfunction

function s:options_osc52()
  return get(g:, 'oscyank_osc52', "\x1b]52;c;%s\x07")
endfunction

" -------------------- UTILS -------------------------------
function s:echo(text, hl)
  echohl a:hl
  echo printf('[oscyank] %s', a:text)
  echohl None
endfunction

function s:encode_b64(str, size)
  let l:bytes = map(range(len(a:str)), 'char2nr(a:str[v:val])')
  let l:b64 = []

  for i in range(0, len(l:bytes) - 1, 3)
    let n = l:bytes[i] * 0x10000
          \ + get(l:bytes, i + 1, 0) * 0x100
          \ + get(l:bytes, i + 2, 0)
    call add(l:b64, s:b64_table[n / 0x40000])
    call add(l:b64, s:b64_table[n / 0x1000 % 0x40])
    call add(l:b64, s:b64_table[n / 0x40 % 0x40])
    call add(l:b64, s:b64_table[n % 0x40])
  endfor

  if len(l:bytes) % 3 == 1
    let l:b64[-1] = '='
    let l:b64[-2] = '='
  endif

  if len(l:bytes) % 3 == 2
    let l:b64[-1] = '='
  endif

  let l:b64 = join(l:b64, '')
  if a:size <= 0
    return l:b64
  endif

  let l:chunked = ''
  while strlen(l:b64) > 0
    let l:chunked .= strpart(l:b64, 0, a:size) . "\n"
    let l:b64 = strpart(l:b64, a:size)
  endwhile

  return l:chunked
endfunction

function s:get_text(mode, type)
  " Save user settings
  let l:clipboard = &clipboard
  let l:selection = &selection
  let l:register = getreg('"')
  let l:visual_marks = [getpos("'<"), getpos("'>")]

  " Retrieve text
  set clipboard=
  set selection=inclusive
  silent execute printf('keepjumps normal! %s', s:yank_commands[a:mode][a:type])
  let l:text = getreg('"')

  " Restore user settings
  let &clipboard = l:clipboard
  let &selection = l:selection
  call setreg('"', l:register)
  call setpos("'<", l:visual_marks[0])
  call setpos("'>", l:visual_marks[1])

  return l:text
endfunction

function s:trim_text(text)
  let l:text = a:text
  let l:indent = matchstrpos(l:text, '^\s\+')

  " Remove common indent from all lines
  if l:indent[1] >= 0
    let l:pattern = printf('\n%s', repeat('\s', l:indent[2] - l:indent[1]))
    let l:text = substitute(l:text, l:pattern, '\n', 'g')
  endif

  return trim(l:text)
endfunction

function s:write(osc52)
  if filewritable('/dev/fd/2') == 1
    let l:success = writefile([a:osc52], '/dev/fd/2', 'b') == 0
  elseif has('nvim')
    let l:success = chansend(v:stderr, a:osc52) > 0
  else
    exec("silent! !echo " . shellescape(a:osc52))
    redraw!
    let l:success = 1
  endif
  return l:success
endfunction

" -------------------- PUBLIC ------------------------------
function! s:OSCYank(text) abort
  let l:text = s:options_trim() ? s:trim_text(a:text) : a:text

  if s:options_max_length() > 0 && strlen(l:text) > s:options_max_length()
    call s:echo(printf('Selection is too big: length is %d, limit is %d', strlen(l:text), s:options_max_length()), 'WarningMsg')
    return
  endif

  let l:text_b64 = s:encode_b64(l:text, 0)
  let l:osc52 = printf(s:options_osc52(), l:text_b64)
  let l:success = s:write(l:osc52)

  if !l:success
    call s:echo('Failed to copy selection', 'ErrorMsg')
  elseif !s:options_silent()
    call s:echo(printf('%d characters copied', strlen(l:text)), 'Normal')
  endif

  return l:success
endfunction

function! s:OSCYankOperatorCallback(type) abort
  let l:text = s:get_text('operator', a:type)
  return s:OSCYank(l:text)
endfunction

function! s:OSCYankOperator() abort
  set operatorfunc=s:OSCYankOperatorCallback
  return 'g@'
endfunction

function! s:OSCYankVisual() abort
  let l:text = s:get_text('visual', visualmode())
  return s:OSCYank(l:text)
endfunction

function! s:OSCYankRegister(register) abort
  let l:text = getreg(a:register)
  return s:OSCYank(l:text)
endfunction

nnoremap <silent><expr> Y <SID>OSCYankOperator().'_'
vnoremap <silent>Y :<C-u>call <SID>OSCYankVisual()<CR>
command! -register OSCYankRegister call s:OSCYankRegister('<reg>')


" +-----------------------------------------------+
" |                                               |
" |         LOAD LANGUAGE SERVER (NEOVIM)         |
" |                                               |
" +-----------------------------------------------+


" let g:config_path=expand("<sfile>:p:h")
" exec "source ".g:config_path."/lsp.lua"

set tabstop=4
set shiftwidth=4
set autoindent
set incsearch
set ignorecase
set smartcase
set hlsearch

nmap \q :nohlsearch<CR>

au BufRead,BufNewFile *.go set filetype=go

let g:gofmt_command="goimports"
filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on
syntax on

function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf 
endfunction

nmap <silent> <leader>mw :call MarkWindowSwap()<CR>
nmap <silent> <leader>pw :call DoWindowSwap()<CR>

set showcmd

command Gb !go build -v
command Gf !go fmt
ca gb Gb
ca gf Gf
au BufWritePost *.go !gofmt -w %

set path +=~/mygo/src/**
set path +=~/go/src/pkg/**

command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
    echo a:cmdline
    let expanded_cmdline = a:cmdline
    for part in split(a:cmdline, ' ')
        if part[0] =~ '\v[%#<]'
            let expanded_part = fnameescape(expand(part))
            let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
        endif
    endfor
    botright new
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    call setline(1, 'You entered:    ' . a:cmdline)
    call setline(2, 'Expanded Form:  ' .expanded_cmdline)
    call setline(3,substitute(getline(2),'.','=','g'))
    execute '$read !'. expanded_cmdline
    setlocal nomodifiable
    1
endfunction

# fzf.vim
```
nnoremap T :call fzf#Fzf(1)<cr>
nnoremap H :call fzf#Fzf(0)<cr>

command! -nargs=? R call fzf#Rg(<q-args>)
```

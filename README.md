# fzf.vim
```
nnoremap - :call fzf#Fzf()<cr>
  "let scope = getchar()
  "let type = getchar()

  "scope:
    1: current directory
    2: project directory
    3: workbase directory

  "type
    1: vsplit
    2: tabe
    3: edit

command! -nargs=? R call fzf#Rg(<q-args>)
```

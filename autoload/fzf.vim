function s:findRoot()
  if @%[0:3] != 'term' | execute 'lcd '.expand('%:p:h') | endif
  return v:shell_error != 0 ? "." : substitute(system('git rev-parse --show-toplevel'), '\n*$', '', 'g')
endfunction

function Open(...)
  let path = getline(1)
  silent close

  if filereadable(path)
    execute s:type.' '.path
  endif
  if isdirectory(path)
    execute 'lcd '.path
    if s:type == 'edit'
      execute 'term'
    else
      execute s:type.' +term'
    endif
  endif
endfunction

function! fzf#Fzf()
  let cmd = get({
\   49: 'fd "" "' .expand('%:p:h'). '" -t f | fzf',
\   50: 'fd "" "' .s:findRoot(). '" -t f | fzf',
\   51: 'fd "" "/Users/zhaoyang/yy" -d 2 | fzf'
\ }, getchar())

  let s:type = get({
\   49: 'edit',
\   50: 'vsplit',
\   51: 'tabe'
\ }, getchar())

  keepalt below 10 new
  call termopen(cmd, {'on_exit': 'Open'})
  startinsert
endfunction

function! fzf#Rg(p)
  execute 'lcd '.s:findRoot()
  let list = split(system('rg -l '.a:p))
  let len = len(list)
  execute 'below '.len.' new'

  let i = 0
  while i < len
    call setline(i + 1, list[i])
    let i += 1
  endwhile

  nmap <buffer> <cr> <c-w>vgf
endfunction

function s:findRoot()
  if @%[0:3] != 'term' | execute 'lcd '.expand('%:p:h') | endif
  return v:shell_error != 0 ? "." : substitute(system('git rev-parse --show-toplevel'), '\n*$', '', 'g')
endfunction

function Open(...)
  if len(a:000) == 0
    let path = getline('.')
  else
    let path = getline(1)
    silent close
  endif

  if filereadable(path)
    execute 'vsplit '.path
  endif
  if isdirectory(path)
    execute 'lcd '.path
    execute 'vsplit +term'
  endif
endfunction

function! fzf#Fzf(type)
  let cmd = get({
\   0: 'fd "" "' .expand('%:p:h'). '" -t f | fzf',
\   1: 'fd "" "' .s:findRoot(). '" -t f | fzf',
\   2: 'fd "" "/Users/zhaoyang/yy" -d 2 | fzf'
\ }, a:type)

  keepalt below 30 new
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

  nmap <buffer> <cr> :call Open()<cr>
endfunction

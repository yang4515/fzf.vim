function s:findRoot()
  let result = system('git rev-parse --show-toplevel')
  if v:shell_error == 0
    return substitute(result, '\n*$', '', 'g')
  endif

  return "."
endfunction

function OpenFile(...)
  "let root = getcwd()
  let root = s:findRoot()

  if (a:1 != 'rg')
    let path = getline(1)
    silent close
  else
    let path = getline('.')
  endif

  let full_path = root.'/'.path
  if filereadable(full_path)
    execute 'wincmd w'
    execute 'vsplit '.full_path
  endif
endfunction

function! fzf#Rg(p)
  let root = s:findRoot()
  execute 'lcd '.root
  let res = system('rg -l '.a:p)
  let list = split(res)
  let len = len(list)

  execute 'below '.len.' new'
  setlocal buftype=nofile

  let i = 0
  while i < len
    call setline(i + 1, list[i])
    let i += 1
  endwhile

  nmap <buffer> <cr> :call OpenFile('rg')<cr>
endfunction

function! fzf#Fzf(fromRoot)
  keepalt below 30 new

  if (a:fromRoot == 1)
    let root = s:findRoot()
    execute 'lcd '.root
  endif

  let options = {'on_exit': 'OpenFile'}
  call termopen('fd -t f | fzf', options)
  startinsert
endfunction

function! fzf#History()
  keepalt below 100 new

  let list = v:oldfiles
  let options = {'on_exit': 'OpenFile'}
  call termopen('echo "' . join(list, '\n') . '" | fzf', options)
  startinsert
endfunction

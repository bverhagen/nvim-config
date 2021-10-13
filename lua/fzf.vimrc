" If fzf.vim from the fzf installation/package (not from the fzf.vim plugin)
" is not found, add it to the runtime path by uncommenting the following line
" set rtp+=/home/bart/workspace/fzf

" Search in the current directory
nnoremap <leader>p :Files<CR>
nnoremap <leader>g :GFiles<CR>

" Open recently used files
nnoremap <leader>m :History<CR>

" Search in files
nnoremap <leader>s :Rg<CR>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

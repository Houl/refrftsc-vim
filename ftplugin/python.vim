" Vim filetype plugin file
" Language:	python
" Maintainer:	Tom Picton <tom@tompicton.co.uk>
" Previous Maintainer: James Sully <sullyj3@gmail.com>
" Previous Maintainer: Johannes Zellner <johannes@zellner.org>
" Last Change:	Fri, 20 October 2017
" https://github.com/tpict/vim-ftplugin-python

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1
let s:keepcpo= &cpo
set cpo&vim

setlocal cinkeys-=0#
setlocal indentkeys-=0#
setlocal include=^\\s*\\(from\\\|import\\)
setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal suffixesadd=.py
setlocal comments=b:#,fb:-
setlocal commentstring=#\ %s

setlocal omnifunc=pythoncomplete#Complete

set wildignore+=*.pyc

let b:next_toplevel='\v%$\|^(class\|def\|async def)>'
let b:prev_toplevel='\v^(class\|def\|async def)>'
let b:next_endtoplevel='\v%$\|\S.*\n+(def\|class)'
let b:prev_endtoplevel='\v\S.*\n+(def\|class)'
let b:next='\v%$\|^\s*(class\|def\|async def)>'
let b:prev='\v^\s*(class\|def\|async def)>'
let b:next_end='\v\S\n*(%$\|^\s*(class\|def\|async def)\|^\S)'
let b:prev_end='\v\S\n*(^\s*(class\|def\|async def)\|^\S)'

" new: changed left-hand-sides into global <SID> mappings
execute "nnoremap <silent> <SID>(]]) :<C-U>call <SID>Python_jump('n', '". b:next_toplevel."', 'W')<cr>"
execute "nnoremap <silent> <SID>([[) :<C-U>call <SID>Python_jump('n', '". b:prev_toplevel."', 'Wb')<cr>"
execute "nnoremap <silent> <SID>(][) :<C-U>call <SID>Python_jump('n', '". b:next_endtoplevel."', 'W', 0)<cr>"
execute "nnoremap <silent> <SID>([]) :<C-U>call <SID>Python_jump('n', '". b:prev_endtoplevel."', 'Wb', 0)<cr>"
execute "nnoremap <silent> <SID>(]m) :<C-U>call <SID>Python_jump('n', '". b:next."', 'W')<cr>"
execute "nnoremap <silent> <SID>([m) :<C-U>call <SID>Python_jump('n', '". b:prev."', 'Wb')<cr>"
execute "nnoremap <silent> <SID>(]M) :<C-U>call <SID>Python_jump('n', '". b:next_end."', 'W', 0)<cr>"
execute "nnoremap <silent> <SID>([M) :<C-U>call <SID>Python_jump('n', '". b:prev_end."', 'Wb', 0)<cr>"

execute "onoremap <silent> <SID>(]]) :<C-U>call <SID>Python_jump('o', '". b:next_toplevel."', 'W')<cr>"
execute "onoremap <silent> <SID>([[) :<C-U>call <SID>Python_jump('o', '". b:prev_toplevel."', 'Wb')<cr>"
execute "onoremap <silent> <SID>(][) :<C-U>call <SID>Python_jump('o', '". b:next_endtoplevel."', 'W', 0)<cr>"
execute "onoremap <silent> <SID>([]) :<C-U>call <SID>Python_jump('o', '". b:prev_endtoplevel."', 'Wb', 0)<cr>"
execute "onoremap <silent> <SID>(]m) :<C-U>call <SID>Python_jump('o', '". b:next."', 'W')<cr>"
execute "onoremap <silent> <SID>([m) :<C-U>call <SID>Python_jump('o', '". b:prev."', 'Wb')<cr>"
execute "onoremap <silent> <SID>(]M) :<C-U>call <SID>Python_jump('o', '". b:next_end."', 'W', 0)<cr>"
execute "onoremap <silent> <SID>([M) :<C-U>call <SID>Python_jump('o', '". b:prev_end."', 'Wb', 0)<cr>"

execute "xnoremap <silent> <SID>(]]) :<C-U>call <SID>Python_jump('x', '". b:next_toplevel."', 'W')<cr>"
execute "xnoremap <silent> <SID>([[) :<C-U>call <SID>Python_jump('x', '". b:prev_toplevel."', 'Wb')<cr>"
execute "xnoremap <silent> <SID>(][) :<C-U>call <SID>Python_jump('x', '". b:next_endtoplevel."', 'W', 0)<cr>"
execute "xnoremap <silent> <SID>([]) :<C-U>call <SID>Python_jump('x', '". b:prev_endtoplevel."', 'Wb', 0)<cr>"
execute "xnoremap <silent> <SID>(]m) :<C-U>call <SID>Python_jump('x', '". b:next."', 'W')<cr>"
execute "xnoremap <silent> <SID>([m) :<C-U>call <SID>Python_jump('x', '". b:prev."', 'Wb')<cr>"
execute "xnoremap <silent> <SID>(]M) :<C-U>call <SID>Python_jump('x', '". b:next_end."', 'W', 0)<cr>"
execute "xnoremap <silent> <SID>([M) :<C-U>call <SID>Python_jump('x', '". b:prev_end."', 'Wb', 0)<cr>"

" added these interface <Plug> mappings:
map <buffer> <Plug>]]-motion <SID>(]])
map <buffer> <Plug>[[-motion <SID>([[)
map <buffer> <Plug>][-motion <SID>(][)
map <buffer> <Plug>[]-motion <SID>([])
map <buffer> <Plug>]m-motion <SID>(]m)
map <buffer> <Plug>[m-motion <SID>([m)
map <buffer> <Plug>]M-motion <SID>(]M)
map <buffer> <Plug>[M-motion <SID>([M)

" added new conventional variable to still have default mappings:
if !exists("g:no_bracket_maps") || !g:no_bracket_maps
    map <buffer> ]] <Plug>]]-motion|sunmap <buffer> ]]
    map <buffer> [[ <Plug>[[-motion|sunmap <buffer> [[
    map <buffer> ][ <Plug>][-motion|sunmap <buffer> ][
    map <buffer> [] <Plug>[]-motion|sunmap <buffer> []
    map <buffer> ]m <Plug>]m-motion|sunmap <buffer> ]m
    map <buffer> [m <Plug>[m-motion|sunmap <buffer> [m
    map <buffer> ]M <Plug>]M-motion|sunmap <buffer> ]M
    map <buffer> [M <Plug>[M-motion|sunmap <buffer> [M

    " b:undo_ftplugin was missing at all:
    let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin.'|' : '').
	\ 'unmap <buffer> ]]|unmap <buffer> [[|unmap <buffer> ][|unmap <buffer> []|unmap <buffer> ]m|unmap <buffer> [m|unmap <buffer> ]M|unmap <buffer> [M'
endif

if !exists('*<SID>Python_jump')
  fun! <SID>Python_jump(mode, motion, flags, ...) range
      let l:startofline = (a:0 >= 1) ? a:1 : 1
      let cnt = v:count1
      " put count check before first :normal

      if a:mode == 'x'
          normal! gv
      endif

      if l:startofline == 1
          normal! 0
      endif

      mark '
      while cnt > 0
          call search(a:motion, a:flags)
          let cnt = cnt - 1
      endwhile

      if l:startofline == 1
          normal! ^
      endif
  endfun
endif

if has("browsefilter") && !exists("b:browsefilter")
    let b:browsefilter = "Python Files (*.py)\t*.py\n" .
                \ "All Files (*.*)\t*.*\n"
endif

if !exists("g:python_recommended_style") || g:python_recommended_style != 0
    " As suggested by PEP8.
    setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8
endif

" First time: try finding "pydoc".
if !exists('g:pydoc_executable')
    if executable('pydoc')
        let g:pydoc_executable = 1
    else
        let g:pydoc_executable = 0
    endif
endif
" If "pydoc" was found use it for keywordprg.
if g:pydoc_executable
    setlocal keywordprg=pydoc
endif

let &cpo = s:keepcpo
unlet s:keepcpo

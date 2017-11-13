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

exec motpat#Map(1, '<SID>([[)', '<SID>(]])', '^\%(class\|def\|async def\)\>\|\%$')
exec motpat#Map(1, '<SID>([])', '<SID>(][)', '^.*\n\%(class\|def\|async def\)\>\|\%$', 'l')
exec motpat#Map(1, '<SID>([m)', '<SID>(]m)', '^\s*\%(class\|def\|async def\)\>\|\%$')
exec motpat#Map(1, '<SID>([M)', '<SID>(]M)', '\%(^.*\n\s*\%(class\|def\|async def\)\>\|^\S\|\%$\)', 'l')

" added these interface <Plug> mappings:
map <buffer> <Plug>]]-motion <SID>(]])
map <buffer> <Plug>[[-motion <SID>([[)
map <buffer> <Plug>][-motion <SID>(][)
map <buffer> <Plug>[]-motion <SID>([])
map <buffer> <Plug>]m-motion <SID>(]m)
map <buffer> <Plug>[m-motion <SID>([m)
map <buffer> <Plug>]M-motion <SID>(]M)
map <buffer> <Plug>[M-motion <SID>([M)

if (!exists("g:no_plugin_maps") || !g:no_plugin_maps) && (!exists("g:no_python_maps") || !g:no_python_maps)
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

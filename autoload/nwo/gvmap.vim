" Vim autoload script - make a mapping work in several modes
" File:         gvmap.vim
" Created:      2009 Apr 27
" Last Change:  2017 Nov 10
" Version:      0.18
" Author:	Andy Wokula <anwoku@yahoo.de>
" License:	Vim License, see :h license

if v:version >= 702

    func! nwo#gvmap#mode(...) "{{{
	let s:lastmode = mode(1)
	let s:count = v:count >= 1 ? v:count : ""
	if a:0 == 0 || s:lastmode !=# "no"
	    return ":"
	elseif a:1 ==# "i"
	    return 'v:'
	elseif a:1 ==# "l"
	    return 'V:'
	endif
	echomsg "nwo#gvmap#mode(): invalid argument:" a:1
	return ":"
    endfunc "}}}

else
    " v:version < 702
    " E118: Too many arguments for function: mode

    func! nwo#gvmap#mode(...) "{{{
	let s:lastmode = mode()
	let s:count = v:count >= 1 ? v:count : ""
	return ":"
    endfunc "}}}

endif

func! nwo#gvmap#bmode(...) "{{{
    let s:lastmode = mode()
    return a:0==0 ? "\<C-\>\<C-N>:" : a:1.":"
endfunc "}}}


func! nwo#gvmap#vrestore() "{{{
    if exists("s:lastmode")
	let lmode = s:lastmode
	if s:lastmode =~# "^i\\=[vV\<C-V>]"
	    normal! gv
	endif
	unlet s:lastmode
	return lmode
    endif
    return ""
endfunc "}}}

func! nwo#gvmap#count() "{{{
    return s:count
endfunc "}}}

func! nwo#gvmap#lastmode() "{{{
    if exists("s:lastmode")
	return s:lastmode
    else
	return ""
    endif
endfunc "}}}

func! nwo#gvmap#wasvisual() "{{{
    if exists("s:lastmode")
	return s:lastmode =~ "[vV\<C-V>]"
    else
	return 0
    endif
endfunc "}}}


func! nwo#gvmap#finish() "{{{
    unlet! s:lastmode
endfunc "}}}


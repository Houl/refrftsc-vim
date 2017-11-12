" Vim autoload script - create motion mappings defined by a pattern
" File:		motpat.vim   (motion pattern . vim)
" Created:	2009 Dec 02
" Last Change:	2017 Nov 10
" Version: 	0.22
" Author:	Andy Wokula <anwoku@yahoo.de>
" License:	Vim License, see :h license

let s:cpo_save = &cpo
set cpo&vim

nmap <SID> <SID>
let s:SID = maparg("<SID>")
nunmap <SID>

if !exists("g:motpat_silent")
    let g:motpat_silent = &shortmess =~# 's'
endif

if !exists("g:motpat_foldopen")
    let g:motpat_foldopen = &foldopen =~# 'block'
endif

let g:motpat_errmsg = ''

func! motpat#Map(buflocal, lhsback, lhsforw, rhspat, ...) "{{{
    let margs = s:Margs(a:buflocal, a:rhspat, get(a:, 1, "e"))
    return s:JoinCmds(
	\call('s:MapOne', [a:lhsforw, '/'], margs)+
	\call('s:MapOne', [a:lhsback, '?'], margs))
endfunc "}}}

func! motpat#Fmap(buflocal, lhs, rhspat, ...) "{{{
    let margs = s:Margs(a:buflocal, a:rhspat, get(a:, 1, "e"))
    return s:JoinCmds(call('s:MapOne', [a:lhs, '/'], margs))
endfunc "}}}

func! motpat#Bmap(buflocal, lhs, rhspat, ...) "{{{
    let margs = s:Margs(a:buflocal, a:rhspat, get(a:, 1, "e"))
    return s:JoinCmds(call('s:MapOne', [a:lhs, '?'], margs))
endfunc "}}}

func! motpat#Foldopen() "{{{
    return nwo#var#WBG('motpat_foldopen')
endfunc "}}}

func! s:Margs(buflocal, rhspat, flags) "{{{
    let bufmod = a:buflocal ? "<buffer>" : ""
    let isexpr = stridx(a:flags, '=') >= 0
    let mfl = isexpr ? "=" : "'"
    let mov = get(s:mov_eil, matchstr(a:flags, '[eil]'), s:SID."(motpat)e"). mfl
    let cpat = isexpr ? s:Mapesc(a:rhspat) : s:InstrMapesc(a:rhspat)
    let cr = s:SID. mfl. "<CR>"
    return copy(l:)
endfunc "}}}

" exclusive, inclusive or linewise
let s:mov_eil = {"e": s:SID."(motpat)e", "i": s:SID."(motpat)i", "l": s:SID."(motpat)l"}

func! s:MapOne(lhs, scmd) dict "{{{
    if a:lhs == ""
	return []
    endif
    let scpat = (self.isexpr ? string(a:scmd). '.' : a:scmd). self.cpat
    return [
	\printf("noremap <script><silent>%s %s %s%s%s", self.bufmod, a:lhs, self.mov, scpat, self.cr),
	\printf("sunmap %s %s", self.bufmod, a:lhs)]
endfunc "}}}
" cinqpat - command plus inner quote pattern

func! s:JoinCmds(bar_cmds) "{{{
    return join(a:bar_cmds, '|')
endfunc "}}}

func! s:InstrMapesc(str) "{{{
    return string(s:Mapesc(a:str))[1:-2]
endfunc "}}}
" InQu = withIn Quotes = prepare for use in quotes = double the quotes
" InstrMapesc = InQu . s:Mapesc

" Escaping: escaped string will occur first in a mapping, then after a
" search command "/" or "?" (or in a search() argument)
" - mapping: turn chars into key codes: "|" and "<"
" - mapping & search cmd: turn some control chars into a pattern: \r \n \e
" - other control chars: escape with <C-V>; special case ^V (one character),
"   bad: <C-V>^V (^V after :map escapes what follows), good: <C-V><C-V>
" escape table:
let s:esctbl = {"|": "<Bar>", "<": "<lt>",
    \ "\r": '\r', "\n": '\n', "\e": '\e', "\t": '\t',
    \ "\<C-V>": "<C-V><C-V>"}
let s:escpat = '[|<[:cntrl:]]'

func! s:Mapesc(str) "{{{
    if a:str =~ s:escpat
	let str = substitute(a:str, s:escpat, '\=get(s:esctbl, submatch(0), "<C-V>".submatch(0))', 'g')
	return str
    else
	return a:str
    endif
endfunc "}}}

" wrapper function for a search command
func! <sid>InFunc(normarg, post) "{{{
    " {normarg}	    command char ('/' or '?') + motion pattern
    " {post}	    extra chars (^M) to finish a :normal command
    let oldlnum = line(".")
    let cnt = v:count >= 1 ? v:count : ""
    let motpat_foldopen = nwo#var#WBG('motpat_foldopen')    " g:motpat_foldopen
    call nwo#gvmap#vrestore()
    try
	let g:motpat_errmsg = ''
	if cnt == ""
	    " can use search(), which is much faster
	    let pat = strpart(a:normarg, 1)
	    let backw = a:normarg[0] == "?"
	    let flags = backw ? "bWn" : "Wn"
	    if !motpat_foldopen
		" visit at most one match within a closed fold
		let foldlnum = backw ? foldclosed(oldlnum) : foldclosedend(oldlnum)
		if foldlnum >= 1
		    exec foldlnum
		endif
	    endif
	    let [lnum, column] = searchpos(pat, flags)
	    if lnum == 0
		call s:SearchWarn(backw, pat)
	    else
		if lnum+1 < oldlnum || lnum-1 > oldlnum
		    normal! m'
		endif
		call cursor(lnum, column)
		if motpat_foldopen
		    normal! zv
		endif
	    endif
	else
	    " with count
	    try
		let sav_ws = &wrapscan
		set nowrapscan
		exec 'silent normal!' cnt. a:normarg. a:post
		if motpat_foldopen
		    normal! zv
		endif
	    catch /:E38[45]:/
		" search hit [TOP|BOTTOM] without match for
		call s:SearchWarn(v:exception)
	    finally
		call histdel("search", -1)
		let &wrapscan = sav_ws
	    endtry
	endif
    endtry
endfunc "}}}

func! s:SearchWarn(eob, ...) "{{{
    " {eob}	exception message (string) or (boolean)
    if a:0 >= 1
	let g:motpat_errmsg = printf('search hit %s without match for: %s', a:eob ? "TOP" : "BOTTOM", a:1)
    else
	let g:motpat_errmsg = substitute(a:eob, '^[^:]*:E\d\+: ', '', '')
    endif
    if g:motpat_silent
	return
    endif
    if a:0 == 0
	normal! :
    endif
    echohl WarningMsg
    echomsg 'motpat: '. g:motpat_errmsg
    echohl None
endfunc "}}}

noremap <script>   <SID>(motpat)e'	<SID>:<C-U>call <sid>InFunc('
noremap <script>   <SID>(motpat)i'	<SID>o:<C-U>call <sid>InFunc('
noremap <script>   <SID>(motpat)l'	<SID>l:<C-U>call <sid>InFunc('
cnoremap           <SID>'<CR>	','<C-V><CR>')<CR>

noremap <script>   <SID>(motpat)e=	<SID>:<C-U>call <sid>InFunc(
noremap <script>   <SID>(motpat)i=	<SID>o:<C-U>call <sid>InFunc(
noremap <script>   <SID>(motpat)l=	<SID>l:<C-U>call <sid>InFunc(
cnoremap           <SID>=<CR>	,'<C-V><CR>')<CR>

noremap <expr>     <SID>:	nwo#gvmap#mode()
noremap <expr>     <SID>o:	nwo#gvmap#mode("i")
noremap <expr>     <SID>l:	nwo#gvmap#mode("l")

let &cpo = s:cpo_save
unlet s:cpo_save

" vim:ts=8 noet sts=4 sw=4:

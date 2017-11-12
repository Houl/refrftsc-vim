" Created:	2015 Oct 25
" Last Change:	2017 Feb 20
" Version:      0.4
" Author:	Andy Wokula <anwoku@yahoo.de>
" License:	Vim License, see :h license
" See Also:	tlib#var#Get()
" Here:		more explicit function names, and no eval()
" Rottn:	return nwo#desert#Eval("w:". a:varname)

" Functions to ask for a variable in several scopes.
" Default value.
"

" define variable in the most general scope if missing
if !exists("g:nwovar_define_missing")
    let g:nwovar_define_missing = 0
endif

" return the buffer-local or global value of variable {varname}
func! nwo#var#BG(varname, ...) "{{{
    " {a:1}	default value (default: 0)
    if exists("b:". a:varname)
	return get(b:, a:varname)
    elseif exists("g:". a:varname)
	return get(g:, a:varname)
    endif
    let defval = a:0>=1 ? a:1 : 0
    if g:nwovar_define_missing
	call extend(g:, {a:varname : defval})
    endif
    return defval
endfunc "}}}

" return the window-local, buffer-local or global value of variable {varname}
func! nwo#var#WBG(varname, ...) "{{{
    " {a:1}	default value (default: 0)
    if exists("w:". a:varname)
	return get(w:, a:varname)
    elseif exists("b:". a:varname)
	return get(b:, a:varname)
    elseif exists("g:". a:varname)
	return get(g:, a:varname)
    endif
    let defval = a:0>=1 ? a:1 : 0
    if g:nwovar_define_missing
	call extend(g:, {a:varname : defval})
    endif
    return defval
endfunc "}}}

" return the window-local or global value of variable {varname}
func! nwo#var#WG(varname, ...) "{{{
    " {a:1}	default value (default: 0)
    if exists("w:". a:varname)
	return get(w:, a:varname)
    elseif exists("g:". a:varname)
	return get(g:, a:varname)
    endif
    let defval = a:0>=1 ? a:1 : 0
    if g:nwovar_define_missing
	call extend(g:, {a:varname : defval})
    endif
    return defval
endfunc "}}}

" return the window-local or buffer-local value of variable {varname}
func! nwo#var#WB(varname, ...) "{{{
    " {a:1}	default value (default: 0)
    if exists("w:". a:varname)
	return get(w:, a:varname)
    elseif exists("b:". a:varname)
	return get(b:, a:varname)
    endif
    let defval = a:0>=1 ? a:1 : 0
    if g:nwovar_define_missing
	call extend(b:, {a:varname : defval})
    endif
    return defval
endfunc "}}}

func! nwo#var#TG(varname, ...) "{{{
    " {a:1}	default value (default: 0)
    if exists("t:". a:varname)
	return get(t:, a:varname)
    elseif exists("g:". a:varname)
	return get(g:, a:varname)
    endif
    let defval = a:0>=1 ? a:1 : 0
    if g:nwovar_define_missing
	call extend(g:, {a:varname : defval})
    endif
    return defval
endfunc "}}}

" Return the window-local or buffer-local value of variable {varname} in
" window {winnr}.  Makes use of getwinvar(), but really checks for variable
" existence and returns 0 per default.
func! nwo#var#WinnrWB(winnr, varname, ...) "{{{
    " {a:1}	default value (default: 0)
    if a:winnr >= 1 && a:winnr <= winnr('$')
	if has_key(getwinvar(a:winnr, ''), a:varname)
	    return getwinvar(a:winnr, a:varname)
	endif
	let bnr = winbufnr(a:winnr)
	if has_key(getbufvar(bnr, ''), a:varname)
	    return getbufvar(bnr, a:varname)
	endif
    endif
    if a:0 >= 1
	return a:1
    endif
    return 0
endfunc "}}}

" almost the same as tlib#var#Get()
func! nwo#var#Get(varname, namespace, ...) "{{{
    let scopenames = split(a:namespace, '\A*')
    for scope in scopenames
        let var = scope .':'. a:varname
        if exists(var)
            return get(nwo#desert#Eval(scope. ':'), a:varname)
        endif
    endfor
    let defval = a:0>=1 ? a:1 : 0
    if g:nwovar_define_missing && !empty(scopenames)
        " define the variable in the most general namespace
	call extend(nwo#desert#Eval(scopenames[-1]. ':'), {a:varname : defval})
    endif
    return defval
endfunc "}}}


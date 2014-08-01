if exists("g:loaded_returnzero")
	finish
endif
let g:loaded_returnzero = 1

let s:save_cpo = &cpo
set cpo&vim


if !exists("g:returnzero_bracket")
	let g:returnzero_bracket = ['()','{}','[]']
endif

function! s:endline()
	return col('$') == (getpos(".")[2])+1
endfunction

function! s:normal_return()
	let s:cline = getline('.')
	let s:pos = col('.')
	let s:nline = s:cline[(s:pos):-1]
	normal! lD
	call append(line('.'),s:nline)
	normal! j==I
endfunction

function! s:endl_return()
	let s:cursorchar = getline('.')[col('.')-1]
	let s:flag = 0
	for i in g:returnzero_bracket
		if s:cursorchar == i[0]
			call append(line('.'),i[1])
			normal! j==O
			let s:flag = 1
			break
		endif
	endfor
	if !s:flag
		normal! o
	endif
endfunction

function! s:mapret()
	if s:endline()
		while getline('.')[col('.')-1] == ' '
			normal! x
		endwhile
		call s:endl_return()
	else
		call s:normal_return()
	endif
endfunction

function! s:change_helper()
	if s:endline()
		nnoremap <Plug>(returnzero_helper) <Esc>S
	else
		nnoremap <Plug>(returnzero_helper) <Esc>I
	endif
endfunction

inoremap <Plug>(returnzero_helper) <Esc>I

imap <Plug>(returnzero) <Esc>:<C-u>call <SID>change_helper()<CR>:<C-u>call <SID>mapret()<CR><Plug>(returnzero_helper)

let &cpo = s:save_cpo
unlet s:save_cpo

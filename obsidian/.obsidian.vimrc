" Have j and k navigate visual lines rather than logical ones
nmap j gj
nmap k gk

" Visual mode bindings
vmap j gj
vmap k gk

" I like using H and L for beginning/end of line
unmap <Space>
nmap <Space>h ^
nmap <Space>l $
" Quickly remove search highlights
nmap <C-n> :nohl

" Map c and C to not register in the clipboard
nnoremap c "_c
nnoremap C "_C

" Yank to system clipboard
set clipboard=unnamed

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back
exmap forward obcommand app:go-forward
nmap <C-i> :forward

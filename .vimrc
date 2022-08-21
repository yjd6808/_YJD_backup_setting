" vim plug 
" ================================================================
call plug#begin()

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'
Plug 'joshdick/onedark.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
" Load the FileType autocommands if not done yet.


" ================================================================
" 코딩 관련 vim 설정
" ================================================================
set nocompatible     " 오리지날 VI와 호환하지 않음
set autoindent       " 자동 들여쓰기
set cindent          " C 프로그래밍용 자동 들여쓰기
set smartindent      " 스마트한 들여쓰기
set wrap
set nowrapscan       " 검색할 때 문서의 끝에서 처음으로 안돌아감
set nobackup         " 백업 파일을 안만듬
set noswapfile
set ruler            " 화면 우측 하단에 현재 커서의 위치(줄,칸) 표시
set shiftwidth=4     " 자동 들여쓰기 4칸
set expandtab        " 탭을 스페이스로
set number           " 행번호 표시, set nu 도 가능
set fencs=ucs-bom,utf-8,euc-kr.latin1 " 한글 파일은 euc-kr로, 유니코드는 유니코드로
set fileencoding=utf-8 " 파일저장인코딩
set tenc=utf-8       " 터미널 인코딩
set hlsearch         " 검색어 강조, set hls 도 가능
set ignorecase       " 검색시 대소문자 무시, set ic 도 가능
set tabstop=4        " 탭을 4칸으로
set lbr
set incsearch        " 키워드 입력시 점진적 검색
set cursorline       " 편집 위치에 커서 라인 설정
set laststatus=2     " 상태바 표시를 항상한다
syntax on 			 " 구문강조 사용
syntax enable
filetype indent on   " 파일 종류에 따른 구문강조
set background=dark  " 하이라이팅 lihgt / dark
set backspace=eol,start,indent "  줄의 끝, 시작, 들여쓰기에서 백스페이스시 이전줄로
set history=1000     " vi 편집기록 기억갯수 .viminfo에 기록
set mouse=a          " vim에서 마우스 사용
set t_Co=256         " 색 조정
set termguicolors
colorscheme onedark


" 마지막으로 수정된 곳에 커서를 위치함
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm g`\"" |
\ endif

" 파일 인코딩을 한국어로
if $LANG[0]=='k' && $LANG[1]=='o'
set fileencoding=korea
endif

" 비주얼 모드에서 키 변경
xnoremap <Tab> >>
xnoremap <S-Tab> <<

" 노말 모드에서 키 변경
nnoremap \ :noh<return>
nnoremap <S-Tab> <<


" 입력 모드에서 키 변경
inoremap <C-q> ()<ESC>i
inoremap <C-w> {}<ESC>i
inoremap <S-Tab> <C-d>
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" 커맨드라인 모드에서 
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

noremap <C-c> "+y
noremap <C-z> u 
noremap <C-y> <C-r>

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
if empty(mapcheck("\<C-n>", 'i'))
  inoremap <silent><expr> <C-n> coc#pum#visible() ? coc#pum#next(1) : "\<C-n>"
endif
if empty(mapcheck("\<C-p>", 'i'))
  inoremap <silent><expr> <C-p> coc#pum#visible() ? coc#pum#prev(1) : "\<C-p>"
endif
if empty(mapcheck("\<down>", 'i'))
  inoremap <silent><expr> <down> coc#pum#visible() ? coc#pum#next(0) : "\<down>"
endif
if empty(mapcheck("\<up>", 'i'))
  inoremap <silent><expr> <up> coc#pum#visible() ? coc#pum#prev(0) : "\<up>"
endif
if empty(mapcheck("\<C-e>", 'i'))
  inoremap <silent><expr> <C-e> coc#pum#visible() ? coc#pum#cancel() : "\<C-e>"
endif
if empty(mapcheck("\<C-y>", 'i'))
  inoremap <silent><expr> <C-y> coc#pum#visible() ? coc#pum#confirm() : "\<C-y>"
endif
if empty(mapcheck("\<PageDown>", 'i'))
  inoremap <silent><expr> <PageDown> coc#pum#visible() ? coc#pum#scroll(1) : "\<PageDown>"
endif
if empty(mapcheck("\<PageUp>", 'i'))
  inoremap <silent><expr> <PageUp> coc#pum#visible() ? coc#pum#scroll(0) : "\<PageUp>"
endif
" YouCompleteMe 관련 설정
let g:ycm_autoclose_preview_wimdow_after_completion = 1

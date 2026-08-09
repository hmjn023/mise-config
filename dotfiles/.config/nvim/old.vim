set number
set autoindent
set tabstop=3
set shiftwidth=3
set splitright
set hls
set mouse=a
set completeopt=menuone,noinsert
set pumblend=5


inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>

"// PLUGIN SETTINGS
call plug#begin('~/.config/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'neoclide/coc.nvim',{'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'github/copilot.vim'
Plug 'rcarriga/nvim-notify'
Plug 'EdenEast/nightfox.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' }
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope-media-files.nvim'

call plug#end()

colorscheme nightfox

" NERDTree SETTINGS
"
nmap <C-f> :NERDTreeToggle<CR>
let g:airline#extensions#tabline#enabled = 1
nmap <C-p> <Plg>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTabu

" Airline SETTINGS
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab

"Coc SETTINGS
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm()
			\: "<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <silent><expr><TAB>
			\ coc#pum#visible() ? coc#pum#next(1):
			\ <SID>check_back_space() ? "\<TAB>" :
			\ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

"telescope SETTINGS
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

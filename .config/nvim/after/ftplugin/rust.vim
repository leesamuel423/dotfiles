set makeprg=cargo\ build\ --quiet\ --release
set errorformat=%E-->\ %f:%l:%c,%C%.%#,%Z%m

setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal textwidth=100
setlocal colorcolumn=100

compiler cargo


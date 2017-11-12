
let g:no_bracket_maps = 1

map <expr> ]] repmo#Key('<Plug>]]-motion', '<Plug>[[-motion')|sunmap ]]
map <expr> [[ repmo#Key('<Plug>[[-motion', '<Plug>]]-motion')|sunmap [[
map <expr> ][ repmo#Key('<Plug>][-motion', '<Plug>[]-motion')|sunmap ][
map <expr> [] repmo#Key('<Plug>[]-motion', '<Plug>][-motion')|sunmap []
map <expr> ]m repmo#Key('<Plug>]m-motion', '<Plug>[m-motion')|sunmap ]m
map <expr> [m repmo#Key('<Plug>[m-motion', '<Plug>]m-motion')|sunmap [m
map <expr> ]M repmo#Key('<Plug>]M-motion', '<Plug>[M-motion')|sunmap ]M
map <expr> [M repmo#Key('<Plug>[M-motion', '<Plug>]M-motion')|sunmap [M

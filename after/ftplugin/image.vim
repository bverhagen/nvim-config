silent execute "!eog " . shellescape(expand("%:p")) . " &>/dev/null &" | buffer# | bdelete# | redraw! | syntax on

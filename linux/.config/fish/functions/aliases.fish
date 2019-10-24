function gitlog
    git log --all --decorate --oneline --graph $argv
end
# gitlog="git log --all --decorate --oneline --graph"

function xclip
    xclip -selection c $argv
end
# alias xclip="xclip -selection c"

function lmuwin
    xfreerdp /u:AD\\Yudong.Sun /h:768 /w:1366 $argv
end
# alias lmuwin='xfreerdp /u:AD\\Yudong.Sun /h:768 /w:1366 /v:'

function fish_prompt --description 'Write out the prompt'

    set -l last_status $status

    if not set -q __fish_git_prompt_show_informative_status
        set -g __fish_git_prompt_show_informative_status 1
    end
    if not set -q __fish_git_prompt_color_branch
        set -g __fish_git_prompt_color_branch brmagenta
    end
    if not set -q __fish_git_prompt_showupstream
        set -g __fish_git_prompt_showupstream "informative"
    end
    if not set -q __fish_git_prompt_showdirtystate
        set -g __fish_git_prompt_showdirtystate "yes"
    end
    if not set -q __fish_git_prompt_color_stagedstate
        set -g __fish_git_prompt_color_stagedstate yellow
    end
    if not set -q __fish_git_prompt_color_invalidstate
        set -g __fish_git_prompt_color_invalidstate red
    end
    if not set -q __fish_git_prompt_color_cleanstate
        set -g __fish_git_prompt_color_cleanstate brgreen
    end

    # Set Characters
    # https://mariuszs.github.io/blog/2013/informative_git_prompt.html
    set -g __fish_git_prompt_char_stagedstate "•"
    set -g __fish_git_prompt_char_dirtystate "+"
    
    if test -z $WINDOW
        printf '[%s%s%s@%s%s] %s%s%s%s' (set_color brgreen) (whoami) (set_color brcyan) (prompt_hostname) (set_color normal) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (__fish_git_prompt)
    else
        printf '[%s%s%s@%s%s(%s)]%s%s%s%s' (set_color brgreen) (whoami) (set_color brcyan) (prompt_hostname) (set_color normal) (echo $WINDOW) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (__fish_git_prompt)
    end
    printf '\n > '

    if not test $last_status -eq 0
        set_color $fish_color_error
    end
    echo -n '$ '
    set_color normal
end


#function fish_prompt
#   printf '%s%s %s%s%s%s ' (set_color $fish_color_host) (prompt_hostname) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (__fish_git_prompt)
#end

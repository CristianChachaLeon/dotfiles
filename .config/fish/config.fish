# Auto-start zellij 
if not set -q ZELLIJ
    and not set -q TMUX
    zellij
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end

alias v nvim

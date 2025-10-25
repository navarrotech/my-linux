if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Helpers

# Yazi - https://yazi-rs.github.io/docs/quick-start
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# NVM
set -gx NVM_DIR $HOME/.nvm

# Load nvm (without auto-switching Node)
if test -s $NVM_DIR/nvm.sh
    bass source $NVM_DIR/nvm.sh --no-use
end

function efish
    set -l f ~/.config/fish/config.fish
    micro $f
    and source $f
    and echo "✓ fish config reloaded"
end

# Starship
starship init fish | source

# Env
set -xg EDITOR micro
set -x PATH $PATH:/usr/local/bin

# Aliases
alias gti "git"

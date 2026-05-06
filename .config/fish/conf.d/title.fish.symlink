function fish_title
    # An override for the current command is passed as the first parameter.
    # This is used by `fg` to show the true process name, among others.
    if set -q argv[1]
        echo -- (string sub -l 20 -- $argv[1]) (prompt_pwd -d 1 -D 1)
    else
        # Don't print "fish" because it's redundant
        set -l command (status current-command)
        if test "$command" = fish
            set command
        end
        echo -- (string sub -l 20 -- $command) (prompt_pwd -d 1 -D 1)
    end
end

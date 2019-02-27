# Status Chars
set __fish_git_prompt_char_dirtystate '!'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_cleanstate '✓'

# Display the state of the branch when inside of a git repo
function __simple_ass_prompt_parse_git_branch_state -d "Display the state of the branch"
  git update-index --really-refresh -q 1> /dev/null

  # Check for changes to be commited
  if git_is_touched
    echo -n "$__fish_git_prompt_char_dirtystate"
  else
    echo -n "$__fish_git_prompt_char_cleanstate"
  end

  # Check for untracked files
  set -l git_untracked (command git ls-files --others --exclude-standard 2> /dev/null)
  if [ -n "$git_untracked" ]
    echo -n "$__fish_git_prompt_char_untrackedfiles"
  end

  # Check for stashed files
  if git_is_stashed
    echo -n "$__fish_git_prompt_char_stashstate"
  end

  # Check if branch is ahead, behind or diverged of remote
  git_ahead
end

# Display current git branch
function __simple_ass_prompt_git -d "Display the actual git branch"
  set -l ref
  set -l std_prompt (prompt_pwd)
  set -l is_dot_git (string match '*/.git' $std_prompt)

  if git_is_repo; and test -z $is_dot_git
    printf 'on '
    set_color purple

    set -l git_branch (command git symbolic-ref --quiet --short HEAD 2> /dev/null; or git rev-parse --short HEAD 2> /dev/null; or echo -n '(unknown)')

    printf '%s ' $git_branch

    set state (__simple_ass_prompt_parse_git_branch_state)
    set_color blue
    printf '(%s)' $state

    set_color normal
  end
end

# Print current user
function __simple_ass_prompt_get_user -d "Print the user"
  if test $USER = 'root'
    set_color red
  else
    set_color blue
  end
  printf '%s' (whoami)
end

# Get Machines Hostname
function __simple_ass_prompt_get_host -d "Get Hostname"
  if test $SSH_TTY
    tput bold
    set_color red
  else
    set_color yellow
  end
  printf '%s' (hostname|cut -d . -f 1)
end

# Get Project Working Directory
function __simple_ass_prompt_pwd -d "Get PWD"
  set_color $fish_color_cwd
  printf '%s ' (pwd)
end

# Simple-ass-prompt
function fish_prompt
  # New line after command result
  echo

  set -l code $status

  # Logged in user
  __simple_ass_prompt_get_user
  set_color normal
  #printf ' at '

  # Machine logged in to
  #__simple_ass_prompt_get_host
  #set_color normal
  printf ' in '

  # Path
  __simple_ass_prompt_pwd
  set_color normal

  # Git info
  __simple_ass_prompt_git

  # Line 2
  echo

  if test $VIRTUAL_ENV
    printf "(python:%s) " (set_color blue)(basename $VIRTUAL_ENV)(set_color normal)
  end

  if test $code -eq 127
    set_color red
  end

  switch $fish_bind_mode
    case default
      printf (set_color green)"❮"(set_color yellow)"❮"(set_color red)"❮ "
    case insert
      printf (set_color green)"❯"(set_color yellow)"❯"(set_color red)"❯ "
  end
  set_color normal
end
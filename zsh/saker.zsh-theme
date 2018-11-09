function prompt_char {
	if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}

PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}$(saker_user))$(saker_host)%{$fg_bold[blue]%}$(saker_dir) %{$fg_bold[magenta]%}$(git_prompt_info)%_%{$fg_bold[white]%}$(prompt_char)%{$reset_color%} '
RPROMPT='%{$fg_bold[gray]%}%i'

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=") "

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SAKER_DIR_SHOW="${SAKER_DIR_SHOW=true}"
SAKER_DIR_PREFIX="${SAKER_DIR_PREFIX="in "}"
SAKER_DIR_SUFFIX="${SAKER_DIR_SUFFIX="$SAKER_PROMPT_DEFAULT_SUFFIX"}"
SAKER_DIR_TRUNC="${SAKER_DIR_TRUNC=3}"
SAKER_DIR_TRUNC_PREFIX="${SAKER_DIR_TRUNC_PREFIX=}"
SAKER_DIR_TRUNC_REPO="${SAKER_DIR_TRUNC_REPO=true}"
SAKER_DIR_COLOR="${SAKER_DIR_COLOR="cyan"}"
SAKER_DIR_LOCK_SYMBOL="${SAKER_DIR_LOCK_SYMBOL=" "}"
SAKER_DIR_LOCK_COLOR="${SAKER_DIR_LOCK_COLOR="red"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

saker_dir() {
  [[ $SAKER_DIR_SHOW == false ]] && return

  local 'dir' 'trunc_prefix'

  if [[ $SAKER_DIR_TRUNC_REPO == true ]] && saker::is_git; then
    local git_root=$(git rev-parse --show-toplevel)

    if [[ $git_root:h == / ]]; then
      trunc_prefix=/
    else
      trunc_prefix=$SAKER_DIR_TRUNC_PREFIX
    fi

    dir="$trunc_prefix$git_root:t${${PWD:A}#$~~git_root}"
  else
    if [[ SAKER_DIR_TRUNC -gt 0 ]]; then
      trunc_prefix="%($((SAKER_DIR_TRUNC + 1))~|$SAKER_DIR_TRUNC_PREFIX|)"
    fi

    dir="$trunc_prefix%${SAKER_DIR_TRUNC}~"
  fi

  if [[ ! -w . ]]; then
    SAKER_DIR_SUFFIX="%F{$SAKER_DIR_LOCK_COLOR}${SAKER_DIR_LOCK_SYMBOL}%f${SAKER_DIR_SUFFIX}"
  fi

    saker::section \
    "$SAKER_DIR_COLOR" \
    "$SAKER_DIR_PREFIX" \
    "$dir" \
    "$SAKER_DIR_SUFFIX"
}

saker::is_git() {
  command git rev-parse --is-inside-work-tree &>/dev/null
}

saker_prompt_opened="$SAKER_PROMPT_FIRST_PREFIX_SHOW"

saker::section() {
  local color prefix content suffix
  [[ -n $1 ]] && color="%F{$1}"  || color="%f"
  [[ -n $2 ]] && prefix="$2"     || prefix=""
  [[ -n $3 ]] && content="$3"    || content=""
  [[ -n $4 ]] && suffix="$4"     || suffix=""

  [[ -z $3 && -z $4 ]] && content=$2 prefix=''

  echo -n "%{%B%}"
  if [[ $saker_prompt_opened == true ]] && [[ $SAKER_PROMPT_PREFIXES_SHOW == true ]]; then
    echo -n "$prefix"
  fi
  saker_prompt_opened=true
  echo -n "%{%b%}"

  echo -n "%{%B$color%}"
  echo -n "$content"
  echo -n "%{%b%f%}"

  echo -n "%{%B%}"
  if [[ $SAKER_PROMPT_SUFFIXES_SHOW == true ]]; then
    echo -n "$suffix"
  fi
  echo -n "%{%b%}"
}

saker::compose_prompt() {
  setopt EXTENDED_GLOB LOCAL_OPTIONS

  for section in $@; do
    if saker::defined "saker_$section"; then
      saker_$section
    else
      saker::section 'red' "'$section' not found"
    fi
  done
}

# ------------------------------------------------------------------------------
# Username
# ------------------------------------------------------------------------------

SAKER_USER_SHOW="${SAKER_USER_SHOW=true}"
SAKER_USER_PREFIX="${SAKER_USER_PREFIX="with "}"
SAKER_USER_SUFFIX="${SAKER_USER_SUFFIX="$SAKER_PROMPT_DEFAULT_SUFFIX"}"
SAKER_USER_COLOR="${SAKER_USER_COLOR="yellow"}"
SAKER_USER_COLOR_ROOT="${SAKER_USER_COLOR_ROOT="red"}"

saker_user() {
  [[ $SAKER_USER_SHOW == false ]] && return

  if [[ $SAKER_USER_SHOW == 'always' ]] \
  || [[ $LOGNAME != $USER ]] \
  || [[ $UID == 0 ]] \
  || [[ $SAKER_USER_SHOW == true && -n $SSH_CONNECTION ]]
  then
    local 'user_color'

    if [[ $USER == 'root' ]]; then
      user_color=$SAKER_USER_COLOR_ROOT
    else
      user_color="$SAKER_USER_COLOR"
    fi

    saker::section \
      "$user_color" \
      "$SAKER_USER_PREFIX" \
      '%n' \
      "$SAKER_USER_SUFFIX"
  fi
}

# ------------------------------------------------------------------------------
# Hostname
# ------------------------------------------------------------------------------

SAKER_HOST_SHOW="${SAKER_HOST_SHOW=true}"
SAKER_HOST_SHOW_FULL="${SAKER_HOST_SHOW_FULL=false}"
SAKER_HOST_PREFIX="${SAKER_HOST_PREFIX="at "}"
SAKER_HOST_SUFFIX="${SAKER_HOST_SUFFIX="$SAKER_PROMPT_DEFAULT_SUFFIX"}"
SAKER_HOST_COLOR="${SAKER_HOST_COLOR="blue"}"
SAKER_HOST_COLOR_SSH="${SAKER_HOST_COLOR_SSH="green"}"

saker_host() {
  [[ $SAKER_HOST_SHOW == false ]] && return

  if [[ $SAKER_HOST_SHOW == 'always' ]] || [[ -n $SSH_CONNECTION ]]; then
    local host_color host

    if [[ -n $SSH_CONNECTION ]]; then
      host_color=$SAKER_HOST_COLOR_SSH
    else
      host_color=$SAKER_HOST_COLOR
    fi

    if [[ $SAKER_HOST_SHOW_FULL == true ]]; then
      host="%M"
    else
      host="%m"
    fi

    saker::section \
      "$host_color" \
      "@" \
      "$host" \
      " "
  fi
}

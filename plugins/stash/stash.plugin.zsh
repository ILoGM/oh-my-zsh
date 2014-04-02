open_in_stash() {
  local open_cmd

  read namespace project_name <<<$(git config --get remote.origin.url | egrep -o '/([-a-z]+)/([-a-z]+)\.' | rev | cut -c2- | rev | egrep -o '^/[-a-z]*' | cut -c2- | tr '\n', ' ')
  if [[ $(uname -s) == 'Darwin' ]]; then
    open_cmd='open'
  else
    open_cmd='xdg-open'
  fi

  if [ -f .stash-url ]; then
    stash_url=$(cat .stash-url)
  elif [ -f ~/.stash-url ]; then
    stash_url=$(cat ~/.stash-url)
  elif [[ "x$STASH_URL" != "x" ]]; then
    stash_url=$STASH_URL
  else
    echo "Stash url is not specified anywhere."
    return 0
  fi

  if [ -z "$1" ]; then
    local branch=$(current_branch)
    if [ -z "$branch" ]; then
      echo "No branch found"
      return 0
    else
      branch=$(git show-ref $branch --heads | egrep -o '[/a-zA-Z0-9-]*$')
    fi
  else
    branch=$(git show-ref $1 --heads | egrep -o '[/a-zA-Z0-9-]*$')
  fi

  echo "Opening branch #$branch"
  $open_cmd "$stash_url/projects/$namespace/repos/$project_name/browse/?at=$branch"
}

alias stash='open_in_stash'

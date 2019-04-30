#!/bin/bash +x

tag() {
  local TAG
   . ./.venv/bin/activate
  if [[ "${BRANCH_NAME}" == "master" ]];then
    TAG=$( semvertag bump patch --tag )
  else
    TAG=$( semvertag bump patch --tag --stage "alpha" )
  fi
  echo $TAG > semvertag.txt
  cat semvertag.txt
}

read_tag() {
  local TAG

  if [[ -f semvertag.txt ]];then
    TAG=$(head -n 1 semvertag.txt)
  elif [[ -f ../semvertag.txt ]];then
    TAG=$(head -n 1 ../semvertag.txt)
  else
    echo "semvertag.txt not found"
  fi

  echo $TAG
}

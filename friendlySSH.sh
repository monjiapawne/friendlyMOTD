#!/bin/bash
#colors
c1="\e[1;32m"  # ascii
c2="\e[1;33m"  # border
c3="\e[1;35m"  # message1
c4="\e[1;32m"  # message2
x="\e[0m"

sun=$(cat <<'EOF'
       .   .;   .
   .   :;  ::  ;:   .   
   .;. ..      .. .;.   
..  ..             ..  ..
 .;,                 ,;.
EOF
)

mickey=$(cat <<'EOF'
         .-"""-.
        /       \
        \       /
 .-"""-.-`.-.-.<  _
/      _,-\ ()()_/:)
\     / ,  `     `|
 '-..-| \-.,___,  /
       \ `-.__/  /
        `-.__.-'`
EOF
)

coffee=$(cat <<'EOF'
  ;)( ;
 :----:
C|====|
 |    |
 `----'
EOF
)

dog=$(cat <<'EOF'
   / \__
  (   . \___
  /         O
 /   (_____/
/_____/   
EOF
)

dog2=$(cat <<'EOF'
             .--~~,__
:-....,-------`~~'._.'
 `-,,,  ,_      ;'~U'
  _,-' ,'`-__; '--.
 (_/'~~      ''''(;
EOF
)



calc_border_padding(){
  local max=$1
  local input=$2
  spaces=$(( max - ${#input} ))
  
  if (( spaces % 2 == 0 )); then
      spacesleft=$(( spaces / 2 ))
      spacesright=$(( spaces / 2 ))
  else
      spacesleft=$(( spaces / 2 ))
      spacesright=$(( spaces / 2 + 1 ))
  fi
}

append_time(){
  local max=$(($1+2))
  time="$(date +%T)"
  calc_border_padding $max "$time"
  printf "${bor}%*s${c3}%s${c2}%*s${bor}\n" "$spacesleft" "" "$time" " $spacesright" ""
}

append_day(){
  local max=$(($1+2))
  time="$(date "+%a %d %I%p")"
  calc_border_padding $max "$time"
  printf "${bor}%*s${c3}%s${c2}%*s${bor}\n" "$spacesleft" "" "$time" " $spacesright" ""
}

append_message(){
  local max=$(($1+2))
  calc_border_padding $max "$message"
  printf "${bor}%*s${c4}%s${c2}%*s${bor}\n" "$spacesleft" "" "$message" " $spacesright" ""
}

draw_bordered(){
  message=$1
  ascii_varname=$2
  local ascii="${!ascii_varname}"
  flag=$3
  borders=$4

  # find max width needed
  msg_len=${#message}
  ascii_max=$(echo "$ascii" | awk '{ if (length > max) max = length } END { print max }')

  if (( msg_len > ascii_max )); then
    max=$msg_len
    ascii_pad=$((((msg_len / 2)) - ascii_max/2))
  else
    max=$ascii_max
    ascii_pad=1
  fi


  if [[ $borders == "true" ]]; then
    printf "${c2}┌"
    printf '─%.0s' $(seq 1 $((max + 2)))
    printf '┐\n'

    bor="│"
  elif [[ $borders == "false" ]]; then
    printf "\n"  
  fi

  while IFS= read -r line; do
    padding=$(( ((max - ${#line})) - $ascii_pad + 1 ))
    printf "${c2}${bor}%*s${c1}%s%*s ${c2}${bor}\n" "$ascii_pad" "" "$line" "$padding" ""
  done <<< "$ascii"
  printf "${bor} %*s ${bor}\n" "$max"

  if [[ $flag == "time" ]]; then
    append_time $max
  fi

  if [[ $flag == "static_time" ]]; then
    append_day $max
  fi

  if [[ -n $message ]]; then
    append_message $max
  fi

  if [[ $borders == "true" ]]; then
    printf '└'
    printf '─%.0s' $(seq 1 $((max+2)))
    printf '┘\n'
  elif [[ $borders == "false" ]]; then
    printf '\n'
  fi
}

draw_bordered "morning, $USER" "dog2" "static_time" "true"

#!/bin/bash

#------------------------------------------------------------------------------
# CONFIGURATION
#------------------------------------------------------------------------------
# Colors definitions
c1="\e[1;34m"  # ascii
c2="\e[1;33m"  # border
c3="\e[1;35m"  # message1
c4="\e[1;32m"  # message2
x="\e[0m"      # reset color

# Default values
DEFAULT_MESSAGE="Good morning, $USER"
DEFAULT_ASCII="owl"
DEFAULT_TIME_FLAG="static_time"
DEFAULT_BORDERS="true"

#------------------------------------------------------------------------------
# ARGUMENT PARSING
#------------------------------------------------------------------------------
# So clean!
parse_arguments() {
    # Set defaults
    MESSAGE="$DEFAULT_MESSAGE"
    ASCII="$DEFAULT_ASCII"
    TIME_FLAG="$DEFAULT_TIME_FLAG"
    BORDERS="$DEFAULT_BORDERS"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -m) MESSAGE="$2"; shift 2 ;;
            -a) ASCII="$2"; shift 2 ;;
            -t) TIME_FLAG="$2"; shift 2 ;;
            -b) BORDERS="$2"; shift 2 ;;
            -h|--help) print_help; exit 0;;

            *) shift ;;
        esac done }
#------------------------------------------------------------------------------
# ASCII ART DEFINITIONS
#------------------------------------------------------------------------------
camel=$(cat <<'EOF'
                ,,__
       ..  ..   / o._)
     /--'/--\  \-'||
   /        \_/ / |
 .'\  \__\  __.'.'
   )\ |  )\ |
   // \\ // \\
  ||_  \\|_  \\_
  '--' '--'' '--'
EOF
)
wolf=$(cat <<'EOF'
             .
            / V\
          / `  /
        <<     |
       /       |
      /   \  \ /
     (    ) | |
  __|   _/_ | |
<___\______)\__)
EOF
)
owl=$(cat <<'EOF'
  , ___
`\/{o,o}
 / /)  )
/,--"-"-
EOF
)

#------------------------------------------------------------------------------
# UTILITY FUNCTIONS
#------------------------------------------------------------------------------
# Calculates padding for centering text
#   Agrs: $1 = max width,  $2 = input text
#   Returns: spacesleft, spacesright
calc_border_padding(){
  local max=$1
  local input=$2
  local spaces=$(( max - ${#input} ))
  if (( spaces % 2 == 0 )); then
      echo "$(( spaces / 2 )) $(( spaces / 2 ))"
  else
      echo "$(( spaces / 2 )) $(( spaces / 2 + 1 ))"
  fi
}

print_help() {
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "──────────────────────────────────────────────────────────────"
    echo "  -m <message>    Set the message text"
    echo "  -a <ascii>      Set the ASCII art variable name"
    echo "  -t <true|false> Show the time (default: $DEFAULT_TIME_FLAG)"
    echo "  -b <true|false> Show borders (default: $DEFAULT_BORDERS)"
    echo "  -h, --help      Show this help message"
    echo "──────────────────────────────────────────────────────────────"
}

#------------------------------------------------------------------------------
# CONTENT APPEND
#------------------------------------------------------------------------------
append_day(){
  local max=$(($1+2))
  local bor="$2"
  local spacesleft spacesright
  local time="$(date "+%a %d %I%p")"
  read spacesleft spacesright <<< "$(calc_border_padding $max "$time")"
  printf "${bor}%*s${c3}%s${c2}%*s${bor}\n" "$spacesleft" "" "$time" " $spacesright" ""
}

append_message(){
  local max=$(($1+2))
  local bor="$2"
  local message="$3"
  local spacesleft spacesright
  read spacesleft spacesright <<< "$(calc_border_padding $max "$message")"
  printf "${bor}%*s${c4}%s${c2}%*s${bor}\n" "$spacesleft" "" "$message" " $spacesright" ""
}

#------------------------------------------------------------------------------
# MAIN DISPLAY FUNCTION
#------------------------------------------------------------------------------
draw_display(){
  # arguments
  local message=$1
  local ascii_varname=$2
  local ascii="${!ascii_varname}"
  local flag=$3
  local borders=$4
  # populated later
  local max
  local ascii_pad
  local padding
  local bor=""
  local line

  # find max width needed
  local msg_len=${#message}
  local ascii_max=$(echo "$ascii" | awk '{ if (length > max) max = length } END { print max }')

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
    printf '┐'
    bor="│"
  fi
  printf "\n"  

  while IFS= read -r line; do
    padding=$(( ((max - ${#line})) - $ascii_pad + 1 ))
    printf "${c2}${bor}%*s${c1}%s%*s ${c2}${bor}\n" "$ascii_pad" "" "$line" "$padding" ""
  done <<< "$ascii"
  printf "${bor} %*s ${bor}\n" "$max"

  if [[ $flag == "static_time" ]]; then
    append_day $max "$bor"
  fi

  if [[ -n $message ]]; then
    append_message $max "$bor" "$message"
  fi

  if [[ $borders == "true" ]]; then
    printf '└'
    printf '─%.0s' $(seq 1 $((max+2)))
    printf '┘'
  fi
  printf '\n'
}

#------------------------------------------------------------------------------
# TIMING
#------------------------------------------------------------------------------
time_call(){
  local time=$(date +%T)

  if [[ $time < 12:00:00 ]]; then
    main -m "good morning, $USER" -a "camel" -t "true" -b "true"
  elif [[ $time > 12:00:00 && $time < 24:00:00 ]]; then
    main -m "good afternoon, $USER" -a "wolf" -t "true" -b "true"
  else
    main -m "good evening, $USER" -a "owl" -t "true" -b "true"
  fi
}


#------------------------------------------------------------------------------
# MAIN EXECUTION
#------------------------------------------------------------------------------

main() {
  parse_arguments "$@"
  draw_display "$MESSAGE" "$ASCII" "$TIME_FLAG" "$BORDERS"
}

#main "$@"

time_call
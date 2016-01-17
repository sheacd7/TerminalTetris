#!/bin/bash
# META =========================================================================
# Title: TerminalTetris.sh
# Usage: TerminalTetris.sh
# Description: Definitive, modular Tetris clone for terminal emulators.
# Author: Colin Shea
# Created: 2015-08-09

# BUGFIX:
#   intermittent screen tearing when holding down a control during draw
#   square check not picking up squares
#     4E28
#     8189
#     94B9
#     5211

# TODO:
# - wall kick logic 
#     check_bounds - additional x,y offsets for each wall kick test
#                  - success: overwrite xoff, yoff with x,y offsets that worked
#                  -          return 0
#                  - failure: return 1
# - simplify bounds checking and square checking
# - timer-based drop
# - more responsive controls/ less latency

# - hard v firm lock
# - save/load state
# - ARE/IRS/IHS? DAS?
# - portable method of creating hard-coded terminal codes
# - modular options for 
#     control remapping
#     colors
#     rotation and wall kick system
#     delay times
#     square mode
#     score mode (marathon, sprint, ultra, etc)

# prepare temp dir, temp files
#source /cygdrive/c/users/sheacd/locals/TerminalTetris_local_env.sh 

scriptname=$(basename $0)
function usage {
  echo "Usage: $scriptname"
  echo "The New Tetris clone for terminals."
  echo ""
  echo "  -h, --help        display help"
}

# set input values from command line arguments 
while [[ $# > 0 ]]; do
  arg="$1"
  case $arg in
    -h|--help) usage; exit ;;        # print help
    *) echo "Unknown option: $1" ;;  # unknown option
  esac
  shift
done

# load tetrimino data
source /cygdrive/c/users/sheacd/GitHub/TerminalTetris/Tetriminoes.sh
# load rotation system data
source /cygdrive/c/users/sheacd/GitHub/TerminalTetris/RotationSystems.sh
# load wall kick system data
#source /cygdrive/c/users/sheacd/GitHub/TerminalTetris/WallKickSystems.sh

# generate random sequence of ints to fill bag [0:2*bsize-1]
function init_bag {
  # bag is 2*bsize to allow preview of upcoming tetriminoes 
  bag=""
  bag+=$(shuf -i 0-$((${bsize}-1)) -n ${bsize} -z)
  bag+=$(shuf -i 0-$((${bsize}-1)) -n ${bsize} -z)
}

# get int representing next tetrimino from bag
function get_next_from_bag {
  # when first bsize bag is exhausted 
  if (( "${bidx}" >= "${bsize}" )); then 
    # replace first bsize ints with second bsize ints and
    bag=${bag:$bidx}
    # replace second bsize ints with next shuf
    bag+=$(shuf -i 0-$((${bsize}-1)) -n ${bsize} -z)
    # reset index back to first bsize interval
    : $(( bidx%=${bsize} ))
  fi
  return "${bag:$bidx:1}"
}

# initialize static buffer for well
function init_static_buffer {
  for i in {0..21}; do
    sb[$i]="          "
  done
}

# copy static buffer to dynamic buffer
function init_dynamic_buffer {
  db=( "${sb[@]}" )
}

function init_connect_buffer {
  cb=( "${sb[@]}" )
}

function init_preview_buffer {
  pb[0]="Next      "
  for i in {1..21}; do 
    pb[$i]="          "
  done
}

# draw sprite to dynamic buffer at (y,x)
function draw_sprite {
  # set coordinates of top-left corner of sprite from input
  y=$1 
  x=$2 
  # draw sprite to dynamic buffer
  for j in "${!sprite[@]}"; do 
    # calculate row offset for buffer
    row=$(($y+$j+$ry))
    for ((i=0; i<${#sprite[$j]}; i++)); do 
      # calculate column offset for buffer
      col=$(($x+$i+$rx))
      # if sprite value not ' ', draw to buffer
      s="${sprite[$j]:$i:1}"
      [[ "$s" != " " ]] && db[$row]="${db[$row]:0:$col}$s${db[$row]:$(($col+1))}"
    done
  done
}

# draw sprite to connect buffer at (y,x)
function draw_sprite_c {
  # set coordinates of top-left corner of sprite from input
  y=$1 
  x=$2 
  # draw sprite to dynamic buffer
  for j in "${!c_sprite[@]}"; do 
    # calculate row offset for buffer
    row=$(($y+$j+$ry))
    for ((i=0; i<${#c_sprite[$j]}; i++)); do 
      # calculate column offset for buffer
      col=$(($x+$i+$rx))
      # if sprite value not ' ', draw to buffer
      s="${c_sprite[$j]:$i:1}"
      [[ "$s" != " " ]] && cb[$row]="${cb[$row]:0:$col}$s${cb[$row]:$(($col+1))}"
    done
  done
}

# draw current sprite to screen buffer, bypassing dynamic buffer 
function draw_ghost {
  # set coordinates of top-left corner of sprite from input
  y=$ghost_ypos
  x=$xpos
  # draw sprite to dynamic buffer
  for j in "${!sprite[@]}"; do 
    # calculate row offset for buffer
    row=$(($y+$j+$ry))
    for ((i=0; i<${#sprite[$j]}; i++)); do 
      # calculate column offset for buffer
      col=$(($x+$i+$rx+1))
      # if sprite value not ' ', draw to buffer; use ${,,} to lowercase
      s="${sprite[$j]:$i:1}"
      b="${screen[$row]:$col:1}"
      if [[ "$s" != " " && "$b" == " " ]]; then
        screen[$row]="${screen[$row]:0:$col}${s,,}${screen[$row]:$(($col+1))}"
      fi
    done
  done
}

# apply terminal codes to screen buffer with parameter substitution
function compose_screen {
  update_preview_buffer
  for i in "${!db[@]}"; do
#    screen[$i]="${db[$i]}${pb[$i]}"
    screen[$i]="X${db[$i]}X${cb[$i]}X"
  done
  draw_ghost
  screen[22]="XXXXXXXXXXXXXXXXXXXXXXX"
  # normal
  screen=( "${screen[@]// /\\033[30m\\u2588\\033[0m}" ) # black
  screen=( "${screen[@]//X/\\033[37m\\u2588\\033[0m}" ) # gray
  screen=( "${screen[@]//Z/\\033[91m\\u2588}") #\\033[0m}" ) # red
  screen=( "${screen[@]//S/\\033[92m\\u2588}") #\\033[0m}" ) # green
  screen=( "${screen[@]//T/\\033[93m\\u2588}") #\\033[0m}" ) # yellow
  screen=( "${screen[@]//J/\\033[94m\\u2588}") #\\033[0m}" ) # blue
  screen=( "${screen[@]//L/\\033[95m\\u2588}") #\\033[0m}" ) # purple
  screen=( "${screen[@]//I/\\033[96m\\u2588}") #\\033[0m}" ) # cyan 
  screen=( "${screen[@]//O/\\033[97m\\u2588}") #\\033[0m}" ) # white
  # ghost
  screen=( "${screen[@]//z/\\033[2;91m\\u2588\\033[0m}" ) # red
  screen=( "${screen[@]//s/\\033[2;92m\\u2588\\033[0m}" ) # green
  screen=( "${screen[@]//t/\\033[2;93m\\u2588\\033[0m}" ) # yellow
  screen=( "${screen[@]//j/\\033[2;94m\\u2588\\033[0m}" ) # blue
  screen=( "${screen[@]//l/\\033[2;95m\\u2588\\033[0m}" ) # purple
  screen=( "${screen[@]//i/\\033[2;96m\\u2588\\033[0m}" ) # cyan 
  screen=( "${screen[@]//o/\\033[2;97m\\u2588\\033[0m}" ) # white
  # squares
  screen=( "${screen[@]//U/\\033[38;2;180;180;0m\\u2588\\033[0m}" ) # gold
  screen=( "${screen[@]//G/\\033[38;2;180;180;180m\\u2588\\033[0m}" ) # silver 
  # clear lines
  screen=( "${screen[@]//V/\\033[7m}" ) # invert
  screen=( "${screen[@]//R/\\033[0m}" ) # reset
}

# display screen
function display_screen {
  # screen = dynamic buffer with terminal codes for styling
  compose_screen
  # set coordinates to top-left of terminal window
  printf '%b' "\033[0;0H"  #  tput cup 0 0
  # print contents of screen buffer array
  printf '%b\n' "${screen[@]}"
  # print contents of debug buffer array
  if [[ "$debug" ]]; then
    update_debug_buffer
    printf '%b\n' "${dbgb[@]}"
  fi  
  # reset terminal formattings
  printf '%b' "\033[0m"  #  tput sgr0
}

function update_preview_buffer {
  for (( idx=1; idx<22; idx++)); do
    pb[$idx]="          "
  done
  # print sprite for bidx+(1,2,3) to buffer[2,6,10]
  # need to account for eye not completely cleared because of different length
  for j in {0..2}; do 
    mapfile -t p_sprite <<< "$(get_sprite ${bag:$(($bidx + $j + 1)):1} 0 't')"
    for i in "${!p_sprite[@]}"; do 
      # left-justify and pad to 10 chars with spaces
      printf -v pb[$(($j * 4 + $i + 2))] '%-10s' " ${p_sprite[$i]}"
    done
  done
}

# debug console with global variables displayed
function update_debug_buffer {
#  printf '%s' "Updating debug buffer"
  dbgb=()
  dbgb[0]="\\033[0mbag"
  dbgb[1]="${bag}"
  dbgb[2]="------"
  dbgb[2]="${dbgb[2]:0:$bidx}""^""${dbgb[2]:$bidx}"
  dbgb[3]="sprite"
  printf -v dbgb[4] '%1d,%02d,%02d,%02d' ${tidx} ${xpos} ${ypos} ${rpos}
#dbgb[4]="$(printf '%1d,%02d,%02d,%02d' ${tidx} ${xpos} ${ypos} ${rpos})"
  dbgb[5]="input"
  printf -v dbgb[6] '%1s,%02d,%02d,%02d' ${move} ${xoff} ${yoff} ${roff}
#dbgb[6]="$(printf '%1s,%02d,%02d,%02d' ${move} ${xoff} ${yoff} ${roff})"
}

# check whether move is valid (no overlap between sprite and static buffer)
function check_bounds {
  # set vars from input
  y=$1  # y position 
  x=$2  # x position
  r=$3  # rotation state
  # temp sprite for bounds check
  if [[ "${r}" != "${rpos}" ]]; then
    mapfile -t cb_sprite <<< "$(get_sprite $tidx $r 't')"
  else
    cb_sprite=( "${sprite[@]}" )
  fi
  # keep rotation index in range [-3:3]
  : $((r%=4))
  # set x and y offsets from rotation system for tetrimino and rotation state
#  cb_rot_offsets="$(get_rotation_offsets $tidx $r)"
  cb_rot_offsets=${!rot_ref:$(($r*2)):2}
  cb_rx="${cb_rot_offsets:0:1}"
  cb_ry="${cb_rot_offsets:1:1}"

  # loop through wall kick offsets if r!=rpos
# wk_sys="${wallkick_system[${wsidx}]}"
  cb_wk_offsets=${wk_sys}[$rpos$r]
  # for wki 0:${#wk_offsets}/2
  # wkx=${wk_offsets:wki:1} - 2
  # wky=${wk_offsets:wki+1:1} - 2

  # check for overlap of sprite and static buffer
  for j in "${!cb_sprite[@]}"; do 
    row=$(($y+$j+$cb_ry))
    for ((i=0; i<${#cb_sprite[$j]}; i++)); do 
      col=$(($x+$i+$cb_rx))
      # if sprite is not blank
      if [[ "${cb_sprite[$j]:$i:1}" != " " ]]; then
        # if row/col exceed bounds or static buffer not blank
        if [[ $row -gt 21 || $col -lt 0 || $col -gt 9 || \
          "${sb[$row]:$col:1}" != " " ]]; then
          return 1
        fi
      fi
    done    
  done
  # no collision - move is valid
  return 0
}

# get x,y offsets for tetrimino in rotation state for current rotation system
#function get_rotation_offsets {
#  local ti=$1
#  local ri=$2
#  ref=${rot_sys}[${ti}]
#  printf '%s' "${!ref:$(($ri*2)):2}"
#  return
#}

# find bottom ypos (row) if sprite were slammed down
function find_bottom {
  ybottom=$ypos
  valid=0
  # skip rows that are clear 
  while [[ "${sb[$(($ybottom + 4))]}" == "          " ]]; do
    : $((ybottom++))
  done
  while [[ "${valid}" == "0" ]]; do
    : $((ybottom++))
    check_bounds $ybottom $xpos $rpos
    valid=$?
  done
  : $((ybottom--))
  return ${ybottom}
}

function get_sprite {
  # set vars from input
  sidx=${1}
  rot=${2}
  t_or_c=${3}
  case "$t_or_c" in 
    't') tetrimino="${tetriminoes[${sidx}]}" ;;
    'c') tetrimino="${connections[${sidx}]}" ;;
    *) printf '%s' Error; exit ;;
  esac   
  ref=${tetrimino}[@]
  # keep rotation index in range [-3:3]
  : $((rot%=4))

  # get sprite height (rows) and start index
  len=${length[$sidx]: $rot:1}
  start=${start[$sidx]: $rot:1}

  # prepare sprite array
  temp_sprite=()
  for ((i=0; i<$len; i++)); do 
    temp_sprite[$i]="${!ref:$(($start + $i)):1}"
  done
  printf '%s\n' "${temp_sprite[@]}"
}

# given a cleared line, set broken bit to any tetrimino that intersects line
function update_connect_buffer {
  # input is index of cleared line
  for ((element=0; element<10; element++)); do
    n=0
    process_element ${1} ${element}
  done
}

# set broken bit for each connected element in a tetrimino
function process_element {
  # input  
  y=${1}
  x=${2}
#  display_screen
#  printf '%s\n' "Processing $y,$x"
#  sleep 5
  val="${cb[$y]:$x:1}"
  # if already broken, return
  [[ "$val" == "0" ]] && return
  # set this element to broken
  cb[$y]="${cb[$y]:0:$x}0${cb[$y]:$((x+1))}"
  # test for connection in each direction, process that element
  # test whether next element is 0 to prevent backtracking
  if [[ $(( 0x$val & 1 )) -gt 0 && "${cb[$(($y-1))]:$x:1}" != "0" ]]; then # up 
    y_arr[$n]=$y; x_arr[$n]=$x; val_arr[$n]=$val; : $((n++))
    process_element $(($y-1)) $x
    : $((n--)); y=${y_arr[$n]}; x=${x_arr[$n]}; val=${val_arr[$n]}
  fi
  if [[ $(( 0x$val & 2 )) -gt 0 && "${cb[$y]:$(($x-1)):1}" != "0" ]]; then # left
    y_arr[$n]=$y; x_arr[$n]=$x; val_arr[$n]=$val; : $((n++))
    process_element $y $(($x-1))
    : $((n--)); y=${y_arr[$n]}; x=${x_arr[$n]}; val=${val_arr[$n]}
  fi
  if [[ $(( 0x$val & 4 )) -gt 0 && "${cb[$y]:$(($x+1)):1}" != "0" ]]; then # right 
    y_arr[$n]=$y; x_arr[$n]=$x; val_arr[$n]=$val; : $((n++))
    process_element $y $(($x+1))
    : $((n--)); y=${y_arr[$n]}; x=${x_arr[$n]}; val=${val_arr[$n]}
  fi
  if [[ $(( 0x$val & 8 )) -gt 0 && "${cb[$(($y+1))]:$x:1}" != "0" ]]; then # down 
    y_arr[$n]=$y; x_arr[$n]=$x; val_arr[$n]=$val; : $((n++))
    process_element $(($y+1)) $x
    : $((n--)); y=${y_arr[$n]}; x=${x_arr[$n]}; val=${val_arr[$n]}
  fi

}

function clear_lines {
#  printf '%s\n' "Checking lines"
  lines=()
  # build array of full lines
#  for ((i=0; i<$(( ${#db[@]} - 1)); i++)); do 
  for i in "${!db[@]}"; do #((i=0; i<${#db[@]}; i++)); do
    [[ "${db[$i]// /}" == "${db[$i]}" ]] && lines+=("$i")
  done
  # invert color on full lines
  for i in "${lines[@]}"; do
    db[$i]="V${db[$i]}R"
    # update connect buffer for line (propagate "broken" bit)
    update_connect_buffer $i
#    printf '%s\n' "Updated line $i"
#    sleep 1
  done
  if [[ ${#lines[@]} -ne 0 ]]; then
    display_screen
#    printf '%s\n' "Clearing lines ${lines[@]}"
#    printf '%s\n' "${lines[@]}"
    sleep 1
    # map old buffer indices to new buffer indices to remove cleared lines
    # build list of valid indices
    indices=""
    for (( i=$((0 - ${#lines[@]})); i<22; i++ )); do
      indices="${indices}","${i}"
    done
    # remove indices of cleared lines
    for line in "${lines[@]}"; do
      indices="${indices/,$line/}"
    done
    # remove leading comma
    indices="${indices/,/}"
    # replace commas with newlines to separate elements
    indices="${indices//,/\\n}"
    # assign to remap array
    mapfile -t remap <<< "$( printf '%b' "${indices[@]}" )"
#    printf '%s\n' "${remap[@]}"
#    sleep 20
    # shift lines down to fill cleared lines
    for ((i=$(( ${#remap[@]} - 1 )); i>-1; i--)); do
      # if underflow, manually set to sb[0]
      if [[ ${remap[$i]} -lt 0 ]]; then
        db[$i]="${sb[0]}"
        cb[$i]="${sb[0]}"
      # else set to remapped index value
      else
        db[$i]="${db[${remap[$i]}]}"
        cb[$i]="${cb[${remap[$i]}]}"
      fi
    done
    sb=( "${db[@]}" )
    display_screen
#    printf '%s\n' "${!db[@]}"
#    sleep 20
  fi
}

function check_squares {
  # input
  y=$ypos  # y position 
  x=$xpos  # x position
#  r=$rpos  # rotation state
  # get connection sprite of current tetrimino
  #mapfile -t cs_sprite <<< "$(get_sprite $tidx $r 'c')"
#  printf '%s\n' "${cs_sprite[@]}"
  # build arrays of non-blank row indices, col indices  
  mapfile -t rows <<< "$( printf '%s\n' "${!c_sprite[@]}" )" 
  cols=( "${rows[@]}" )
  for i in "${!rows[@]}"; do
    # check if empty row
    [[ "${c_sprite[$i]// /}" == "" ]] && rows[$i]=""
    # build column
    temp=""
    for j in "${!c_sprite[@]}"; do
      temp="${temp}${c_sprite[$j]:$i:1}"
    done
    # check if emtpy col
    [[ "${temp// /}" == "" ]] && cols[$i]=""
  done
#  printf '%s\n' "${rows[@]}"
#  printf '%s\n' "${cols[@]}"
  # convert arrays to strings, use positions to get min, max
  yoffs="${rows[@]}"
  yoffs="${yoffs// /}"
  ymin="${yoffs:0:1}"
  ymax="${yoffs: -1:1}"

  xoffs="${cols[@]}"
  xoffs="${xoffs// /}"
  xmin="${xoffs:0:1}"
  xmax="${xoffs: -1:1}"

  # use min/max offsets to calculate indices for square window frames
  # set top/bottom bounds for window
  y0=$(( $ypos + $ymax - 3 ))
  [[ $y0 -lt  0 ]] && y0=0
  y1=$(( $ypos + $ymin ))
  [[ $y1 -gt 18 ]] && y1=18

  # set left/right bounds for window
  x0=$(( $xpos + $xmax - 3 ))
  [[ $x0 -lt  0 ]] && x0=0
  x1=$(( $xpos + $xmin ))
  [[ $x1 -gt  6 ]] && x1=6

  # test each 4x4 window
  for (( y=$y0; y<=$y1; y++ )); do
    for (( x=$x0; x<=$x1; x++ )); do
      # build frame
      # update without copying all 16 values?
      square="${cb[$y]:$x:4}${cb[$(($y+1))]:$x:4}"
      square="${square}${cb[$(($y+2))]:$x:4}${cb[$(($y+3))]:$x:4}"
  
      # continue if element from broken line or empty
      # depending on which element is broken, can skip multiple frames
      [[ "${square}" != "${square//0/X}" ]] && continue
      [[ "${square}" != "${square// /X}" ]] && continue
      
      # none of the 4 edges' values can have a connection in that direction
      #   num & n : returns 0 if bit is 0, else n
      for i in  0  1  2  3; do [[ $(( 0x${square:$i:1} & 1 )) -gt 0 ]] && continue; done
      for i in  0  4  8 12; do [[ $(( 0x${square:$i:1} & 2 )) -gt 0 ]] && continue; done
      for i in  3  7 11 15; do [[ $(( 0x${square:$i:1} & 4 )) -gt 0 ]] && continue; done
      for i in 12 13 14 15; do [[ $(( 0x${square:$i:1} & 8 )) -gt 0 ]] && continue; done

      # square found
      db_square="${db[$y]:$x:4}${db[$(($y+1))]:$x:4}"
      db_square="${db_square}${db[$(($y+2))]:$x:4}${db[$(($y+3))]:$x:4}"
      el="${db_square:0:1}"
      if [[ "${db_square//$el/}" == "" ]]; then # if all identical
        for (( i=$y; i<$(($y+4)); i++ )); do 
          db[$i]="${db[$i]:0:$x}UUUU${db[$i]:$(($x+4))}" # gold
        done
      else
        for (( i=$y; i<$(($y+4)); i++ )); do 
          db[$i]="${db[$i]:0:$x}GGGG${db[$i]:$(($x+4))}" # silver
        done
      fi

      # update connect buffer to avoid rechecking elements in square
      for (( i=$y; i<$(($y+4)); i++ )); do 
        cb[$i]="${cb[$i]:0:$x}0000${cb[$i]:$(($x+4))}"
      done

      # return since there can be only one square at a time
      return
    done
  done
}

# init variables ---------------------------------------------------------------
# turn on debug
debug="0"

# set lock delay time (in nanoseconds)
lock_delay=1000000000

# initialize 'bag' of next n tetriminoes
bag=""
bsize="${#tetriminoes[@]}"
init_bag
bidx=0

# initialize static buffer
declare -a sb
init_static_buffer

# initialize dynamic buffer
declare -a db
init_dynamic_buffer

declare -a cb 
init_connect_buffer

# initialize preview buffer
declare -a pb
init_preview_buffer

# set rotation system
rsidx=7 # TNT
rot_sys="${rotation_system[${rsidx}]}"

# set wall kick system
wsidx=3 # SRS1
wk_sys="${wallkick_system[${wsidx}]}"

# initialize tetrimino
ypos=10
xpos=4
get_next_from_bag
tidx=$?
rpos=0
# set x and y offsets from rotation system for tetrimino and rotation state
#rot_offsets="$(get_rotation_offsets $tidx $rpos)"
rot_ref=${rot_sys}[${tidx}]
rot_offsets=${!rot_ref:$(($rpos*2)):2}
rx="${rot_offsets:0:1}"
ry="${rot_offsets:1:1}"

mapfile -t sprite <<< "$(get_sprite $tidx $rpos 't')"
find_bottom
ghost_ypos=$?
# draw sprite
draw_sprite $ypos $xpos

# initialize screen from dynamic buffer and display
declare -a screen
clear
display_screen

lock_delay_start=$(date +%s%N)
# event loop -------------------------------------------------------------------
while [[ true ]]; do
  yoff=0; xoff=0; roff=0
  read -s -t 0.1 -n 1 move 
  case ${move} in
    'a') xoff=-1 ;; # left 
    'd') xoff=1  ;; # right
    'w') yoff=$(($ghost_ypos - $ypos)) ;; # up
#    'w') yoff=-1 ;; # up
    's') yoff=1  ;; # down
    'e') roff=1  ;; # rotate counter-clockwisee
    'r') roff=-1 ;; # rotate clockwise
    'f') (( bidx+=1 )); get_next_from_bag; tidx=$? ;;
    'q') break ;;   # quit
    '') ;;
    *) echo "Unknown input: ${move}" ;; # unknown input
  esac
  # if move was made
  if [[ $move ]]; then
    # check bounds with new position
    check_bounds $(($ypos + $yoff)) $(($xpos + $xoff)) $(($rpos + $roff))
    valid_move=$?
    if [[ "${valid_move}" == "0" ]]; then
      # update buffer
      db=( "${sb[@]}" )
      # update sprite position
      ((ypos+=$yoff)); ((xpos+=$xoff)); ((rpos+=$roff))
      : $((rpos%=4))
      mapfile -t sprite <<< "$(get_sprite $tidx $rpos 't')"
      if [[ $roff -ne 0 ]]; then
        #rot_offsets="$(get_rotation_offsets $tidx $rpos)"
        rot_offsets=${!rot_ref:$(($rpos*2)):2}
        rx="${rot_offsets:0:1}"
        ry="${rot_offsets:1:1}"
      fi
      draw_sprite ${ypos} ${xpos}
      # update ghost position
      find_bottom
      ghost_ypos=$?
      # reset lock delay timer
      lock_delay_start=$(date +%s%N)
    fi
  fi
  # display current state
  display_screen
  # check if hit bottom
  #check_bounds $(($ypos + 1)) $xpos $rpos
  #valid_move=$?
  lock_delay_elapsed=$(( $(date +%s%N) - $lock_delay_start ))
  # if valid to drop and exceeded timer, then drop, else
  # if hit bottom and lock delay expired
  if [[ $ghost_ypos -eq $ypos && $lock_delay_elapsed -gt $lock_delay ]]; then
#  if [[ "${valid_move}" != "0" && $lock_delay_elapsed -gt $lock_delay ]]; then
    # draw sprite to connect buffer
    mapfile -t c_sprite <<< "$(get_sprite $tidx $rpos 'c')"
    draw_sprite_c ${ypos} ${xpos}
    # check for complete squares
    check_squares
    # save dynamic buffer to static buffer
    sb=( "${db[@]}" )
    # set next tetrimino from bag
    : $((bidx++))
    get_next_from_bag
    tidx=$?
    rot_ref=${rot_sys}[${tidx}]
    ypos=0; xpos=5; rpos=0
    mapfile -t sprite <<< "$(get_sprite $tidx $rpos 't')"
    #rot_offsets="$(get_rotation_offsets $tidx $rpos)"
    rot_offsets=${!rot_ref:$(($rpos*2)):2}
    rx="${rot_offsets:0:1}"
    ry="${rot_offsets:1:1}"
    # check for cleared lines
    clear_lines
    # update ghost position
    find_bottom
    ghost_ypos=$?
  fi
done

# return cursor to just below well
tput cup 30 0


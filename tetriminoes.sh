#!/bin/bash
# META =========================================================================
# Title: Tetriminoes.sh
# Usage: Tetriminoes.sh
# Description: Tetrimino arrays for terminal Tetris.
# Author: Colin Shea
# Created: 2015-12-08
# TODO:
# - sprite arrays for each tetrimino
# - rotation logic

# Notes:
# - use uniform array sizes (4x4x4) or minimum bounding box?
# - do Z, S, I, and O really need 4 rotation states? TNT vs Standard rotation

# minimum  - TNT ===============================================================
declare -a eye
eye[0]="    "; eye[4]=" I  "
eye[1]="    "; eye[5]=" I  "
eye[2]="IIII"; eye[6]=" I  "
eye[3]="    "; eye[7]=" I  "

declare -a jay
jay[0]="J  "; jay[3]=" JJ"; jay[6]="JJJ";  jay[9]="  J"
jay[1]="JJJ"; jay[4]=" J "; jay[7]="  J"; jay[10]="  J"
jay[2]="   "; jay[5]=" J "; jay[8]="   "; jay[11]=" JJ"

declare -a ell
ell[0]="  L"; ell[3]="L  "; ell[6]="LLL";  ell[9]="LL "
ell[1]="LLL"; ell[4]="L  "; ell[7]="L  "; ell[10]=" L "
ell[2]="   "; ell[5]="LL "; ell[8]="   "; ell[11]=" L "

declare -a ess
ess[0]=" SS"; ess[3]=" S "
ess[1]="SS "; ess[4]=" SS"
ess[2]="   "; ess[5]="  S"

declare -a zee
zee[0]="ZZ "; zee[3]=" Z "
zee[1]=" ZZ"; zee[4]="ZZ "
zee[2]="   "; zee[5]="Z  "

declare -a tee 
tee[0]=" T "; tee[3]=" T "; tee[6]="   ";  tee[9]=" T "
tee[1]="TTT"; tee[4]=" TT"; tee[7]="TTT"; tee[10]="TT "
tee[2]="   "; tee[5]=" T "; tee[8]=" T "; tee[11]=" T "

declare -a ohh
ohh[0]="OO"
ohh[1]="OO"

# uniform  - TNT ===============================================================
declare -a eye
eye[0]="    "; eye[4]=" I  ";  eye[8]="    "; eye[12]=" I  "
eye[1]="    "; eye[5]=" I  ";  eye[9]="    "; eye[13]=" I  "
eye[2]="IIII"; eye[6]=" I  "; eye[10]="IIII"; eye[14]=" I  "
eye[3]="    "; eye[7]=" I  "; eye[11]="    "; eye[15]=" I  "

declare -a jay
jay[0]="J  "; jay[3]=" JJ"; jay[6]="JJJ";  jay[9]="  J"
jay[1]="JJJ"; jay[4]=" J "; jay[7]="  J"; jay[10]="  J"
jay[2]="   "; jay[5]=" J "; jay[8]="   "; jay[11]=" JJ"

declare -a ell
ell[0]="  L"; ell[3]="L  "; ell[6]="LLL";  ell[9]="LL "
ell[1]="LLL"; ell[4]="L  "; ell[7]="L  "; ell[10]=" L "
ell[2]="   "; ell[5]="LL "; ell[8]="   "; ell[11]=" L "

declare -a ess
ess[0]=" SS"; ess[3]=" S "; ess[6]=" SS";  ess[9]=" S "
ess[1]="SS "; ess[4]=" SS"; ess[7]="SS "; ess[10]=" SS"
ess[2]="   "; ess[5]="  S"; ess[8]="   "; ess[11]="  S"

declare -a zee
zee[0]="ZZ "; zee[3]=" Z "; zee[6]="ZZ ";  zee[9]=" Z "
zee[1]=" ZZ"; zee[4]="ZZ "; zee[7]=" ZZ"; zee[10]="ZZ "
zee[2]="   "; zee[5]="Z  "; zee[8]="   "; zee[11]="Z  "

declare -a tee 
tee[0]=" T "; tee[3]=" T "; tee[6]="   ";  tee[9]=" T "
tee[1]="TTT"; tee[4]=" TT"; tee[7]="TTT"; tee[10]="TT "
tee[2]="   "; tee[5]=" T "; tee[8]=" T "; tee[11]=" T "

declare -a ohh
ohh[0]="OO"; ohh[2]="OO"; ohh[4]="OO"; ohh[6]="OO"
ohh[1]="OO"; ohh[3]="OO"; ohh[5]="OO"; ohh[7]="OO"

# uniform - Standard ===========================================================
declare -a eye
eye[0]="    "; eye[4]="  I ";  eye[8]="    "; eye[12]=" I  "
eye[1]="IIII"; eye[5]="  I ";  eye[9]="    "; eye[13]=" I  "
eye[2]="    "; eye[6]="  I "; eye[10]="IIII"; eye[14]=" I  "
eye[3]="    "; eye[7]="  I "; eye[11]="    "; eye[15]=" I  "

declare -a jay
jay[0]="J  "; jay[3]=" JJ"; jay[6]="   ";  jay[9]=" J "
jay[1]="JJJ"; jay[4]=" J "; jay[7]="JJJ"; jay[10]=" J "
jay[2]="   "; jay[5]=" J "; jay[8]="  J"; jay[11]="JJ "

declare -a ell
ell[0]="  L"; ell[3]=" L "; ell[6]="   ";  ell[9]="LL "
ell[1]="LLL"; ell[4]=" L "; ell[7]="LLL"; ell[10]=" L "
ell[2]="   "; ell[5]=" LL"; ell[8]="L  "; ell[11]=" L "

declare -a ess
ess[0]=" SS"; ess[3]=" S "; ess[6]="   ";  ess[9]="S  "
ess[1]="SS "; ess[4]=" SS"; ess[7]=" SS"; ess[10]="SS "
ess[2]="   "; ess[5]="  S"; ess[8]="SS "; ess[11]=" S "

declare -a zee
zee[0]="ZZ "; zee[3]="  Z"; zee[6]="   ";  zee[9]=" Z "
zee[1]=" ZZ"; zee[4]=" ZZ"; zee[7]="ZZ "; zee[10]="ZZ "
zee[2]="   "; zee[5]=" Z "; zee[8]=" ZZ"; zee[11]="Z  "

declare -a tee 
tee[0]=" T "; tee[3]=" T "; tee[6]="   ";  tee[9]=" T "
tee[1]="TTT"; tee[4]=" TT"; tee[7]="TTT"; tee[10]="TT "
tee[2]="   "; tee[5]=" T "; tee[8]=" T "; tee[11]=" T "

declare -a ohh
ohh[0]=" OO "; ohh[3]=" OO "; ohh[6]=" OO ";  ohh[9]=" OO "
ohh[1]=" OO "; ohh[4]=" OO "; ohh[7]=" OO "; ohh[10]=" OO "
ohh[2]="    "; ohh[5]="    "; ohh[8]="    "; ohh[11]="    "

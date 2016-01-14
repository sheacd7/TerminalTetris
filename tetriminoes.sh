#!/bin/bash
# META =========================================================================
# Title: Tetriminoes.sh
# Usage: Tetriminoes.sh
# Description: Tetrimino arrays for terminal Tetris.
# Author: Colin Shea
# Created: 2015-12-08

# Each tetrimino rotation state is saved in a minimum bounding box such that
#   there are at most 2 empty elements.
# The relative position of each sprite is expressed in the RotationSystem data
#   which provide x,y offsets for each tetrimino and rotation state.

# TODO:

declare -a tetriminoes
tetriminoes[0]="eye"
tetriminoes[1]="jay"
tetriminoes[2]="ell"
tetriminoes[3]="ess"
tetriminoes[4]="zee"
tetriminoes[5]="tee"
tetriminoes[6]="ohh"

declare -a eye
               eye[1]="I";                eye[6]="I"
               eye[2]="I";                eye[7]="I"
eye[0]="IIII"; eye[3]="I"; eye[5]="IIII"; eye[8]="I"
               eye[4]="I";                eye[9]="I"

declare -a jay
jay[0]="J  "; jay[2]="JJ"; jay[5]="JJJ"; jay[7]=" J"
jay[1]="JJJ"; jay[3]="J "; jay[6]="  J"; jay[8]=" J"
              jay[4]="J ";               jay[9]="JJ"

declare -a ell
ell[0]="  L"; ell[2]="L "; ell[5]="LLL"; ell[7]="LL"
ell[1]="LLL"; ell[3]="L "; ell[6]="L  "; ell[8]=" L"
              ell[4]="LL";               ell[9]=" L"

declare -a ess
ess[0]=" SS"; ess[2]="S "; ess[5]=" SS"; ess[7]="S "
ess[1]="SS "; ess[3]="SS"; ess[6]="SS "; ess[8]="SS"
              ess[4]=" S";               ess[9]=" S"

declare -a zee
zee[0]="ZZ "; zee[2]=" Z"; zee[5]="ZZ "; zee[7]=" Z"
zee[1]=" ZZ"; zee[3]="ZZ"; zee[6]=" ZZ"; zee[8]="ZZ"
              zee[4]="Z ";               zee[9]="Z "

declare -a tee 
tee[0]=" T "; tee[2]="T ";               tee[7]=" T"
tee[1]="TTT"; tee[3]="TT"; tee[5]="TTT"; tee[8]="TT"
              tee[4]="T "; tee[6]=" T "; tee[9]=" T"

declare -a ohh
ohh[0]="OO"; ohh[2]="OO"; ohh[4]="OO"; ohh[6]="OO"
ohh[1]="OO"; ohh[3]="OO"; ohh[5]="OO"; ohh[7]="OO"

# reference to current tetrimino and rotation state
declare -a connections
connections[0]="eye_c"
connections[1]="jay_c"
connections[2]="ell_c"
connections[3]="ess_c"
connections[4]="zee_c"
connections[5]="tee_c"
connections[6]="ohh_c"

declare -a eye_c
                 eye_c[1]="8";                  eye_c[6]="8"
                 eye_c[2]="9";                  eye_c[7]="9"
eye_c[0]="4662"; eye_c[3]="9"; eye_c[5]="4662"; eye_c[8]="9"
                 eye_c[4]="1";                  eye_c[9]="1"

declare -a jay_c
jay_c[0]="8  "; jay_c[2]="C2"; jay_c[5]="46A"; jay_c[7]=" 8"
jay_c[1]="562"; jay_c[3]="9 "; jay_c[6]="  1"; jay_c[8]=" 9"
                jay_c[4]="1 ";                 jay_c[9]="43"

declare -a ell_c
ell_c[0]="  8"; ell_c[2]="8 "; ell_c[5]="C62"; ell_c[7]="4A"
ell_c[1]="463"; ell_c[3]="9 "; ell_c[6]="1  "; ell_c[8]=" 9"
                ell_c[4]="52";                 ell_c[9]=" 1"

declare -a ess_c
ess_c[0]=" C2"; ess_c[2]="8 "; ess_c[5]=" C2"; ess_c[7]="8 "
ess_c[1]="43 "; ess_c[3]="5A"; ess_c[6]="43 "; ess_c[8]="5A"
                ess_c[4]=" 1";                 ess_c[9]=" 1"

declare -a zee_c
zee_c[0]="4A "; zee_c[2]=" 8"; zee_c[5]="4A "; zee_c[7]=" 8"
zee_c[1]=" 52"; zee_c[3]="C3"; zee_c[6]=" 52"; zee_c[8]="C3"
                zee_c[4]="1 ";                 zee_c[9]="1 "

declare -a tee_c
tee_c[0]=" 8 "; tee_c[2]="8 ";                 tee_c[7]=" 8"
tee_c[1]="472"; tee_c[3]="D2"; tee_c[5]="4E2"; tee_c[8]="4B"
                tee_c[4]="1 "; tee_c[6]=" 1 "; tee_c[9]=" 1"

declare -a ohh_c
ohh_c[0]="CA"; ohh_c[2]="CA"; ohh_c[4]="CA"; ohh_c[6]="CA"
ohh_c[1]="53"; ohh_c[3]="53"; ohh_c[5]="53"; ohh_c[7]="53"


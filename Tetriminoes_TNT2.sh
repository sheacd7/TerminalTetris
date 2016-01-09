#!/bin/bash

# length (rows), x offset, y offset

declare -a eye
# 1,0,2        # 4,1,0     # 1,0,2        # 4,1,0
               eye[1]="I";                eye[6]="I"
               eye[2]="I";                eye[7]="I"
eye[0]="IIII"; eye[3]="I"; eye[5]="IIII"; eye[8]="I"
               eye[4]="I";                eye[9]="I"

declare -a jay
# 2,0,0       # 3,1,0      # 2,0,0       # 3,1,0
jay[0]="J  "; jay[2]="JJ"; jay[5]="JJJ"; jay[7]=" J"
jay[1]="JJJ"; jay[3]="J "; jay[6]="  J"; jay[8]=" J"
              jay[4]="J ";               jay[9]="JJ"

declare -a ell
# 2,0,0       # 3,0,0      # 2,0,0       # 3,0,0
ell[0]="  L"; ell[2]="L "; ell[5]="LLL"; ell[7]="LL"
ell[1]="LLL"; ell[3]="L "; ell[6]="L  "; ell[8]=" L"
              ell[4]="LL";               ell[9]=" L"

declare -a ess
# 2,0,0       # 3,1,0      # 2,0,0       # 3,1,0
ess[0]=" SS"; ess[2]="S "; ess[5]=" SS"; ess[7]="S "
ess[1]="SS "; ess[3]="SS"; ess[6]="SS "; ess[8]="SS"
              ess[4]=" S";               ess[9]=" S"

declare -a zee
# 2,0,0       # 3,0,0      # 2,0,0       # 3,0,0
zee[0]="ZZ "; zee[2]=" Z"; zee[5]="ZZ "; zee[7]=" Z"
zee[1]=" ZZ"; zee[3]="ZZ"; zee[6]=" ZZ"; zee[8]="ZZ"
              zee[4]="Z ";               zee[9]="Z "

declare -a tee 
# 2,0,0       # 3,1,0      # 2,0,1       # 3,0,0
tee[0]=" T "; tee[2]="T ";               tee[7]=" T"
tee[1]="TTT"; tee[3]="TT"; tee[5]="TTT"; tee[8]="TT"
              tee[4]="T "; tee[6]=" T "; tee[9]=" T"

declare -a ohh
# 2,0,0      # 2,0,0      # 2,0,0      # 2,0,0
ohh[0]="OO"; ohh[2]="OO"; ohh[4]="OO"; ohh[6]="OO"
ohh[1]="OO"; ohh[3]="OO"; ohh[5]="OO"; ohh[7]="OO"

# reference to current tetrimino and rotation state
declare -a tetriminoes
tetriminoes[0]="eye"
tetriminoes[1]="jay"
tetriminoes[2]="ell"
tetriminoes[3]="ess"
tetriminoes[4]="zee"
tetriminoes[5]="tee"
tetriminoes[6]="ohh"

declare -a eye_c
eye_c[0]="    "; eye_c[4]=" 8  ";  eye_c[8]="    "; eye_c[12]=" 8  "
eye_c[1]="    "; eye_c[5]=" 9  ";  eye_c[9]="    "; eye_c[13]=" 9  "
eye_c[2]="4662"; eye_c[6]=" 9  "; eye_c[10]="4662"; eye_c[14]=" 9  "
eye_c[3]="    "; eye_c[7]=" 1  "; eye_c[11]="    "; eye_c[15]=" 1  "

declare -a jay_c
jay_c[0]="8  "; jay_c[3]=" C2"; jay_c[6]="46A";  jay_c[9]="  8"
jay_c[1]="562"; jay_c[4]=" 9 "; jay_c[7]="  1"; jay_c[10]="  9"
jay_c[2]="   "; jay_c[5]=" 1 "; jay_c[8]="   "; jay_c[11]=" 43"

declare -a ell_c
ell_c[0]="  8"; ell_c[3]="8  "; ell_c[6]="C62";  ell_c[9]="4A "
ell_c[1]="463"; ell_c[4]="9  "; ell_c[7]="1  "; ell_c[10]=" 9 "
ell_c[2]="   "; ell_c[5]="52 "; ell_c[8]="   "; ell_c[11]=" 1 "

declare -a ess_c
ess_c[0]=" C2"; ess_c[3]=" 8 "; ess_c[6]=" C2";  ess_c[9]=" 8 "
ess_c[1]="43 "; ess_c[4]=" 5A"; ess_c[7]="43 "; ess_c[10]=" 5A"
ess_c[2]="   "; ess_c[5]="  1"; ess_c[8]="   "; ess_c[11]="  1"

declare -a zee_c
zee_c[0]="4A "; zee_c[3]=" 8 "; zee_c[6]="4A ";  zee_c[9]=" 8 "
zee_c[1]=" 52"; zee_c[4]="C3 "; zee_c[7]=" 52"; zee_c[10]="C3 "
zee_c[2]="   "; zee_c[5]="1  "; zee_c[8]="   "; zee_c[11]="1  "

declare -a tee_c
tee_c[0]=" 8 "; tee_c[3]=" 8 "; tee_c[6]="   ";  tee_c[9]=" 8 "
tee_c[1]="472"; tee_c[4]=" D2"; tee_c[7]="4E2"; tee_c[10]="4B "
tee_c[2]="   "; tee_c[5]=" 1 "; tee_c[8]=" 1 "; tee_c[11]=" 1 "

declare -a ohh_c
ohh_c[0]="CA"; ohh_c[2]="CA"; ohh_c[4]="CA"; ohh_c[6]="CA"
ohh_c[1]="53"; ohh_c[3]="53"; ohh_c[5]="53"; ohh_c[7]="53"

# reference to current tetrimino and rotation state
declare -a connections
connections[0]="eye_c"
connections[1]="jay_c"
connections[2]="ell_c"
connections[3]="ess_c"
connections[4]="zee_c"
connections[5]="tee_c"
connections[6]="ohh_c"

# offsets are in ( x, y) where +x: right, +y: down
# values are relative to basic rotation state, so addiditve w/ rotation offsets

# how to organize for quick access 
#  store as unsigned values with +2 bias? avoids storing sign
#  


# basic rotation 
declare -a wallkick_system
wallkick_system[0]="AWK1"  # Arika/TGM
wallkick_system[1]="AWK2"  # Arika/TGM3
wallkick_system[2]="DWK"   # DTET
wallkick_system[3]="SWK1"  # SRS-Guideline
wallkick_system[4]="SWK2"  # SRS-TGM3-TI/TGM-Ace
wallkick_system[5]="TWK"   # The New Tetris

declare -A AWK1
AWK1[0+]=223212; AWK1[1+]=223212; AWK1[2+]=223212; AWK1[3+]=223212
AWK1[0-]=223212; AWK1[1-]=223212; AWK1[2-]=223212; AWK1[3-]=223212

declare -A AWK1I
AWK1I[0+]=22;    AWK1I[1+]=22;    AWK1I[2+]=22;    AWK1I[3+]=22
AWK1I[0-]=22;    AWK1I[1-]=22;    AWK1I[2-]=22;    AWK1I[3-]=22

declare -A AWK2
AWK2[0+]=223212; AWK2[1+]=223212; AWK2[2+]=223212; AWK2[3+]=223212
AWK2[0-]=223212; AWK2[1-]=223212; AWK2[2-]=223212; AWK2[3-]=223212

declare -A AWK2I
AWK2I[0+]=2202320330; AWK2I[1+]=2212421043
AWK2I[0-]=2212421043; AWK2I[1-]=2242124114
AWK2I[2+]=2242124114; AWK2I[3+]=2232023401
AWK2I[2-]=2232023401; AWK2I[3-]=2202320330

declare -A DWK
DWK[0+]=223212233313; DWK[1+]=223212233313
DWK[0-]=221232231333; DWK[1-]=221232231333

DWK[2+]=223212233313; DWK[3+]=223212233313
DWK[2-]=221232231333; DWK[3-]=221232231333

declare -A DWKI
DWKI[0+]=2202320330;DWKI[1+]=2212421043;DWKI[0-]=2212421043;DWKI[1-]=2242124114
DWKI[2+]=2242124114;DWKI[3+]=2232023401;DWKI[2-]=2232023401;DWKI[3-]=2202320330

declare -A SRS1
SRS1[0+]=2212112414;SRS1[1+]=2232332030;SRS1[2+]=2232312434;SRS1[3+]=2212132010
SRS1[0-]=2232312434;SRS1[1-]=2232332030;SRS1[2-]=2212112414;SRS1[3-]=2212132010

declare -A SRS1I
SRS1I[0+]=2202320330; SRS1I[1+]=2212421043
SRS1I[0-]=2212421043; SRS1I[1-]=2242124114
SRS1I[2+]=2242124114; SRS1I[3+]=2232023401
SRS1I[2-]=2232023401; SRS1I[3-]=2202320330

declare -A SRS2
SRS2[0+]=2212112414;SRS2[1+]=2232332030;SRS2[2+]=2232312434;SRS2[3+]=2212132010
SRS2[0-]=2232312434;SRS2[1-]=2232332030;SRS2[2-]=2212112414;SRS2[3-]=2212132010

declare -A SRS2I
SRS2I[0+]=2202323003; SRS2I[1+]=2212421043
SRS2I[0-]=2242121043; SRS2I[1-]=2242124114
SRS2I[2+]=2242124113; SRS2I[3+]=2202320134
SRS2I[2-]=2202320133; SRS2I[3-]=2232023003

# notes ========================================================================

# AWK1 - ARS/TGM
# basic rotation
# 1 space right of basic
# 1 space left of basic
# I does not kick
# L,J,T restricted depending on which blocks are occupied
#JLSZT
#rpos, roff  Test 0  Test 1  Test 2  
#any   any   ( 0, 0) ( 1, 0) (-1, 0) 

#I
#rpos, roff  Test 0
#any   any   ( 0, 0)

# AWK2 - ARS/TGM3
# same as TGM but adds
# I wall kicks
# I floor kicks
# T floor kicks
#JLSZT
#rpos, roff  Test 0  Test 1  Test 2  
#any   any   ( 0, 0) ( 1, 0) (-1, 0) 

#I 
#rpos, roff  Test 0  Test 1  Test 2  Test 3  Test 4
#0     +     ( 0, 0) (-2, 0) ( 1, 0) (-2, 1) ( 1,-2)
#0     -     ( 0, 0) (-1, 0) ( 2, 0) (-1,-2) ( 2, 1)
#1     +     ( 0, 0) (-1, 0) ( 2, 0) (-1,-2) ( 2, 1)
#1     -     ( 0, 0) ( 2, 0) (-1, 0) ( 2,-1) (-1, 2)
#2     +     ( 0, 0) ( 2, 0) (-1, 0) ( 2,-1) (-1, 2)
#2     -     ( 0, 0) ( 1, 0) (-2, 0) ( 1, 2) (-2,-1)
#3     +     ( 0, 0) ( 1, 0) (-2, 0) ( 1, 2) (-2,-1)
#3     -     ( 0, 0) (-2, 0) ( 1, 0) (-2, 1) ( 1,-2)

# DWK - DRS
# same as TGM but adds
# 1 space down
# 1 space down-left
# 1 space down-right
# symmetric wrt direction of rotation 
# no restriction from adjacent blocks
#JLSZT
#rpos, roff  Test 0  Test 1  Test 2  Test 3  Test 4  Test 5
#any   +     ( 0, 0) ( 1, 0) (-1, 0) ( 0, 1) ( 1, 1) (-1, 1)
#any   -     ( 0, 0) (-1, 0) ( 1, 0) ( 0, 1) (-1, 1) ( 1, 1)

#I 
#rpos, roff  Test 0  Test 1  Test 2  Test 3  Test 4
#0     +     ( 0, 0) (-2, 0) ( 1, 0) (-2, 1) ( 1,-2)
#0     -     ( 0, 0) (-1, 0) ( 2, 0) (-1,-2) ( 2, 1)
#1     +     ( 0, 0) (-1, 0) ( 2, 0) (-1,-2) ( 2, 1)
#1     -     ( 0, 0) ( 2, 0) (-1, 0) ( 2,-1) (-1, 2)
#2     +     ( 0, 0) ( 2, 0) (-1, 0) ( 2,-1) (-1, 2)
#2     -     ( 0, 0) ( 1, 0) (-2, 0) ( 1, 2) (-2,-1)
#3     +     ( 0, 0) ( 1, 0) (-2, 0) ( 1, 2) (-2,-1)
#3     -     ( 0, 0) (-2, 0) ( 1, 0) (-2, 1) ( 1,-2)

# SRS/Guideline
#JLSZT
#rpos, roff  Test 0  Test 1  Test 2  Test 3  Test 4
#0     +     ( 0, 0) (-1, 0) (-1,-1) ( 0, 2) (-1, 2)
#0     -     ( 0, 0) ( 1, 0) ( 1,-1) ( 0, 2) ( 1, 2)
#1     +     ( 0, 0) ( 1, 0) ( 1, 1) ( 0,-2) ( 1,-2)
#1     -     ( 0, 0) ( 1, 0) ( 1, 1) ( 0,-2) ( 1,-2)
#2     +     ( 0, 0) ( 1, 0) ( 1,-1) ( 0, 2) ( 1, 2)
#2     -     ( 0, 0) (-1, 0) (-1,-1) ( 0, 2) (-1, 2)
#3     +     ( 0, 0) (-1, 0) (-1, 1) ( 0,-2) (-1,-2)
#3     -     ( 0, 0) (-1, 0) (-1, 1) ( 0,-2) (-1,-2)

#I 
#rpos, roff  Test 0  Test 1  Test 2  Test 3  Test 4
#0     +     ( 0, 0) (-2, 0) ( 1, 0) (-2, 1) ( 1,-2)
#0     -     ( 0, 0) (-1, 0) ( 2, 0) (-1,-2) ( 2, 1)
#1     +     ( 0, 0) (-1, 0) ( 2, 0) (-1,-2) ( 2, 1)
#1     -     ( 0, 0) ( 2, 0) (-1, 0) ( 2,-1) (-1, 2)
#2     +     ( 0, 0) ( 2, 0) (-1, 0) ( 2,-1) (-1, 2)
#2     -     ( 0, 0) ( 1, 0) (-2, 0) ( 1, 2) (-2,-1)
#3     +     ( 0, 0) ( 1, 0) (-2, 0) ( 1, 2) (-2,-1)
#3     -     ( 0, 0) (-2, 0) ( 1, 0) (-2, 1) ( 1,-2)

# Arika SRS/TGM3-TI/TGM-Ace
# JLSZT - same as SRS/Guideline
# I     - new symmetric wall kicks
#JLSZT
#rpos, roff  Test 0  Test 1  Test 2  Test 3  Test 4
#0     +     ( 0, 0) (-1, 0) (-1,-1) ( 0, 2) (-1, 2)
#0     -     ( 0, 0) ( 1, 0) ( 1,-1) ( 0, 2) ( 1, 2)
#1     +     ( 0, 0) ( 1, 0) ( 1, 1) ( 0,-2) ( 1,-2)
#1     -     ( 0, 0) ( 1, 0) ( 1, 1) ( 0,-2) ( 1,-2)
#2     +     ( 0, 0) ( 1, 0) ( 1,-1) ( 0, 2) ( 1, 2)
#2     -     ( 0, 0) (-1, 0) (-1,-1) ( 0, 2) (-1, 2)
#3     +     ( 0, 0) (-1, 0) (-1, 1) ( 0,-2) (-1,-2)
#3     -     ( 0, 0) (-1, 0) (-1, 1) ( 0,-2) (-1,-2)

#I 
#rpos, roff  Test 0  Test 1  Test 2  Test 3  Test 4
#0     +     ( 0, 0) (-2, 0) ( 1, 0) ( 1,-2) (-2, 1)
#0     -     ( 0, 0) ( 2, 0) (-1, 0) (-1,-2) ( 2, 1)
#1     +     ( 0, 0) (-1, 0) ( 2, 0) (-1,-2) ( 2, 1)
#1     -     ( 0, 0) ( 2, 0) (-1, 0) ( 2,-1) (-1, 2)
#2     +     ( 0, 0) ( 2, 0) (-1, 0) ( 2,-1) (-1, 1)
#2     -     ( 0, 0) (-2, 0) ( 1, 0) (-2,-1) ( 1, 1)
#3     +     ( 0, 0) (-2, 0) ( 1, 0) (-2,-1) ( 1, 2)
#3     -     ( 0, 0) ( 1, 0) (-2, 0) ( 1,-2) (-2, 1)

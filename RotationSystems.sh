#!/bin/bash
# META =========================================================================
# Title: Tetriminoes.sh
# Usage: Tetriminoes.sh
# Description: Tetrimino arrays for terminal Tetris.
# Author: Colin Shea
# Created: 2016-01-12

# Rotation data for each system
# note: values assume rotation state as illustrated in array declaration
#       initial spawn state may be different depending on system used

declare -a length
# length (rows)
length[0]=1414 # I
length[1]=2323 # J
length[2]=2323 # L
length[3]=2323 # S
length[4]=2323 # Z
length[5]=2323 # T
length[6]=2222 # O

declare -a start
start[0]=0156  # I
start[1]=0257  # J
start[2]=0257  # L
start[3]=0257  # S
start[4]=0257  # Z
start[5]=0257  # T
start[6]=0246  # O

# basic rotation 
declare -a rotation_system
rotation_system[0]="ORS"   # Original
rotation_system[1]="NRSR"  # Nintendo RH
rotation_system[2]="NRSL"  # Nintendo LH
rotation_system[3]="SEGA"  # Sega
rotation_system[4]="ARS"   # Arika
rotation_system[5]="DRS"   # DTET
rotation_system[6]="SRS"   # Super
rotation_system[7]="TNT"   # The New Tetris

# rotation_system[tetrimino]=x_offset,y_offset x4

# ORS
ORS[0]=01200120 # I
ORS[1]=00100100 # J
ORS[2]=00100100 # L
ORS[3]=01100110 # S
ORS[4]=01100110 # Z
ORS[5]=00100100 # T
ORS[6]=00000000 # O
# NRS-R
NRSR[0]=02200220
NRSR[1]=00100100
NRSR[2]=00100100
NRSR[3]=01100110
NRSR[4]=01100110
NRSR[5]=00100100
NRSR[6]=00000000
# NRS-L
NRSL[0]=02200220
NRSL[1]=00100100
NRSL[2]=00100100
NRSL[3]=01100110
NRSL[4]=01100110
NRSL[5]=00100100
NRSL[6]=00000000
# Sega
SEGA[0]=01200120
SEGA[1]=01100100
SEGA[2]=01100100
SEGA[3]=01000100
SEGA[4]=01100110
SEGA[5]=01100100
SEGA[6]=00000000
# ARS
ARS[0]=01200120
ARS[1]=01100100
ARS[2]=01100100
ARS[3]=01000100
ARS[4]=01100110
ARS[5]=01100100
ARS[6]=00000000
# DRS
DRS[0]=02100220
DRS[1]=01100100
DRS[2]=01100100
DRS[3]=01000110
DRS[4]=01000110
DRS[5]=01100100
DRS[6]=00000000
# SRS
SRS[0]=01200210
SRS[1]=00100100
SRS[2]=00100100
SRS[3]=00100100
SRS[4]=00100100
SRS[5]=00100100
SRS[6]=00000000
# TNT
TNT[0]=02100210
TNT[1]=00100010
TNT[2]=00000000
TNT[3]=00100010
TNT[4]=00000000
TNT[5]=00100100
TNT[6]=00000000

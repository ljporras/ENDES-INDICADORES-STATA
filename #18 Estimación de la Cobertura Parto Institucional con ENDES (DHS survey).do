cd "D:\ENDES" 
*Year: 2017

*Bajar los siguientes modulos, descomprimir las carpetas y pasarlos a Stata:
*605-Modulo66\rec0111.dbf
*Modulo67\rec21.dbf
*605-Modulo66\rec91.dbf
*Modulo69\rec41.dbf

*Juntar los archivos
use  Modulo69\rec41.dta, clear
merge m:1 CASEID      using 605-Modulo66\rec0111.dta
rename _m m1
merge 1:1 CASEID MIDX using Modulo67\rec21.dta
rename _m m2
merge m:1 CASEID      using 605-Modulo66\rec91.dta
rename _m m3
save rec41_rec0111_rec21_rec91.dta, replace

use rec41_rec0111_rec21_rec91.dta, clear
*Generamos la variable peso
gen peso=V005/1000000

*Etiquetando la región natural
label define SREGION 1 "Lima Metropolitana" 2 "Resto Costa" 3 "Sierra" 4 "Selva" 
label values SREGION SREGION
label var    SREGION "Region Natural"

label define V025 1 "Urbano" 2 "Rural"
label values V025 V025

*Generando la variable "parto institucional"
*Parto en establecimiento de salud
recode M15 (21 22 23 24 25 26 27 31 32 41 42=1) (11 12 13 96=2), gen(parto_establ)
label define parto_establ 1 "Si" 2 "No"  
label values parto_establ parto_establ
label var    parto_establ "Parto en establecimiento de salud"

*Parto atendido por profesional de Salud
gen          parto_pers=2          if M3N==0 | M3N==1
replace      parto_pers=1          if M3A==1 | M3B==1 | M3C==1
label define parto_pers 1 "Pers Salud" 2 "Otro- Nadie"  
label values parto_pers parto_pers
label var    parto_pers "Parto atendido por prof salud"

*Parto institucional
recode       parto_establ (2 1 = 2), gen(parto_institucional)
replace      parto_institucional=1 if parto_establ==1 & parto_pers==1
label define parto_institucional 1 "Si" 2 "No"  
label values parto_institucional parto_institucional
label var    parto_institucional "Parto en Establecimiento y atendido por prof. de salud"

* Establecemos el diseño muestral: usando las variables factor de expansion, comglomerado y estrato
svyset V001 [w=peso], strata(V022)

* Vemos los descriptivos de la variable pobre tomando en cuenta el diseño muestral
svy: proportion M3A
svy: proportion M3B
svy: proportion M3C

svy: proportion parto_pers 
svy: proportion parto_pers if MIDX==1

svy: proportion parto_institucional if MIDX==1
svy, over(V025):    proportion parto_institucional if MIDX==1
svy, over(SREGION): proportion parto_institucional if MIDX==1

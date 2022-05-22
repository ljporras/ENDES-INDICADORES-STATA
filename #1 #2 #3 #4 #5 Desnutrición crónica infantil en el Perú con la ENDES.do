cd "D:\ENDES" 

*Bajar los siguientes modulos, descomprimir las carpetas y pasarlos a Stata:
*638-Modulo64\rech0.dbf
*638-Modulo64\rech1.dbf
*638-Modulo64\rech4.dbf
*Modulo65\rech23.dbf
*638-Modulo74\RECH6.dbf


*UNIENDO LAS BASES DE DATOS
 use                      Modulo65\rech23.dta, clear
 merge 1:1 HHID using 638-Modulo64\rech0.dta, nogenerate
 save rech0_rech23.dta, replace
 
 use                         638-Modulo64\rech1.dta, clear
 merge 1:1  HHID HC0  using  638-Modulo64\rech4.dta, nogenerate
 merge 1:1  HHID HC0  using  638-Modulo74\RECH6.dta
 rename _m rech6
 save rech1_rech4_rech6.dta, replace
 
 use rech1_rech4_rech6.dta, clear
 merge m:1 HHID using rech0_rech23.dta
 save rech1_rech4_rech6_rech0_rech23.dta, replace
 
 
*GENERANDO LAS VARIABLES USADAS EN LOS TABULADOS
*Generando el PESO y luego lo expandimos
*Utilizar la variable HV005 para calcular resultados departamentales
use rech1_rech4_rech6_rech0_rech23.dta, clear
gen peso =HV005/1000000

tab SHREGION 
label define SHREGION 1 "Lima_Metropolitana" 2 "Resto_Costa" 3 "Sierra" 4 "Selva"
label values SHREGION SHREGION
label var SHREGION "Region Natural"

tab HV025
label define HV025 1 "Urbano" 2 "Rural"
label values HV025 HV025

gen     ambito=0
replace ambito=1 if SHREGION==1
replace ambito=2 if SHREGION==2
replace ambito=3 if SHREGION==3 & HV025==1
replace ambito=4 if SHREGION==3 & HV025==2
replace ambito=5 if SHREGION==4 & HV025==1
replace ambito=6 if SHREGION==4 & HV025==2
label define ambito 1 "Lima_Metropolitana" 2 "Resto_Costa" 3 "Sierra_urbana" 4 "Sierra_rural" 5 "Selva_urbana" 6 "Selva_rural"
label values ambito ambito
label var ambito "Dominio geografico"


*GENERANDO LA VARIABLE "DESNUTRICION CRONICA TOTAL 
*(Niñas y niños que están por debajo de -2 DE de la media)" 
gen          desnwho=1 if HC70<- 200 & HV103==1
replace      desnwho=2 if HC70>=-200 & HC70<601 & HV103==1
label define desnwho 1 "con_desnutricion_cronica" 2 "sin_desnutricion_cronica"
label values desnwho desnwho
label var    desnwho "desnutricion cronica total OMS"
tab HV025 desnwho [iweight=peso], row


*GENERANDO LA VARIABLE "DESNUTRICION CRONICA SEVERA
* (Niñas y niños que están por debajo de -3 DE de la media)"
gen          desn_sev=1 if HC70<-300  & HV103==1
replace      desn_sev=2 if HC70>=-300 & HC70<601 & HV103==1
label define desn_sev 1 "con_desnutricion_cronica_severa" 2 "sin_desnutricion_cronica_severa"
label values desn_sev desn_sev
label var    desn_sev "desnutricion cronica severa OMS"
tab HV025 desn_sev [iweight=peso], row


* Establecemos el diseño muestral
svyset HV001 [w=peso], strata(HV022)


* Vemos los descriptivos de la variable pobre tomando en cuenta el diseño muestral
svy: proportion desnwho
svy: proportion desnwho if HV025==1
svy: proportion desnwho if HV025==2
svy, over(HV025):    proportion desnwho
svy, over(SHREGION): proportion desnwho
svy, over(ambito):   proportion desnwho
*La linea 155 nos brinda los mismos resultados de ejecutar las lines 153 y 154

svy: proportion desn_sev
svy: proportion desn_sev if HV025==1
svy: proportion desn_sev if HV025==2
svy, over(HV025):    proportion desn_sev
svy, over(SHREGION): proportion desn_sev
svy, over(ambito):   proportion desn_sev

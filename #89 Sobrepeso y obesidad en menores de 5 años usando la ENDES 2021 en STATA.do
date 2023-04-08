cd "D:\ENDES" 

**********MODULO1629
*****RECH0
*HV005 Factor de ponderación

*****RECH1
*HV103 ¿Durmió aquí anoche?


**********MODULO1630
*****RECH23
*SHREGION Región natural


**********MODULO1638
*****RECH6
*HC72 Peso/Talla Desviación Estándar de la mediana de referencia (según la OMS)


*UNIENDO LAS BASES DE DATOS
use                   rech23.dta, clear
merge 1:1 HHID using  rech0.dta, nogenerate
save rech0_rech23.dta, replace

use                         rech1.dta, clear
rename    HVIDX HC0
merge 1:1  HHID HC0  using  rech6.dta 
rename _m rech6 
save      rech1_rech6.dta, replace

use                  rech1_rech6.dta, clear
merge m:1 HHID using rech0_rech23.dta
save rech1_rech6_rech0_rech23.dta, replace
 
 
*GENERANDO LAS VARIABLES USADAS EN LOS TABULADOS
*Nota: Se consideró Sobrepeso (Peso/Talla >2 Y <=3) y Obesidad (Peso/Talla >3)
*Overweight: Number of children whose weight-for-height z-score is above plus 2 (+2.0) standard deviations (SD) above the mean on the WHO Child Growth Standards (hc72 > 200 & hc72 < 9990)

use rech1_rech6_rech0_rech23.dta, clear

*Factor de ponderacion
gen peso =HV005/1000000

recode SHREGION (1/2=1 "Costa")(3=2 "Sierra")(4=3 "Selva"), gen(REGION) 

*Prevalencia combinada de sobrepeso y obesidad (por peso/talla)
gen          nt_ch_ovwt_ht= 0 if HV103==1
replace      nt_ch_ovwt_ht=.  if HC72>=9996
replace      nt_ch_ovwt_ht=1  if HC72>200 & HC72<9996 & HV103==1 
label define nt_ch_ovwt_ht 0 "s_sobre_obes" 1 "c_sobre_obes" 
label values nt_ch_ovwt_ht nt_ch_ovwt_ht
label var    nt_ch_ovwt_ht "Sobrepeso y obesidad en menores de 5 ahnos"

tab   REGION nt_ch_ovwt_ht    [iweight=peso] , nofreq row

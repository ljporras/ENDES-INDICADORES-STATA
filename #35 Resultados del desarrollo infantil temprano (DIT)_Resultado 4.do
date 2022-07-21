/* INDICADOR:
 Porcentaje de niñas y niños de 9 a 36 meses con comunicacion verbal a nivel 
 comprensivo y expresivo apropiada para su edad (Resultado 4 de DIT)
 
-archivos rec0111 & rec91 del modulo 66
-archivo rec21 del modulo 67
-archivo DIT del modulo 70  */

*Establecer carpeta de trabajo
cd "D:\ENDES"

** Importar los archivos del formato dbf a Stata
import dbase DIT.dbf, clear
save         DIT.dta, replace

import dbase REC21.dbf, clear
save         REC21.dta, replace

import dbase REC0111.dbf, clear
save         REC0111.dta, replace

import dbase REC91.dbf, clear
save         REC91.dta, replace


** Merge datasets :
use DIT.dta,clear 
merge 1:1 CASEID BIDX using "rec21",keep(master match)keepusing(B4) nogen

merge m:1 CASEID using "rec0111",keep(master match)keepusing(V001 V005 V012 V022 V024 V025 V149 V190) nogen

merge m:1 CASEID using "rec91",keep(master match)keepusing(SREGION S119 S108N) nogen
	
	
** Variables para cruzar:
label define SREGION 1 "Lima_Metropolitana" 2 "Resto_Costa" 3 "Sierra" 4 "Selva"
label values SREGION SREGION
label var SREGION "Region Natural"

label define V025 1 "Urbano" 2 "Rural"
label values V025 V025

label define B4 1 "NIÑO" 2 "NIÑA"
label values B4 B4

label define V190 1 "Quintil inferior" 2 "Segundo quintil" 3 "Quintil intermedio" ///
 4 "Cuarto quintil" 5 "Quintil superior"
label values V190 V190

gen     educa=1 if V149<3
replace educa=2 if V149>2 &  V149<5
replace educa=3 if V149==5
label define educa 1 "Sin nivel/Primaria" 2 "Secundaria" 3 "Superior"
label values educa educa

** cambiar de mayusculas a minusculas los nombres de las variables
rename (QI478E3 QI478E4 QI478E5 QI478A QI478 QI478 QI478F3 QI478F4 QI478F5 /// 
  QI478G1 QI478G2_A QI478G2_B QI478G2_C QI478G3 QI478H1 QI478H2 QI478H3) ///
 (qi478e3 qi478e4 qi478e5 qi478a qi478 qi478 qi478f3 qi478f4 qi478f5 /// 
  qi478g1 qi478g2_a qi478g2_b qi478g2_c qi478g3 qi478h1 qi478h2 qi478h3) 
 
 
** Indicador :
* 9-12 meses
recode qi478e3 (1=1)(2=0)(else=.), gen(e3conv)
recode qi478e4 (1=1)(2=0)(else=.), gen(e4conv)
recode qi478e5 (1=1)(2=0)(else=.), gen(e5conv)

*QI478A=0: Vivir con su madre y No tener diagnóstico de una discapacidad permanente.  

gen    e345 = e3conv + e4conv + e5conv if (qi478a==0 & (qi478>=9 & qi478<=12))
recode e345 (0/2=0 "No") (3=1 "Si"), gen(R4_9_12m)

lab var    R4_9_12m "nin@s 9-12 meses con comunicacion efectiva para su edad (No riesgo)"
lab values R4_9_12m R4_9_12m

* 13-18 meses
recode qi478f3 (1=1) (2=0) (else=.), gen(f3conv)
recode qi478f4 (1=1) (2=0) (else=.), gen(f4conv)
recode qi478f5 (1=1) (2=0) (else=.), gen(f5conv)

gen    f345 = f3conv + f4conv + f5conv if (qi478a==0 & (qi478>=13 & qi478<=18))
recode f345 (0/2=0 "No") (3=1 "Si"), gen(R4_13_18m)

lab var    R4_13_18m "nin@s 13-18 meses con comunicacion efectiva para su edad (No riesgo)"
lab values R4_13_18m R4_13_18m

* 19-23 meses
recode qi478g1 	 (1=1) (2=0) (else=.), gen(g1conv)
recode qi478g2_a (1=1) (2=0) (else=.), gen(g2aconv)
recode qi478g2_b (1=1) (2=0) (else=.), gen(g2bconv)
recode qi478g2_c (1=1) (2=0) (else=.), gen(g2cconv)
recode qi478g3   (1=1) (2=0) (else=.), gen(g3conv)

gen g2abc = ((g2aconv + g2bconv + g2cconv)/3)
gen    g345  = int(g1conv + g2abc + g3conv)
recode g345 (0/2=0 "No") (3=1 "Si") if (qi478a==0 & (qi478>=19 & qi478<=23)), gen(R4_19_23m) 

lab var    R4_19_23m "nin@s 19-23 meses con comunicacion efectiva para su edad (No riesgo)"
lab values R4_19_23m R4_19_23m

* 24-36 meses
recode qi478h1 (1=1) (2=0) (else=.), gen(h1conv)
recode qi478h2 (1=1) (2=0) (else=.), gen(h2conv)
recode qi478h3 (1=1) (2=0) (else=.), gen(h3conv)
gen    h345 = h1conv + h2conv + h3conv if (qi478a==0 & (qi478>=24 & qi478<=36))

recode h345 (0/2=0 "No") (3=1 "Si"), gen(R4_24_36m)
lab var    R4_24_36m "nin@s 24-36 meses con comunicacion efectiva para su edad (No riesgo)"
lab values R4_24_36m R4_24_36m

* Para el R4 
egen R4 = rowtotal(R4_9_12m R4_13_18m R4_19_23m R4_24_36m) /// 
	if !missing(R4_9_12m) | !missing(R4_13_18m) | !missing(R4_19_23m) | !missing(R4_24_36m)

lab var    R4 "Resultado 4: comunicacion efectiva"
lab define R4 1 "Si" 0 "No"
lab values R4 R4

********************************************************************************
*Estableciendo el disehno de muestra*
*V001: conglomerado, V022: estrato, peso=V005/1000000
gen    peso = V005/1000000

svyset V001 [pw=peso], strata(V022) vce(linearized) singleunit(centered)
********************************************************************************

tab R4 [iw=peso]			/*Indicador R4*/

tab R4 V025 [iw=peso], nofreq col	
graph bar  [aw=peso], over(R4) over(V025) asyvars blabel(bar, format(%9.1f)) ///
 percentages title("Nin@s 9-36 meses con comunicacion efectiva x area de residencia")
 
tab R4 SREGION [iw=peso], nofreq col		
graph bar  [aw=peso], over(R4) over(SREGION) asyvars blabel(bar, format(%9.1f)) ///
 percentages title("Nin@s 9-36 meses con comunicacion efectiva x region natural")

tab R4 B4 [iw=peso], nofreq col	

tab R4 educa [iw=peso], nofreq col	

tab R4 V190 [iw=peso], nofreq col	

tab V024 R4 [iw=peso], nofreq row	

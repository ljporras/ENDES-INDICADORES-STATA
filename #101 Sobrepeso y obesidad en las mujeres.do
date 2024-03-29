
*Especificamos nuestra carpeta de trabajo
cd "D:\ENDES"

/* "IMC promedio"
*El Índice de Masa Corporal (IMC) se expresa en kilogramos por metro cuadrado, es decir, 
*Es el cociente entre el peso (expresado en kg) y el cuadrado de la talla (expresado en metros)

Sobrepeso/obesa	>=25,0      Total sobrepeso / obesa
Sobrepeso/obesa	25,0-29,9   Solo sobrepeso
Sobrepeso/obesa	>=30,0      Solo obesa     

*CASEID: Identificación a nivel mujer
*B0   Parto unico o multiple
*B3   Fecha de nacimiento del hij@
*V008 Fecha de la entrevista, Codificación centenaria de meses (CMC)
*V012 Edad actual
*V213 Actualmente embarazada
*V445 Índice de masa corporal para la Mujer Edad Fertil (MEF) */


use "rec0111", clear
merge 1:m CASEID using "rec21", nogen
foreach v of var * {
	rename `v' `=lower("`v'")'
}

* Age of most recent child
gen age =v008-b3

* Mantenemos solo a las mujeres con algún nacimiento en los dos meses anteriores
keep if age<2
sort caseid
duplicates tag caseid, gen(dup)

* Sacar los casos de nacimientos multiples
drop if dup==1 & b0==2
save rec0111_rec21_aux.dta, replace


use "rec0111", clear
merge 1:1 CASEID using "rec91", nogen
merge 1:1 CASEID using "re223132", nogen
merge 1:1 CASEID using "REC42", nogen
foreach v of var * {
	rename `v' `=lower("`v'")'
}

merge 1:1 caseid using "rec0111_rec21_aux"
keep if _m==1

* Edad 15-49
drop if v012<15 | v012>49

* Excluye mujeres embarazadas 
drop if v213==1 

* Factor de ponderacion
gen wt=v005/1000000

* Label sino
cap label define sino 0 "No" 1 "Si"

gen aux=9998

gen          nt_wm_ovobese= inrange(v445,2500,6000) if inrange(v445,1200,aux)
label values nt_wm_ovobese sino
label var    nt_wm_ovobese ">=25.0 Total sobrepeso / obesidad"

gen          nt_wm_ovwt= inrange(v445,2500,2999) if inrange(v445,1200,aux)
label values nt_wm_ovwt sino
label var    nt_wm_ovwt "25.0-29.9 Solo sobrepeso"

gen          nt_wm_obese= inrange(v445,3000,6000) if inrange(v445,1200,aux)
label values nt_wm_obese sino
label var    nt_wm_obese ">=30.0 Solo obesidad"


* Estado nutricional de las mujeres por area de residencia
tab v025 nt_wm_ovobese [iw=wt], row nofreq 

tab v025 nt_wm_ovwt  [iw=wt], row nofreq 

tab v025 nt_wm_obese [iw=wt], row nofreq 

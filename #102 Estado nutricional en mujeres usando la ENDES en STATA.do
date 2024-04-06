
*Especificamos nuestra carpeta de trabajo
cd "D:\ENDES"

/* "IMC promedio"
*El Índice de Masa Corporal (IMC) se expresa en kilogramos por metro cuadrado, es decir, 
*Es el cociente entre el peso (expresado en kg) y el cuadrado de la talla (expresado en metros)

Normal	18,5-24,9 normal
	
Delgada	<18,5       Total delgada
Delgada	17,0-18,4   Ligeramente delgada
Delgada	<17         Moderada y severamente delgada

*V008 Fecha de la entrevista, Codificación centenaria de meses (CMC)
*V025 Tipo de lugar de residencia
*V024 Región
*V106 Nivel educativo más alto"	
*V190 Índice de riqueza
*V208 Nacimientos en los últimos cinco años
*V213 Actualmente embarazada
*V438 Talla de entrevistada (cms-1d)
*V445 Índice de masa corporal para la MEF	*/


*CASEID: Identificación a nivel mujer
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

* Riqueza
recode v190 (1=1 "1er_quintil")(2=2 "2do_quintil")(3=3 "3er_quintil") ///
(4=4 "4to_quintil")(5=5 "5to_quintil"), gen(quintil)

* Region
recode sregion (1/2=1 "Costa")(3=2 "Sierra")(4=3 "Selva"), gen(region) 

* Edad 
recode v013 (1=1 "15-19")(2/3=2 "20-29")(4/5=3 "30-39")(6/7=4 "40-49"), gen(agecat)

* Edad 15-49
drop if v012<15 | v012>49

* Excluye mujeres embarazadas 
drop if v213==1 

* Factor de ponderacion
gen wt=v005/1000000

* Label sino
cap label define sino 0 "No" 1 "Si"

gen aux=9998

gen          nt_wm_norm= inrange(v445,1850,2499) if inrange(v445,1200,aux)
label values nt_wm_norm sino
label var    nt_wm_norm "18.5-24.9 IMC Normal"

gen          nt_wm_thin= inrange(v445,1200,1849) if inrange(v445,1200,aux)
label values nt_wm_thin sino
label var    nt_wm_thin "<18.5 Total delgada"

gen          nt_wm_mthin= inrange(v445,1700,1849) if inrange(v445,1200,aux)
label values nt_wm_mthin sino
label var    nt_wm_mthin "17.0-18.4 Ligeramente delgada"

gen          nt_wm_modsevthin= inrange(v445,1200,1699) if inrange(v445,1200,aux)
label values nt_wm_modsevthin sino
label var    nt_wm_modsevthin "<17 Moderada y severamente delgada"

********************************************************************************
* Estado nutricional de las mujeres

//18.5-24.9 IMC Normal
*Edad
tab agecat nt_wm_norm [iw=wt], row nofreq 

*Educacion
tab v106 nt_wm_norm [iw=wt], row nofreq 

*Riqueza
tab quintil nt_wm_norm [iw=wt], row nofreq 

//<18.5 Total delgada
*age
tab agecat nt_wm_thin [iw=wt], row nofreq 

*education
tab v106 nt_wm_thin [iw=wt], row nofreq 

*wealth
tab quintil nt_wm_thin [iw=wt], row nofreq 


//17.0-18.4 Ligeramente delgada
*age
tab agecat nt_wm_mthin [iw=wt], row nofreq 

*education
tab v106 nt_wm_mthin [iw=wt], row nofreq 

*wealth
tab quintil nt_wm_mthin [iw=wt], row nofreq 


//<17 Moderada y severamente delgada
*age
tab agecat nt_wm_modsevthin [iw=wt], row nofreq 

*education
tab v106 nt_wm_modsevthin [iw=wt], row nofreq 

*wealth
tab quintil nt_wm_modsevthin [iw=wt], row nofreq 

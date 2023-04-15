
*Especificamos nuestra carpeta de trabajo
cd "G:\ENDES"


*Modulo1631\REC0111
*Modulo1631\REC91
*Modulo1632\RE223132
*Modulo1634\REC42

*CASEID: Identificación a nivel mujer

use                    "rec0111", clear
merge 1:1 CASEID using "rec91", nogen
merge 1:1 CASEID using "re223132", nogen
merge 1:1 CASEID using "rec42", nogen
save rec0111_rec91_re223132_rec42.dta, replace

use  rec0111_rec91_re223132_rec42.dta, clear

foreach v of var * {
	rename `v' `=lower("`v'")'
}


*V013 Edad actual por grupos de 5 años
*V025 Tipo de lugar de residencia
*V024 Región
*V106 Nivel educativo más alto"	
*V190 Índice de riqueza
*V438 Talla de entrevistada (cms-1d)

* Edad 
recode v013 (1=1 "15-19") (2/3=2 "20-29") (4/5=3 "30-39") (6/7=4 "40-49"), gen(agecat)

* Edad 15-49
drop if v012<15 | v012>49

* Region
recode sregion (1/2=1 "Costa")(3=2 "Sierra")(4=3 "Selva"), gen(region) 

* Factor de ponderacion
gen wt=v005/1000000

cap label define sino 0 "No" 1 "Si"


//Talla promedio en cm.
gen       talla=v438/10 if inrange(v438,1300,2200)
label var talla "Talla en cm."

*Edad
tabstat talla [aw=wt] , s(mean) by(agecat) format(%9.1f)	

*Nivel de educación
tabstat talla [aw=wt] , s(mean) by(v106) format(%9.1f)	

*Quintil de riqueza
tabstat talla [aw=wt] , s(mean) by(v190) format(%9.1f)	

*Área de residencia
tabstat talla [aw=wt] , s(mean) by(v025) format(%9.1f)

*Región natural
tabstat talla [aw=wt] , s(mean) by(region) format(%9.1f)

*Departamento
tabstat talla [aw=wt] , s(mean) by(v024) format(%9.1f)




//Talla por debajo 145cm
gen          nt_wm_ht= v438<1450 if inrange(v438,1300,2200)
label values nt_wm_ht sino
label var    nt_wm_ht "Talla por debajo 145cm"

*Edad
tab agecat nt_wm_ht [iw=wt], row nofreq 

*Nivel de educación
tab v106   nt_wm_ht [iw=wt], row nofreq 

*Quintil de riqueza
tab v190   nt_wm_ht [iw=wt], row nofreq 

*Área de residencia
tab v025   nt_wm_ht [iw=wt], row nofreq 

*Región natural
tab region nt_wm_ht [iw=wt], row nofreq 

*Departamento
tab v024   nt_wm_ht [iw=wt], row nofreq 

*Pasarlo al excel
tabout agecat v025 v024 v106 v190 nt_wm_ht using Tables_nut_wm.xls [iw=wt] , c(row) f(1) replace 

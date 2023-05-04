*EMPODERAMIENTO DE LAS MUJERES
*Aceptacion de la violencia fisica


*Especificamos nuestra carpeta de trabajo
cd "G:\ENDES2021"


*Unir las bases CASEID: Identificación a nivel mujer
use                    "760-Modulo1635\re516171.dta", clear
merge 1:1 CASEID using "760-Modulo1636\RE758081.dta", nogenerate
merge 1:1 CASEID using "760-Modulo1631\REC0111.dta", nogenerate
merge 1:1 CASEID using "760-Modulo1632\RE223132.dta", nogenerate

*Pasar a minusculas
foreach v of var * {
	rename `v' `=lower("`v'")'
}
save empoderamiento.dta, replace


*Opcional
clear
unicode analyze "empoderamiento.dta"
unicode encoding set "latin1" 
unicode translate "empoderamiento.dta"


use empoderamiento.dta, clear
*V005 Factor de ponderacion
*V012 Edad actual - entrevistada
*V013 Edad actual por grupos de 5 años
*V024 Región
*V025 Tipo de lugar de residencia
*V106 Nivel educativo más alto
*V190 Índice de riqueza
*V218 Número de niños vivos
*V502 Actualmente, antes o nunca sacada


* Etiqueta para los indicadores
label define nosi 0 "No" 1 "Si"

* Factor de expansion
gen wt=v005/1000000

* Edad: 15-49
drop if v012<15 | v012>49

label var v013 "Edad actual por grupos de 5 ahnos"
label define v013 0 "12-14" 1"15-19" 2"20-24" 3"25-29" ///
 4"30-34" 5"35-39" 6"40-44" 7"45-49"
label values v013 v013

* Nivel educativo
label var    v106 "Nivel educativo mas alto"
label define v106 0 "Sin_educacion" 1 "Primaria" 2 "Secundaria" 3 "Superior"
label values v106 v106

* Indice de riqueza
label var v190 "Indice de riqueza"
label define v190 1 "Quintil_inferior" 2 "Segundo_quintil" 3 "Quintil_intermedio" ///
 4 "Cuarto_quintil" 5 "Quintil_superior"
label values v190 v190

* # de hijos(as)
recode v218 (0=0 "sin hijos") (1/2=1 "1-2 hijos") (3/4=2 "3-4 hijos") (5/max=3 "5+ hijos") (99 . =.), gen(numch)
replace   numch=. if v218==.
label var numch "Numero de hijos(as)"

*Region
label var v024 "Region"
label define v024 1 "Amazonas" 2 "Ancash" 3 "Apurimac" 4 "Arequipa" 5 "Ayacucho" 6 "Cajamarca" 7 "Callao" ///
 8 "Cusco" 9 "Huancavelica" 10 "Huanuco" 11"Ica" 12  "Junin"13  "La Libertad" ///
 14  "Lambayeque" 15  "Lima" 16  "Loreto"17  "Madre de Dios"18  "Moquegua" ///
 19  "Pasco" 20  "Piura" 21  "Puno" 22  "San Martin" 23  "Tacna" 24  "Tumbes" 25  "Ucayali"
label values v024 v024



* Aceptacion de la violencia fisica
********************************************************************************
********************************************************************************
*** Está de acuerdo si golpea a su esposa:***
*V744A Está de acuerdo si golpea a su esposa: si sale sin decirle
*V744B Está de acuerdo si golpea a su esposa: si descuida a los niños
*V744C Está de acuerdo si golpea a su esposa: si ella discute con él
*V744D Está de acuerdo si golpea a su esposa: si ella se niega a tener relaciones sexuales con él
*V744E Está de acuerdo si golpea a su esposa: si ella quema la comida
gen          we_dvjustify_goout= v744a==1
label values we_dvjustify_goout nosi
label var    we_dvjustify_goout "Esta de acuerdo: si sale sin decirle"

gen          we_dvjustify_neglect= v744b==1
label values we_dvjustify_neglect nosi
label var    we_dvjustify_neglect "Esta de acuerdo: si descuida a los nihnos"

gen          we_dvjustify_argue= v744c==1
label values we_dvjustify_argue nosi
label var    we_dvjustify_argue "Esta de acuerdo: si ella discute con él"

gen          we_dvjustify_refusesex= v744d==1
label values we_dvjustify_refusesex nosi
label var    we_dvjustify_refusesex "Esta de acuerdo: si ella se niega a tener relaciones sexuales con el"

gen          we_dvjustify_burn= v744e==1
label values we_dvjustify_burn nosi
label var    we_dvjustify_burn "Esta de acuerdo: si ella quema la comida"

gen          we_dvjustify_onereas=0 
replace      we_dvjustify_onereas=1 if v744a==1 | v744b==1 | v744c==1 | v744d==1 | v744e==1
label values we_dvjustify_onereas nosi
label var    we_dvjustify_onereas "Esta de acuerdo: al menos una de las razones"

*Está de acuerdo si golpea a su esposa: si sale sin decirle, si descuida a los niños, si discute con él, si se niega a tener relaciones sexuales, si quema la comida
tab1   we_dvjustify_goout we_dvjustify_neglect we_dvjustify_argue we_dvjustify_refusesex we_dvjustify_burn [iw=wt]

//Está de acuerdo si golpea a su esposa: si ella discute con él
*edad
tab v013 we_dvjustify_argue [iw=wt], row nofreq 

*# de nihnos
tab numch we_dvjustify_argue [iw=wt], row nofreq 

*estado marital
tab v502 we_dvjustify_argue [iw=wt], row nofreq 

*area de residencia
tab v025 we_dvjustify_argue [iw=wt], row nofreq 

*region
tab v024 we_dvjustify_argue [iw=wt], row nofreq 

*educacion
tab v106 we_dvjustify_argue [iw=wt], row nofreq 

*riqueza
tab v190 we_dvjustify_argue [iw=wt], row nofreq 

//Está de acuerdo si golpea a su esposa: si sale sin decirle
*edad
tab v013 we_dvjustify_goout [iw=wt], row nofreq 

*# de nihnos
tab numch we_dvjustify_goout [iw=wt], row nofreq 

*estado marital
tab v502 we_dvjustify_goout [iw=wt], row nofreq 

*area de residencia
tab v025 we_dvjustify_goout [iw=wt], row nofreq 

*region
tab v024 we_dvjustify_goout [iw=wt], row nofreq 

*educacion
tab v106 we_dvjustify_goout [iw=wt], row nofreq 

*riqueza
tab v190 we_dvjustify_goout [iw=wt], row nofreq 

//Está de acuerdo si golpea a su esposa: si descuida a los niños
*edad
tab v013 we_dvjustify_neglect [iw=wt], row nofreq 


*# de nihnos
tab numch we_dvjustify_neglect [iw=wt], row nofreq 

*estado marital
tab v502 we_dvjustify_neglect [iw=wt], row nofreq 

*area de residencia
tab v025 we_dvjustify_neglect [iw=wt], row nofreq 

*region
tab v024 we_dvjustify_neglect [iw=wt], row nofreq 

*educacion
tab v106 we_dvjustify_neglect [iw=wt], row nofreq 

*riqueza
tab v190 we_dvjustify_neglect [iw=wt], row nofreq 

//Está de acuerdo si golpea a su esposa: si ella se niega a tener relaciones sexuales con él
*edad
tab v013 we_dvjustify_refusesex [iw=wt], row nofreq 

*# de nihnos
tab numch we_dvjustify_refusesex [iw=wt], row nofreq 

*estado marital
tab v502 we_dvjustify_refusesex [iw=wt], row nofreq 

*area de residencia
tab v025 we_dvjustify_refusesex [iw=wt], row nofreq 

*region
tab v024 we_dvjustify_refusesex [iw=wt], row nofreq 

*educacion
tab v106 we_dvjustify_refusesex [iw=wt], row nofreq 

*riqueza
tab v190 we_dvjustify_refusesex [iw=wt], row nofreq 

//Está de acuerdo si golpea a su esposa: si ella quema la comida
*edad
tab v013 we_dvjustify_burn [iw=wt], row nofreq 

*# de nihnos
tab numch we_dvjustify_burn [iw=wt], row nofreq 

*estado marital
tab v502 we_dvjustify_burn [iw=wt], row nofreq 

*area de residencia
tab v025 we_dvjustify_burn [iw=wt], row nofreq 

*region
tab v024 we_dvjustify_burn [iw=wt], row nofreq 

*educacion
tab v106 we_dvjustify_burn [iw=wt], row nofreq 

*riqueza
tab v190 we_dvjustify_burn [iw=wt], row nofreq 


//Está de acuerdo si golpea a su esposa: al menos una de las razones
*edad
tab v013 we_dvjustify_onereas [iw=wt], row nofreq 

*# de nihnos
tab numch we_dvjustify_onereas [iw=wt], row nofreq 

*estado marital
tab v502 we_dvjustify_onereas [iw=wt], row nofreq 

*area de residencia
tab v025 we_dvjustify_onereas [iw=wt], row nofreq 

*region
tab v024 we_dvjustify_onereas [iw=wt], row nofreq 

*educacion
tab v106 we_dvjustify_onereas [iw=wt], row nofreq 

*riqueza
tab v190 we_dvjustify_onereas [iw=wt], row nofreq 


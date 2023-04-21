*EMPODERAMIENTO DE LAS MUJERES
*Toma de decisiones


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


use empoderamiento.dta, clear
*V005 Factor de ponderacion
*V012 Edad actual - entrevistada
*V013 Edad actual por grupos de 5 años
*V024 Región
*V025 Tipo de lugar de residencia
*V106 Nivel educativo más alto
*V190 Índice de riqueza
*V218 Número de niños vivos
*V502 Actualmente, antes o nunca casada


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

label define quien 0 "Nadie" 1 "Entrevistada" 2 "Ambos" 3 "Entrevistada y alguien mas" ///
 4 "Solo la pareja" 5 "Alguien mas" 6 "Otro"
 
* Toma de decisiones
********************************************************************************
********************************************************************************
*V743A Quién tiene la última palabra sobre: cuidado de su salud
*V743B Quién tiene la última palabra sobre: compras grandes del hogar
*V743C Quién tiene la última palabra sobre: compras para necesidades diarias del hogar
*V743D Quién tiene la última palabra sobre: visitar a familia, amigos o parientes
*** Quién tiene la última palabra sobre: ***
gen          we_decide_health= v743a if v502==1
label values we_decide_health quien
label var    we_decide_health "Decide sobre cuidado de su salud"

gen          we_decide_hhpurch= v743b if v502==1
label values we_decide_hhpurch quien
label var    we_decide_hhpurch "Decide sobre compras grandes del hogar"

gen          we_decide_hhdaily= v743c if v502==1
label values we_decide_hhdaily quien
label var    we_decide_hhdaily "Decide sobre compras diarias del hogar"

gen          we_decide_visits= v743d if v502==1
label values we_decide_visits quien
label var    we_decide_visits "Decide sobre visitar a familia, amigos o parientes"


recode       we_decide_health (0 3 4 5 6=0 "No") (1/2=1 "Si") (99 . =.), gen(we_decide_health_self)
label var    we_decide_health_self "Decide sobre cuidado de su salud: sola o con su pareja"

recode       we_decide_hhpurch (0 3 4 5 6=0 "No") (1/2=1 "Si") (99 . =.), gen(we_decide_hhpurch_self)
label var    we_decide_hhpurch_self "Decide sobre compras grandes del hogar: sola o con su pareja"

recode       we_decide_hhdaily (0 3 4 5 6=0 "No") (1/2=1 "Si") (99 . =.), gen(we_decide_hhdaily_self)
label var    we_decide_hhdaily_self "Decide sobre compras diarias del hogar: sola o con su pareja"

recode       we_decide_visits (0 3 4 5 6=0 "No") (1/2=1 "Si") (99 . =.), gen(we_decide_visits_self)
label var    we_decide_visits_self "Decide sobre visitar a familia, amigos o parientes: sola o con su pareja"


//Decide en todo: salud, compras grandes, compras diarias y visitas: sola o con su pareja
gen          we_decide_all= inlist(v743a,1,2) & inlist(v743b,1,2) & inlist(v743c,1,2) & inlist(v743d,1,2) if v502==1
label values we_decide_all nosi
label var    we_decide_all "Decide en todo: sola o con su pareja"

//No tiene rol en ninguna de las decisiones
gen          we_decide_none= 0 if v502==1
replace      we_decide_none=1 if (v743a!=1 & v743a!=2) & (v743b!=1 & v743b!=2) & (v743c!=1 & v743c!=2) & (v743d!=1 & v743d!=2)& v502==1
label values we_decide_none nosi
label var    we_decide_none "No tiene rol en ninguna de las decisiones"


*salud, compras grandes, compras diarias y visitas
tab1   we_decide_health we_decide_hhpurch we_decide_hhdaily we_decide_visits [iw=wt]

* output to excel
tabout we_decide_health we_decide_hhpurch we_decide_hhdaily we_decide_visits using Tables_empw_wm.xls [iw=wt] , oneway cells(cell) replace 

//Decide sobre cuidado de su salud: sola o con su pareja
*edad
tab v013 we_decide_health_self [iw=wt], row nofreq 

*# de nihnos
tab numch we_decide_health_self [iw=wt], row nofreq 

*area de residencia
tab v025 we_decide_health_self [iw=wt], row nofreq 

*region
tab v024 we_decide_health_self [iw=wt], row nofreq 

*educacion
tab v106 we_decide_health_self [iw=wt], row nofreq 

*riqueza
tab v190 we_decide_health_self [iw=wt], row nofreq 

* output to excel
tabout v013 numch v025 v106 v024 v190 we_decide_health_self using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 

//Decide sobre compras grandes del hogar: sola o con su pareja
*edad
tab v013 we_decide_hhpurch_self [iw=wt], row nofreq 

*# de nihnos
tab numch we_decide_hhpurch_self [iw=wt], row nofreq 

*area de residencia
tab v025 we_decide_hhpurch_self [iw=wt], row nofreq 

*region
tab v024 we_decide_hhpurch_self [iw=wt], row nofreq 

*educacion
tab v106 we_decide_hhpurch_self [iw=wt], row nofreq 

*riqueza
tab v190 we_decide_hhpurch_self [iw=wt], row nofreq 

* output to excel
tabout v013 numch v025 v106 v024 v190 we_decide_hhpurch_self using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 


//Decide sobre compras diaria del hogar: sola o con su pareja
*edad
tab v013 we_decide_hhdaily_self [iw=wt], row nofreq 

*# de nihnos
tab numch we_decide_hhdaily_self [iw=wt], row nofreq 

*area de residencia
tab v025 we_decide_hhdaily_self [iw=wt], row nofreq 

*region
tab v024 we_decide_hhdaily_self [iw=wt], row nofreq 

*educacion
tab v106 we_decide_hhdaily_self [iw=wt], row nofreq 

*riqueza
tab v190 we_decide_hhdaily_self [iw=wt], row nofreq 

* output to excel
tabout v013 numch v025 v106 v024 v190 we_decide_hhdaily_self using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 


//Decide sobre visitar a familia, amigos o parientes: sola o con su pareja
*edad
tab v013 we_decide_visits_self [iw=wt], row nofreq 

*# de nihnos
tab numch we_decide_visits_self [iw=wt], row nofreq 

*area de residencia
tab v025 we_decide_visits_self [iw=wt], row nofreq 

*region
tab v024 we_decide_visits_self [iw=wt], row nofreq 

*educacion
tab v106 we_decide_visits_self [iw=wt], row nofreq 

*riqueza
tab v190 we_decide_visits_self [iw=wt], row nofreq 

* output to excel
tabout v013 numch v025 v106 v024 v190 we_decide_visits_self using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 


//Decide en todo: salud, compras grandes, compras diarias y visitas: sola o con su pareja
*edad
tab v013 we_decide_all [iw=wt], row nofreq 

*# de nihnos
tab numch we_decide_all [iw=wt], row nofreq 

*area de residencia
tab v025 we_decide_all [iw=wt], row nofreq 

*region
tab v024 we_decide_all [iw=wt], row nofreq 

*educacion
tab v106 we_decide_all [iw=wt], row nofreq 

*riqueza
tab v190 we_decide_all [iw=wt], row nofreq 

* output to excel
tabout v013 numch v025 v106 v024 v190 we_decide_all using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 

//No tiene rol en ninguna de las decisiones
*edad
tab v013 we_decide_none [iw=wt], row nofreq 

*# de nihnos
tab numch we_decide_none [iw=wt], row nofreq 

*area de residencia
tab v025 we_decide_none [iw=wt], row nofreq 

*region
tab v024 we_decide_none [iw=wt], row nofreq 

*educacion
tab v106 we_decide_none [iw=wt], row nofreq 

*riqueza
tab v190 we_decide_none [iw=wt], row nofreq 

* output to excel
tabout v013 numch v025 v106 v024 v190 we_decide_none using Tables_empw_wm.xls [iw=wt] , c(row) f(1) append 


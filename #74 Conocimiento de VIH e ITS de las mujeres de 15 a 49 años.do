*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"

*Descargar, descomprimir los sgtes archivos y pasarlos a Stata:
*Modulo66\rec0111, 
*Modulo66\rec91,
*Modulo71\re516171
*Modulo72\re758081


*Unir los archivos
use rec0111.dta, clear
merge 1:1 caseid using "rec91", nogen
merge 1:1 caseid using "re516171", nogen
merge 1:1 caseid using "re758081", nogen

*Factor de expansion
gen wt=v005/1000000
cap label define nosi 0 "No" 1 "Si"

*Conocimiento de VIH/SIDA y formas de evitar
//Conocimiento de VIH/SIDA
gen hk_ever_heard= v751==1
label values hk_ever_heard nosi
label var hk_ever_heard "Ha oído hablar de una enfermedad llamada SIDA"
tab hk_ever_heard [iweight=wt]  if v012>14

*CONOCIMIENTO DE FORMAS ESPECÍFICAS PARA EVITAR EL VIH
//Limitar el número de parejas sexuales
gen hk_knw_risk_sex= v754dp==1
label values hk_knw_risk_sex nosi
label var hk_knw_risk_sex "Limitar el número de parejas sexuales"
tab v025 hk_knw_risk_sex [iweight=wt]  if v012>14, nofreq row
tab v106 hk_knw_risk_sex [iweight=wt]  if v012>14, nofreq row

//Usar condones
gen hk_knw_risk_cond= v754cp==1
label values hk_knw_risk_cond nosi
label var hk_knw_risk_cond "Usar condones"
tab v025 hk_knw_risk_cond [iweight=wt]  if v012>14, nofreq row
tab v106 hk_knw_risk_cond [iweight=wt]  if v012>14, nofreq row


*CONOCIMIENTO DE ASPECTOS RELACIONADOS CON EL VIH
//Durante el embarazo o parto
gen hk_knw_mtct_preg= (v774a==1) | v774b==1
label values hk_knw_mtct_preg nosi
label var hk_knw_mtct_preg "Durante el embarazo o parto"
tab v025    hk_knw_mtct_preg [iweight=wt]  if v012>14, nofreq row
tab sregion hk_knw_mtct_preg [iweight=wt]  if v012>14, nofreq row
tab v106    hk_knw_mtct_preg [iweight=wt]  if v012>14, nofreq row

//Durante la lactancia
gen hk_knw_mtct_brfeed= v774c==1
label values hk_knw_mtct_brfeed nosi
label var hk_knw_mtct_brfeed "Durante la lactancia"
tab v025    hk_knw_mtct_brfeed [iweight=wt]  if v012>14, nofreq row
tab sregion hk_knw_mtct_brfeed [iweight=wt]  if v012>14, nofreq row
tab v106    hk_knw_mtct_brfeed [iweight=wt]  if v012>14, nofreq row


*PREVALENCIA DE ITS
//le han diagnosticado alguna ITS
gen hk_sti= v763a==1
replace hk_sti=. if v525==0 | v525==96 | v525==.
label values hk_sti nosi
label var hk_sti "En los últimos 12 meses, le han diagnosticado alguna ITS"
tab v025    hk_sti [iweight=wt]  if v012>14, nofreq row
tab sregion hk_sti [iweight=wt]  if v012>14, nofreq row

//ha tenido algùn flujo o secreción genital que olia mal
gen hk_gent_disch= v763c==1
replace hk_gent_disch=. if v525==0 | v525==96 | v525==.
label values hk_gent_disch nosi
label var hk_gent_disch "En los últimos 12 meses, ha tenido algùn flujo o secreción genital que olia mal"
tab v025    hk_gent_disch [iweight=wt]  if v012>14, nofreq row
tab sregion hk_gent_disch [iweight=wt]  if v012>14, nofreq row

//ha tenido alguna llaga o úlceras en sus genitales
gen hk_gent_sore= v763b==1
replace hk_gent_sore=. if v525==0 | v525==96 | v525==.
label values hk_gent_sore nosi
label var hk_gent_sore "En los últimos 12 meses, ha tenido alguna llaga o úlceras en sus genitales"
tab v025    hk_gent_sore [iweight=wt]  if v012>14, nofreq row
tab sregion hk_gent_sore [iweight=wt]  if v012>14, nofreq row

//ha tenido una ITS o flujo vaginal o úlceras/llagas
gen hk_sti_symp= v763a==1 | v763b==1 | v763c==1 
replace hk_sti_symp=. if v525==0 | v525==96 | v525==.
label values hk_sti_symp nosi
label var hk_sti_symp "En los últimos 12 meses, ha tenido una ITS o flujo vaginal o úlceras/llagas"
tab v025    hk_sti_symp [iweight=wt]  if v012>14, nofreq row
tab sregion hk_sti_symp [iweight=wt]  if v012>14, nofreq row

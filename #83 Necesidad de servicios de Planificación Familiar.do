
*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"

*Bajar, descomprimir los sgtes modulos y pasar los siguientes archivos a Stata:
*Modulo66\REC0111.dbf
*Modulo66\REC91.dbf
*Modulo67\RE223132.dbf
*Modulo71\re516171.dbf

use rec0111, clear
merge 1:1 caseid using "rec91", nogen
merge 1:1 caseid using "re223132", nogen
merge 1:1 caseid using "re516171", nogen

/*
V012 Edad actual
V502 "Actualmente, antes o nunca casada"
V626 "Necesidad insatisfecha (def.2)"
*/

*Factor de expansion
gen wt=v005/1000000

*Mujeres actualmente unidas (casadas o convivientes)
recode  v502 (1=1)(0 2=2), gen(unidas)
label define sino 1 "Si" 2 "No"
label values unidas sino
label var unidas "Unidas"

*Demanda de planificacion familiar
recode v626(1 2=1 "Insatisfecha")(3 4=2 "Satisfecha")(nonmiss=3 "Otro") if unidas==1, gen(n_pf)
label var n_pf "Necesidad de Pla. Familiar"

tab v025 n_pf [iweight=wt] if v012>14, nofreq row
tab sregion n_pf [iweight=wt] if v012>14, nofreq row

recode v626(1=1 "NI espaciar")(2=2 "NI limitar")(3=3 "NS espaciar") ///
 (4=4 "NS limitar") (nonmiss=5 "Otro") if unidas==1, gen(n_pf_detalle)
label var n_pf_detalle "Necesidad de Pla. Familiar-detalle"

tab v025 n_pf_detalle [iweight=wt] if v012>14, nofreq row
tab sregion n_pf_detalle [iweight=wt] if v012>14, nofreq row

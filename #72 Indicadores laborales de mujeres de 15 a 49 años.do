
*Especificamos nuestra carpeta de trabajo
cd "E:\ENDES"

*Bajar, descomprimir los sgtes modulos y exportar los siguientes archivos a Stata:
*Modulo66\rec0111
*Modulo66\rec91
*Modulo71\re516171

********************************************************************************
use rec0111, clear
merge 1:1 caseid using "rec91", nogen
merge 1:1 caseid using "re516171", nogen

*Factor de expansion
gen wt=v005/1000000

*Empleo
//Condicion de trabajo
recode v731 (0=3 "No empleada en los últimos 12 meses") /// 
(1=2 "Sin empleo actual pero empleada en los ultimos 12 meses 2/") ///
 (2/3=1 "Actualmente empleada 1/") (8=9 "No sabe/missing"), gen(rc_empl)
label var rc_empl "Condicion de trabajo"
tab v025 rc_empl [iweight=wt]  if v012>14, nofreq row
tab sregion rc_empl [iweight=wt]  if v012>14, nofreq row
tab etnia rc_empl [iweight=wt]  if v012>14, nofreq row
tab lmaterna rc_empl [iweight=wt]  if v012>14, nofreq row

//Grupo de ocupacion
recode v717 (1=1 "Profesional/técnico/gerente") (2=2 "Oficinista") (3 7=3 "Ventas y servicios") /// 
(8=4 "Manual calificado") (9=5 "Manual no calificado") (6=6 "Servicio doméstico") /// 
(4/5=7 "Agricultura") (96/99 .=9 "Sin Información")(nonm =.) if inlist(v731,1,2,3), gen(rc_occup)
label var rc_occup "Grupo de ocupacion"
tab v025 rc_occup [iweight=wt]  if v012>14, nofreq row

recode rc_occup (7=1 "Agrícola") (1/6=2 "No agrícola"), gen(agri)

//Tipo de empleador
gen rc_empl_type=v719 if inlist(v731,1,2,3)
label define rc_empl_type 1 "Empleada por un familiar" 2 "Empleada por otra persona" ///
 3 "Trabajadora independiente"
label values rc_empl_type rc_empl_type
label var rc_empl_type "Tipo de empleador"
tab  rc_empl_type agri [iweight=wt]  if v012>14, nofreq col

//Forma de remuneración
gen rc_empl_earn=v741 if inlist(v731,1,2,3)
label values rc_empl_earn V741
label var rc_empl_earn "Forma de remuneración"
tab  rc_empl_earn agri [iweight=wt]  if v012>14, nofreq col

//Continuidad de trabajo
gen rc_empl_cont=v732 if inlist(v731,1,2,3)
label values rc_empl_cont V732
label var rc_empl_cont "Continuidad de trabajo"
tab  rc_empl_cont agri [iweight=wt]  if v012>14, nofreq col
